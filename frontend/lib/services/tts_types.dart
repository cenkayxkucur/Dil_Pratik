/// TTS hız seçenekleri — platform bağımsız tanım.
enum TtsRate { slow, normal, fast }

extension TtsRateValue on TtsRate {
  double get value {
    switch (this) {
      case TtsRate.slow:
        return 0.65;
      case TtsRate.normal:
        return 0.9;
      case TtsRate.fast:
        return 1.2;
    }
  }
}
