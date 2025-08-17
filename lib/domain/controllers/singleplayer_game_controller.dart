import 'dart:math'; // Importa a biblioteca de matemática para usar o max e min

import 'package:audioplayers/audioplayers.dart'; // Importa o pacote de áudio para tocar sons
import 'package:flutter/material.dart'; // Importa o Flutter para construir a interface do usuário
import 'package:tictactoe/core/constants/app_sounds.dart'; // Importa constantes de sons personalizados
import 'package:tictactoe/domain/controllers/base_game_controller.dart'; // Importa o controlador base do jogo

class SinglePlayerController extends GameController {
  bool isTapEnabled = true;

  @override
  void resetGame({
    BuildContext? context,
    VoidCallback? showDialogEndGame,
    bool isInsaneMode = false,
  }) {
    super.resetGame();
    isTapEnabled = true;
    // Define quem vai começar esse round
    currentPlayer = nextStartingPlayer;
    // Alterna para o próximo round
    nextStartingPlayer = (nextStartingPlayer == 'X') ? 'O' : 'X';
    // Se for a IA começando, já dispara o movimento dela
    if (currentPlayer == 'O' && context != null && showDialogEndGame != null) {
      Future.delayed(const Duration(milliseconds: 500), () {
        _makeAIMove(context, showDialogEndGame, isInsaneMode);
      });
    }
  }

  @override
  void disposeGame() {
    super.disposeGame();
    isTapEnabled = true;
  }

  @override
  Future<void> handleTap(
    int index,
    BuildContext context,
    VoidCallback showDialogEndGame,
    bool isInsaneMode,
  ) async {
    if (board[index] == '' && winner == '' && isTapEnabled) {
      // Verifica se o quadrado está vazio, se não há vencedor e se os toques estão habilitados
      isTapEnabled = false; // Desabilita toques adicionais

      await player.stop(); // Para qualquer som em execução
      await player.play(AssetSource(AppSounds.click1)); // Toca som de clique

      board[index] = currentPlayer; // Marca a jogada no tabuleiro

      // Adiciona a jogada ao histórico do jogador atual
      List<int> currentHistory =
          currentPlayer == 'X' ? moveHistoryX : moveHistoryO;

      currentHistory.add(index);

      // Se estiver no modo insano e o histórico tiver mais de 3 jogadas, remove a jogada mais antiga
      if (isInsaneMode && currentHistory.length > 3) {
        int removeIndex = currentHistory.removeAt(0);
        board[removeIndex] = '';
        notifyListeners();
        Future.delayed(const Duration(milliseconds: 500), () {
          notifyListeners();
        });
      }

      // Verifica se o jogador atual venceu
      if (checkWinner(currentPlayer)) {
        winningLine = getWinningLine(currentPlayer); // Obtém a linha vencedora
        await player.play(AssetSource(AppSounds.win)); // Toca som de vitória
        winner = currentPlayer; // Define o vencedor

        // Atualiza a quantidade de vitórias do jogador vencedor
        if (winner == 'X') {
          qtdWinsPlayer1++;
        } else {
          qtdWinsPlayer2++;
        }

        // Apaga todas as peças e mantém apenas as da linha vencedora
        for (int i = 0; i < board.length; i++) {
          if (!winningLine!.contains(i)) {
            board[i] = '';
          }
        }

        notifyListeners(); // Notifica ouvintes para atualizar a interface

        // Após 2 segundos, mostra o diálogo de fim de jogo e reseta o jogo
        Future.delayed(const Duration(seconds: 1), () {
          showDialogEndGame();
          resetGame(
            context: context,
            showDialogEndGame: showDialogEndGame,
            isInsaneMode: isInsaneMode,
          );
        });

        return;
      } else if (!board.contains('')) {
        // Verifica se deu empate
        await player.play(AssetSource(AppSounds.win)); // Toca som de empate
        Future.delayed(const Duration(milliseconds: 300), () {
          isTapEnabled = true; // Reabilita os toques após 300ms
        });
        winner = 'DRAW'; // Define o resultado como empate
        notifyListeners(); // Notifica ouvintes para atualizar a interface

        // Após 500ms, mostra o diálogo de fim de jogo e reseta o jogo
        Future.delayed(const Duration(milliseconds: 500), () {
          showDialogEndGame();

          resetGame(
            context: context,
            showDialogEndGame: showDialogEndGame,
            isInsaneMode: isInsaneMode,
          );
        });

        return;
      } else {
        currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
      }

      // Reabilita os toques após 300ms
      Future.delayed(const Duration(milliseconds: 300), () {
        isTapEnabled = true;
      });
      notifyListeners(); // Notifica ouvintes para atualizar a interface

      // Se for a vez da IA, faz uma jogada após 500ms
      if (currentPlayer == 'O') {
        Future.delayed(const Duration(milliseconds: 500), () {
          _makeAIMove(context, showDialogEndGame, isInsaneMode);
        });
      }
    }
  }

  // Retorna a linha vencedora, se houver
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

  // Função de IA usando o algoritmo Minimax
  int minimax(List<String> board, int depth, bool isMaximizing) {
    String result = checkWinner('X')
        ? 'X'
        : checkWinner('O')
            ? 'O'
            : '';
    if (result == 'X') return -1;
    if (result == 'O') return 1;
    if (!board.contains('')) return 0;

    if (isMaximizing) {
      int bestScore = -999;
      for (int i = 0; i < board.length; i++) {
        if (board[i] == '') {
          board[i] = 'O';
          int score = minimax(board, depth + 1, false);
          board[i] = '';
          bestScore = max(score, bestScore);
        }
      }
      return bestScore;
    } else {
      int bestScore = 999;
      for (int i = 0; i < board.length; i++) {
        if (board[i] == '') {
          board[i] = 'X';
          int score = minimax(board, depth + 1, true);
          board[i] = '';
          bestScore = min(score, bestScore);
        }
      }
      return bestScore;
    }
  }

  // Faz a jogada da IA
  Future<void> _makeAIMove(
    BuildContext context,
    VoidCallback showDialogEndGame,
    bool isInsaneMode,
  ) async {
    int bestScore = -999;
    late int bestMove;
    for (int i = 0; i < board.length; i++) {
      if (board[i] == '') {
        board[i] = 'O';
        int score = minimax(board, 0, false);
        board[i] = '';
        if (score > bestScore) {
          bestScore = score;
          bestMove = i;
        }
      }
    }

    await handleTap(bestMove, context, showDialogEndGame, isInsaneMode);
  }
}
