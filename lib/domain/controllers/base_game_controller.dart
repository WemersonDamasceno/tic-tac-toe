import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:tictactoe/core/constants/app_sounds.dart';

abstract class GameController extends ChangeNotifier {
  static const int maxPieces = 3;
  static const int maxInsaneMovesWithoutWinner = 18;

  static const List<List<int>> winningPatterns = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6],
  ];

  List<String> board = List.generate(9, (_) => '');
  List<int> moveHistoryX = [];
  List<int> moveHistoryO = [];
  String currentPlayer = 'X';
  String winner = '';
  List<int>? winningLine;
  String nextStartingPlayer = 'X';
  bool isTapEnabled = true;
  int movesMade = 0;

  int qtdWinsPlayer1 = 0;
  int qtdWinsPlayer2 = 0;

  AudioPlayer? _player;

  bool _disposed = false;

  bool get isDisposed => _disposed;

  AudioPlayer get player => _player ??= AudioPlayer();

  @override
  void dispose() {
    _disposed = true;
    _player?.dispose();
    super.dispose();
  }

  Future<void> playSound(String source) async {
    await player.stop();
    await player.play(AssetSource(source));
  }

  /// Returns the winning line for [player], or `null` when there is none.
  List<int>? checkWinner(String player) {
    for (final pattern in winningPatterns) {
      if (board[pattern[0]] == player &&
          board[pattern[1]] == player &&
          board[pattern[2]] == player) {
        winningLine = pattern;
        return pattern;
      }
    }
    return null;
  }

  bool checkDraw({required bool isInsaneMode}) {
    if (winner.isNotEmpty) return false;

    if (!isInsaneMode) {
      return !board.contains('');
    }

    // In insane mode the board never fills up (max 6 pieces), so a draw would
    // otherwise never happen and the match could cycle forever. A capped number
    // of moves without a winner is treated as a draw.
    return movesMade >= maxInsaneMovesWithoutWinner;
  }

  void _registerMove(int index, bool isInsaneMode) {
    movesMade++;

    board[index] = currentPlayer;

    final history = currentPlayer == 'X' ? moveHistoryX : moveHistoryO;
    history.add(index);

    // Ao completar mais de 3 peças, a mais antiga é removida e volta a ser
    // jogável (mecânica do modo insane).
    if (isInsaneMode && history.length > maxPieces) {
      board[history.removeAt(0)] = '';
    }
  }

  Future<void> handleTap(
    int index,
    BuildContext? context,
    VoidCallback showDialogEndGame,
    bool isInsaneMode,
  ) async {
    if (board[index] != '' || winner.isNotEmpty || !isTapEnabled) return;

    isTapEnabled = false;
    _registerMove(index, isInsaneMode);

    await playSound(AppSounds.click1);

    final line = checkWinner(currentPlayer);
    if (line != null) {
      winningLine = line;
      winner = currentPlayer;

      if (winner == 'X') {
        qtdWinsPlayer1++;
      } else {
        qtdWinsPlayer2++;
      }

      await playSound(AppSounds.win);

      for (var i = 0; i < board.length; i++) {
        if (!winningLine!.contains(i)) {
          board[i] = '';
        }
      }

      notifyListeners();

      _scheduleEndGame(
        context: context,
        showDialogEndGame: showDialogEndGame,
        isInsaneMode: isInsaneMode,
        delay: const Duration(seconds: 1),
      );
      return;
    }

    if (checkDraw(isInsaneMode: isInsaneMode)) {
      winner = 'DRAW';
      await playSound(AppSounds.win);
      notifyListeners();

      _scheduleEndGame(
        context: context,
        showDialogEndGame: showDialogEndGame,
        isInsaneMode: isInsaneMode,
        delay: const Duration(milliseconds: 500),
      );
      return;
    }

    currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
    notifyListeners();
    onTurnSwitched(context, showDialogEndGame, isInsaneMode);
  }

  /// Hook called after a non-terminal move, letting subclasses decide when the
  /// next player may tap again.
  void onTurnSwitched(
    BuildContext? context,
    VoidCallback showDialogEndGame,
    bool isInsaneMode,
  ) {
    isTapEnabled = true;
  }

  void _scheduleEndGame({
    required BuildContext? context,
    required VoidCallback showDialogEndGame,
    required bool isInsaneMode,
    required Duration delay,
  }) {
    Future.delayed(delay, () {
      if (isDisposed) return;
      showDialogEndGame();
      resetGame(
        context: context,
        showDialogEndGame: showDialogEndGame,
        isInsaneMode: isInsaneMode,
      );
    });
  }

  void resetGame({
    BuildContext? context,
    VoidCallback? showDialogEndGame,
    bool isInsaneMode = false,
  }) {
    disposeController();
    notifyListeners();
  }

  void disposeGame() {
    qtdWinsPlayer1 = 0;
    qtdWinsPlayer2 = 0;
    disposeController();
  }

  void disposeController() {
    board = List.generate(9, (_) => '');
    moveHistoryX.clear();
    moveHistoryO.clear();
    winner = '';
    winningLine = null;
    movesMade = 0;
    isTapEnabled = true;

    currentPlayer = nextStartingPlayer;
    nextStartingPlayer = currentPlayer == 'X' ? 'O' : 'X';
  }
}
