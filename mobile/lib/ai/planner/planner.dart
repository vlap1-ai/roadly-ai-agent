import '../../models/intent.dart';

class Planner {
  Planner();

  String plan(Intent intent) {
    switch (intent) {
      case Intent.navigation:
        return "Start navigation";

      case Intent.music:
        return "Play music";

      case Intent.phoneCall:
        return "Make phone call";

      case Intent.unknown:
        return "Ask user for clarification";
    }
  }
}