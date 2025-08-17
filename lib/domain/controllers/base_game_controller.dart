import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

abstract class GameController extends ChangeNotifier {
  List<String> board = List.generate(9, (index) => '');
  List<int> moveHistoryX = [];
  List<int> moveHistoryO = [];
  String currentPlayer = 'X';
  String winner = '';
  List<int>? winningLine;
  String nextStartingPlayer = 'X'; // alterna entre X e O

  int qtdWinsPlayer1 = 0;
  int qtdWinsPlayer2 = 0;

  final AudioPlayer player = AudioPlayer();

  Future<void> handleTap(
    int index,
    BuildContext context,
    VoidCallback showDialogEndGame,
    bool isInsaneMode,
  );

  bool checkWinner(String player) {
    const List<List<int>> winPatterns = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var pattern in winPatterns) {
      if (board[pattern[0]] == player &&
          board[pattern[1]] == player &&
          board[pattern[2]] == player) {
        winningLine = pattern; // Armazena a linha vencedora
        return true;
      }
    }
    return false;
  }

  void resetGame() {
    disposeController();
    notifyListeners();
  }

  void disposeGame() {
    qtdWinsPlayer1 = 0;
    qtdWinsPlayer2 = 0;

    disposeController();
  }

  void disposeController() {
    board = List.generate(9, (index) => '');

    moveHistoryX.clear();
    moveHistoryO.clear();
    currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
    winner = '';
    winningLine = null; // Reseta a linha vencedora
  }
}
