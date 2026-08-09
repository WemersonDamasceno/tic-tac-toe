import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tictactoe/domain/controllers/base_game_controller.dart';

class SinglePlayerController extends GameController {
  @override
  void resetGame({
    BuildContext? context,
    VoidCallback? showDialogEndGame,
    bool isInsaneMode = false,
  }) {
    super.resetGame();

    // Se a IA abre o round, bloqueia os toques enquanto ela não jogar.
    if (currentPlayer == 'O') {
      isTapEnabled = false;

      Future.delayed(const Duration(milliseconds: 500), () {
        if (!isDisposed) {
          _makeAIMove(context, showDialogEndGame ?? () {}, isInsaneMode);
        }
      });
    }
  }

  @override
  void onTurnSwitched(
    BuildContext? context,
    VoidCallback showDialogEndGame,
    bool isInsaneMode,
  ) {
    if (currentPlayer == 'O') {
      // Turno da IA: mantém os toques bloqueados até ela concluir a jogada.
      Future.delayed(const Duration(milliseconds: 500), () {
        if (!isDisposed) {
          _makeAIMove(context, showDialogEndGame, isInsaneMode);
        }
      });
    } else {
      // De volta ao jogador humano.
      Future.delayed(const Duration(milliseconds: 300), () {
        if (!isDisposed) {
          isTapEnabled = true;
        }
      });
    }
  }

  bool _winFor(String player) => checkWinner(player) != null;

  // Função de IA usando o algoritmo Minimax.
  int minimax(List<String> board, int depth, bool isMaximizing) {
    if (_winFor('O')) return 1;
    if (_winFor('X')) return -1;
    if (!board.contains('')) return 0;

    if (isMaximizing) {
      var bestScore = -999;
      for (var i = 0; i < board.length; i++) {
        if (board[i] == '') {
          board[i] = 'O';
          bestScore = max(minimax(board, depth + 1, false), bestScore);
          board[i] = '';
        }
      }
      return bestScore;
    } else {
      var bestScore = 999;
      for (var i = 0; i < board.length; i++) {
        if (board[i] == '') {
          board[i] = 'X';
          bestScore = min(minimax(board, depth + 1, true), bestScore);
          board[i] = '';
        }
      }
      return bestScore;
    }
  }

  Future<void> _makeAIMove(
    BuildContext? context,
    VoidCallback showDialogEndGame,
    bool isInsaneMode,
  ) async {
    var bestScore = -999;
    int? bestMove;

    for (var i = 0; i < board.length; i++) {
      if (board[i] == '') {
        board[i] = 'O';
        final score = minimax(board, 0, false);
        board[i] = '';
        if (score > bestScore) {
          bestScore = score;
          bestMove = i;
        }
      }
    }

    if (bestMove == null) {
      isTapEnabled = true;
      return;
    }

    // Libera os toques para que a própria IA consiga passar pela validação de
    // handleTap. Não há janela assíncrona aqui, então o humano não interfere.
    isTapEnabled = true;
    await handleTap(bestMove, context, showDialogEndGame, isInsaneMode);
  }
}
