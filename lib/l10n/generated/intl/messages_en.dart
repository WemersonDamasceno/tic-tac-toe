// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(s) => "Player ${s}";

  static String m1(s) => "Player ${s} Wins!\nCongratulations!";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "labelAttention": MessageLookupByLibrary.simpleMessage("Attention!"),
        "labelAttentionDescription": MessageLookupByLibrary.simpleMessage(
            "When a piece becomes blurred, it means it will be moved to a new position."),
        "labelChallenge": MessageLookupByLibrary.simpleMessage("MY CHALLENGES"),
        "labelClose": MessageLookupByLibrary.simpleMessage("Close"),
        "labelCommingSoon":
            MessageLookupByLibrary.simpleMessage("COMMING SOON"),
        "labelComputer": MessageLookupByLibrary.simpleMessage("Computer"),
        "labelDrawDescription": MessageLookupByLibrary.simpleMessage(
            "HOW AMAZING!\nTHE GAME ENDED IN A DRAW!"),
        "labelDrawTitle": MessageLookupByLibrary.simpleMessage("TIED"),
        "labelGameMode": MessageLookupByLibrary.simpleMessage("GAME MODE"),
        "labelInsaneMode": MessageLookupByLibrary.simpleMessage("INSANE GAME"),
        "labelLetsGo": MessageLookupByLibrary.simpleMessage("Lets go"),
        "labelMultiPlayer": MessageLookupByLibrary.simpleMessage("MULTIPLAYER"),
        "labelMultiPlayerShowCase":
            MessageLookupByLibrary.simpleMessage("Multiplayer mode"),
        "labelMultiPlayerShowCaseDescription":
            MessageLookupByLibrary.simpleMessage(
                "Challenge a friend in matches on the same device."),
        "labelNormalMode": MessageLookupByLibrary.simpleMessage("NORMAL GAME"),
        "labelOptionIndefine": MessageLookupByLibrary.simpleMessage(
            "Option currently unavailable!"),
        "labelPlayOnline": MessageLookupByLibrary.simpleMessage("PLAY ONLINE"),
        "labelPlayer": m0,
        "labelPlayerNWinner": m1,
        "labelProjectName":
            MessageLookupByLibrary.simpleMessage("Tic Tac Toe Infinity"),
        "labelScoreboard": MessageLookupByLibrary.simpleMessage("SCOREBOARD"),
        "labelScoreboardShowCase":
            MessageLookupByLibrary.simpleMessage("Game Scoreboard"),
        "labelScoreboardShowCaseDescription":
            MessageLookupByLibrary.simpleMessage(
                "Follow each player\'s score here."),
        "labelSinglePlayer":
            MessageLookupByLibrary.simpleMessage("SINGLE PLAYER"),
        "labelTryAgain": MessageLookupByLibrary.simpleMessage("TRY AGAIN"),
        "labelYouLose":
            MessageLookupByLibrary.simpleMessage("What a shame, you lost!")
      };
}
