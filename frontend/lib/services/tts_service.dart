// Platform-specific TTS service using conditional imports
import 'tts_service_stub.dart' if (dart.library.js) 'tts_service_web.dart';

// Cross-platform Text-to-Speech service wrapper
class TtsService {
  final TtsServicePlatform _platform = TtsServicePlatform();

  bool get isSupported => _platform.isSupported;
  bool get isSpeaking => _platform.isSpeaking;

  void speak({
    required String text,
    required String language,
    Function()? onStart,
    Function()? onEnd,
    Function(String)? onError,
  }) {
    _platform.speak(
      text: text,
      language: language,
      onStart: onStart,
      onEnd: onEnd,
      onError: onError,
    );
  }

  void stop() {
    _platform.stop();
  }
}
