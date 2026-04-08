// Default implementation for non-web platforms
import 'tts_types.dart';

export 'tts_types.dart' show TtsRate;

class TtsServicePlatform {
  TtsRate rate = TtsRate.normal;

  bool get isSupported => false;
  bool get isSpeaking => false;

  void speak({
    required String text,
    required String language,
    TtsRate? speechRate,
    Function()? onStart,
    Function()? onEnd,
    Function(String)? onError,
  }) {
    onError?.call('Text-to-Speech not supported on this platform');
  }

  void stop() {
    // No-op for non-web platforms
  }
}
