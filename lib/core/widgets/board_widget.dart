import 'package:flutter/material.dart';
import 'package:tictactoe/core/constants/app_colors.dart';
import 'package:tictactoe/core/constants/app_images.dart';
import 'package:tictactoe/core/mixins/dialog_mixin.dart';
import 'package:tictactoe/core/widgets/actual_simboly_widget.dart';
import 'package:tictactoe/core/widgets/background_gradient_widget.dart';
import 'package:tictactoe/domain/controllers/base_game_controller.dart';

class BoardWidget extends StatefulWidget {
  final GameModeEnum gameModeEnum;
  final GameController gameController;
  final bool isInsaneMode;

  const BoardWidget({
    required this.gameModeEnum,
    required this.gameController,
    required this.isInsaneMode,
    super.key,
  });

  @override
  State<BoardWidget> createState() => _BoardWidgetState();
}

class _BoardWidgetState extends State<BoardWidget> with DialogMixin {
  @override
  Widget build(BuildContext context) {
    return BackgroundGradientWidget(
      child: LayoutBuilder(
        builder: (_, constraints) {
          return Container(
            margin: const EdgeInsets.all(10),
            constraints: constraints,
            child: GridView.builder(
              shrinkWrap: true,
              itemCount: 9,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.85,
              ),
              itemBuilder: (context, index) {
                final String symbol = widget.gameController.board[index];
                final isOpaqueVerify = checkIfOpaque(
                  symbol: symbol,
                  index: index,
                  board: widget.gameController,
                );
                final bool isOpaque = widget.isInsaneMode &&
                    isOpaqueVerify &&
                    widget.gameController.winner.isEmpty;

                return GestureDetector(
                  onTap: () async => await widget.gameController.handleTap(
                    index,
                    context,
                    () {
                      showDialogEndGame(
                        context: context,
                        gameController: widget.gameController,
                        gameModeEnum: widget.gameModeEnum,
                      );
                    },
                    widget.isInsaneMode,
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(7),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withOpacity(0.5),
                          offset: const Offset(0, 2),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    child: ActualSimbolyWidget(
                      symbol: symbol,
                      isOpaque: isOpaque,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  bool checkIfOpaque({
    required GameController board,
    required String symbol,
    required int index,
  }) {
    if ((symbol == 'X' && board.currentPlayer == 'X') ||
        (symbol == 'O' && board.currentPlayer == 'O')) {
      List<int> moveHistory =
          symbol == 'X' ? board.moveHistoryX : board.moveHistoryO;

      // só opaca se tiver no mínimo 3 peças no board
      if (moveHistory.length >= 3 && moveHistory.first == index) {
        return true;
      }
    }
    return false;
  }
}

enum GameModeEnum {
  singlePlayer,
  multiPlayer,
}

enum PlayerEnum {
  player1(color: AppColors.primary, symbol: AppImages.x),
  player2(color: AppColors.secondary, symbol: AppImages.o);

  final Color color;
  final String symbol;

  const PlayerEnum({
    required this.color,
    required this.symbol,
  });
}
