import 'package:tictactoe/domain/controllers/base_game_controller.dart';

class MultiPlayerController extends GameController {
  // O fluxo de jogo é herdado de GameController. O modo multiplayer não precisa
  // de agendamento de IA, então os toques são liberados imediatamente em
  // onTurnSwitched.
}
