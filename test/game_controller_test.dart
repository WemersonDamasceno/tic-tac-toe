import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe/domain/controllers/base_game_controller.dart';
import 'package:tictactoe/domain/controllers/multiplayer_game_controller.dart';
import 'package:tictactoe/domain/controllers/singleplayer_game_controller.dart';

class StubSinglePlayerController extends SinglePlayerController {
  @override
  Future<void> playSound(String source) async {}
}

class StubMultiPlayerController extends MultiPlayerController {
  @override
  Future<void> playSound(String source) async {}
}

void main() {
  group('GameController.checkWinner', () {
    test('retorna a linha vencedora', () {
      final controller = StubMultiPlayerController()
        ..board = ['X', 'X', 'X', '', '', '', '', '', ''];

      final line = controller.checkWinner('X');

      expect(line, [0, 1, 2]);
    });

    test('retorna null quando não há vencedor', () {
      final controller = StubMultiPlayerController()
        ..board = ['X', 'O', '', 'X', 'O', '', '', '', ''];
      final noWinnerBoard = List.generate(9, (_) => '')
        ..[0] = 'X'
        ..[4] = 'O';

      expect(controller.checkWinner('X'), isNull);
      expect(controller.checkWinner('O'), isNull);
      expect(noWinnerBoard.contains(''), isTrue);
    });
  });

  group('GameController.checkDraw', () {
    test('modo normal: empate quando o tabuleiro está cheio', () {
      final controller = StubMultiPlayerController()
        ..board = ['X', 'O', 'X', 'O', 'X', 'O', 'O', 'X', 'O'];

      expect(controller.checkWinner('X'), isNull);
      expect(controller.checkWinner('O'), isNull);
      expect(controller.checkDraw(isInsaneMode: false), isTrue);
    });

    test('modo insane: empate após o limite de jogadas sem vencedor', () {
      final controller = StubMultiPlayerController();
      controller.movesMade = GameController.maxInsaneMovesWithoutWinner;

      expect(controller.checkDraw(isInsaneMode: true), isTrue);
    });

    test('não empata enquanto o limite não é atingido', () {
      final controller = StubMultiPlayerController();
      controller.movesMade = GameController.maxInsaneMovesWithoutWinner - 1;

      expect(controller.checkDraw(isInsaneMode: true), isFalse);
    });
  });

  group('MultiPlayerController (insane mode)', () {
    test('substitui a peça mais antiga ao completar 3 peças', () async {
      final controller = StubMultiPlayerController();

      await controller.handleTap(0, null, () {}, true);
      await controller.handleTap(4, null, () {}, true);
      await controller.handleTap(1, null, () {}, true);
      await controller.handleTap(5, null, () {}, true);
      await controller.handleTap(3, null, () {}, true);
      await controller.handleTap(6, null, () {}, true);
      await controller.handleTap(7, null, () {}, true);

      expect(controller.winner, isEmpty);
      expect(controller.moveHistoryX, [1, 3, 7]);
      expect(controller.moveHistoryO, [4, 5, 6]);
      expect(controller.board[0], '');
      expect(controller.board[3], 'X');
      expect(controller.board[7], 'X');
    });

    test('detecta vitória e soma o placar', () async {
      final controller = StubMultiPlayerController();

      await controller.handleTap(0, null, () {}, true);
      await controller.handleTap(4, null, () {}, true);
      await controller.handleTap(1, null, () {}, true);
      await controller.handleTap(5, null, () {}, true);
      await controller.handleTap(2, null, () {}, true);

      expect(controller.winner, 'X');
      expect(controller.winningLine, [0, 1, 2]);
      expect(controller.qtdWinsPlayer1, 1);
      expect(controller.qtdWinsPlayer2, 0);
    });

    test('bloqueia duplo toque durante uma jogada', () async {
      final controller = StubMultiPlayerController();

      controller.isTapEnabled = false;
      await controller.handleTap(0, null, () {}, false);

      expect(controller.board[0], '');
    });
  });

  group('SinglePlayerController (AI)', () {
    test('IA responde após a jogada do humano', () async {
      final controller = StubSinglePlayerController();
      controller.resetGame(
        context: null,
        showDialogEndGame: () {},
        isInsaneMode: false,
      );

      await controller.handleTap(0, null, () {}, false);

      // A IA joga 500ms depois da jogada humana.
      await Future<void>.delayed(const Duration(milliseconds: 1000));

      expect(controller.board.where((cell) => cell == 'X').length, 1);
      expect(controller.board.where((cell) => cell == 'O').length, 1);
      expect(controller.currentPlayer, 'X');
      expect(controller.isTapEnabled, isTrue);
    });

    test('alterna quem começa cada round', () {
      final controller = StubSinglePlayerController();
      expect(controller.nextStartingPlayer, 'X');

      controller.resetGame();
      expect(controller.currentPlayer, 'X');
      expect(controller.nextStartingPlayer, 'O');

      controller.resetGame();
      expect(controller.currentPlayer, 'O');
      expect(controller.nextStartingPlayer, 'X');
    });
  });
}
