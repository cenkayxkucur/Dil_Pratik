// Default implementation for non-web platforms
class TtsServicePlatform {
  bool get isSupported => false;
  bool get isSpeaking => false;

  void speak({
    required String text,
    required String language,
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
