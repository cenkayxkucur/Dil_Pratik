// Default implementation for non-web platforms
class SpeechServicePlatform {
  bool get isListening => false;
  bool get isSupported => false;

  void startListening({
    required String language,
    Function(String)? onResult,
    Function(String)? onError,
  }) {
    onError?.call('Speech recognition not supported on this platform');
  }

  void stopListening() {
    // No-op for non-web platforms
  }

  void dispose() {
    // No-op for non-web platforms
  }
}
