// Platform-specific speech service using conditional imports
import 'speech_service_stub.dart' if (dart.library.js) 'speech_service_web.dart';

// Cross-platform speech service wrapper
class SpeechService {
  final SpeechServicePlatform _platform = SpeechServicePlatform();

  bool get isListening => _platform.isListening;
  bool get isSupported => _platform.isSupported;
  void startListening({
    required String language,
    Function(String)? onResult,
    Function(String)? onError,
  }) {
    _platform.startListening(
      language: language,
      onResult: onResult,
      onError: onError,
    );
  }

  void stopListening() {
    _platform.stopListening();
  }

  void dispose() {
    _platform.dispose();
  }
}
