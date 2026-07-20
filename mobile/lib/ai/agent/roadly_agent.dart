import '../brain/brain.dart';
import '../context/context.dart';
import '../memory/memory.dart';
import '../planner/planner.dart'; 
import '../tools/tool_manager.dart';
import '../voice/voice_manager.dart';

import '../../models/intent.dart';

class RoadlyAgent {
  final Brain brain;
  final Planner planner;
  final Context context;
  final Memory memory;
  final ToolManager toolManager;
  final VoiceManager voiceManager;


 bool _isInitialized = false;

  RoadlyAgent({
    required this.brain,
    required this.planner,
    required this.context,
    required this.memory,
    required this.toolManager,
    required this.voiceManager,
  });

  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    if (_isInitialized) return;

    await brain.initialize();

    _isInitialized = true;

    print("🚗 Roadly Agent initialized.");
  }

  Future<void> start() async {
    if (!_isInitialized) {
      await initialize();
    }

    print("🚀 Roadly Agent is running.");
  }

  Future<String> processRequest(String input) async {
    if (!_isInitialized) {
      throw StateError("Roadly Agent is not initialized.");
    }

    final Intent intent = await brain.process(input);

    final String action = planner.plan(intent);
    
    return action;
  }

  Future<void> dispose() async {
    if (!_isInitialized) return;

    await brain.dispose();

    _isInitialized = false;

    print("👋 Roadly Agent disposed.");
  }
}