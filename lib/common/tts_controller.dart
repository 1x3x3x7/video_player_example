import 'package:flutter_tts/flutter_tts.dart';

class TtsController {
  final FlutterTts tts = FlutterTts();
  TtsController();

  void speak(text) {
    print("speak $text");
    tts.speak(text);
  }
}
