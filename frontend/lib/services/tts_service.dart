// Platform-specific TTS service using conditional imports
import 'tts_service_stub.dart' if (dart.library.js) 'tts_service_web.dart';
import 'tts_types.dart';

export 'tts_types.dart' show TtsRate;

// Cross-platform Text-to-Speech service wrapper
class TtsService {
  final TtsServicePlatform _platform = TtsServicePlatform();

  bool get isSupported => _platform.isSupported;
  bool get isSpeaking => _platform.isSpeaking;

  /// Mevcut konuşma hızı.
  TtsRate get currentRate => _platform.rate;

  /// Konuşma hızını değiştir (slow / normal / fast).
  void setRate(TtsRate rate) {
    _platform.rate = rate;
  }

  /// Metni seslendir. Önceki konuşma otomatik durdurulur.
  void speak({
    required String text,
    required String language,
    TtsRate? rate,
    Function()? onStart,
    Function()? onEnd,
    Function(String)? onError,
  }) {
    _platform.speak(
      text: text,
      language: language,
      speechRate: rate,
      onStart: onStart,
      onEnd: onEnd,
      onError: onError,
    );
  }

  void stop() {
    _platform.stop();
  }
}
