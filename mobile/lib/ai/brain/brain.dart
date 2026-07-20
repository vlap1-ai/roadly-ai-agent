import '../../models/intent.dart';

class Brain {
  bool _isReady = false;

  Brain();

  bool get isReady => _isReady;

  Future<void> initialize() async {
    if (_isReady) return;

    _isReady = true;

    print("🧠 Brain initialized");
  }

  Future<void> dispose() async {
    if (!_isReady) return;

    _isReady = false;

    print("🧠 Brain disposed");
  }

  Future<Intent> process(String input) async {
    if (!_isReady) {
      throw StateError("Brain is not initialized.");
    }

    final normalizedInput = _normalizeInput(input);

    final intent = _detectIntent(normalizedInput);

    return intent;
  }

  String _normalizeInput(String input) {
    return input.trim();
  }

  Intent _detectIntent(String input) {
    final text = input.toLowerCase();

    if (text.contains("navigate") || text.contains("direction")) {
      return Intent.navigation;
    }

    if (text.contains("music")) {
      return Intent.music;
    }

    if (text.contains("call")) {
      return Intent.phoneCall;
    }

    return Intent.unknown;
  }
}