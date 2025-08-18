import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:tictactoe/core/constants/app_sounds.dart';
import 'package:tictactoe/domain/controllers/base_game_controller.dart';

class MultiPlayerController extends GameController {
  @override
  Future<void> handleTap(int index, BuildContext context,
      VoidCallback showDialogEndGame, bool isInsaneMode) async {
    if (board[index] == '' && winner == '') {
      await player.stop();
      await player.play(AssetSource(AppSounds.click1));

      board[index] = currentPlayer;

      if (isInsaneMode) {
        List<int> currentHistory =
            currentPlayer == 'X' ? moveHistoryX : moveHistoryO;

        currentHistory.add(index);
        if (currentHistory.length > 3) {
          int removeIndex = currentHistory.removeAt(0);
          board[removeIndex] = '';
        }
      }

      if (checkWinner(currentPlayer)) {
        await player.play(AssetSource(AppSounds.win));
        winner = currentPlayer;

        if (winner == 'X') {
          qtdWinsPlayer1++;
        } else {
          qtdWinsPlayer2++;
        }

        winningLine =
            getWinningLine(currentPlayer); // <--- pega a linha vencedora

        // Apaga todas as peças e mantém apenas as da linha vencedora
        for (int i = 0; i < board.length; i++) {
          if (!winningLine!.contains(i)) {
            board[i] = '';
          }
        }

        notifyListeners();

        Future.delayed(const Duration(milliseconds: 1000), () {
          showDialogEndGame();
          resetGame();
        });

        return;
      } else if (!board.contains('')) {
        // Verifica se deu empate
        await player.play(AssetSource(AppSounds.win));
        notifyListeners();

        Future.delayed(const Duration(milliseconds: 500), () {
          showDialogEndGame();
          resetGame();
        });

        return;
      } else {
        currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
      }

      notifyListeners();
    }
  }

  List<int> getWinningLine(String player) {
    // Todas as combinações possíveis de linhas vencedoras no tabuleiro
    List<List<int>> winningCombinations = [
      [0, 1, 2], // Primeira linha
      [3, 4, 5], // Segunda linha
      [6, 7, 8], // Terceira linha
      [0, 3, 6], // Primeira coluna
      [1, 4, 7], // Segunda coluna
      [2, 5, 8], // Terceira coluna
      [0, 4, 8], // Diagonal principal
      [2, 4, 6], // Diagonal secundária
    ];

    // Percorre todas as combinações possíveis
    for (List<int> combination in winningCombinations) {
      // Verifica se todas as posições na combinação são do jogador atual
      if (board[combination[0]] == player &&
          board[combination[1]] == player &&
          board[combination[2]] == player) {
        // Retorna a combinação vencedora
        return combination;
      }
    }

    // Se nenhuma combinação vencedora for encontrada, retorna uma lista vazia
    return [];
  }
}
