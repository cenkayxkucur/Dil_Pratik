// Web-specific Text-to-Speech service
// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:js' as js;

class TtsServicePlatform {
  bool get isSupported {
    try {
      return js.context.hasProperty('speechSynthesis');
    } catch (e) {
      return false;
    }
  }

  void speak({
    required String text,
    required String language,
    Function()? onStart,
    Function()? onEnd,
    Function(String)? onError,
  }) {
    if (!isSupported) {
      onError?.call('Text-to-Speech not supported');
      return;
    }

    try {
      final utterance = js.context.callMethod('eval', ['new SpeechSynthesisUtterance()']);
      utterance['text'] = text;
      utterance['lang'] = _getLanguageCode(language);
      utterance['rate'] = 0.9; // Slightly slower for language learning
      utterance['pitch'] = 1.0;
      utterance['volume'] = 1.0;

      // Set event handlers
      utterance['onstart'] = js.allowInterop((_) {
        onStart?.call();
      });

      utterance['onend'] = js.allowInterop((_) {
        onEnd?.call();
      });      utterance['onerror'] = js.allowInterop((event) {
        try {
          // SpeechSynthesisEvent doesn't have an 'error' property like SpeechRecognition
          // We can check event.type or just provide a generic error message
          final errorType = event != null && event['type'] != null ? event['type'].toString() : 'error';
          onError?.call('Text-to-Speech error: $errorType');
        } catch (e) {
          onError?.call('Text-to-Speech error: Unknown error');
        }
      });

      // Speak the text
      js.context['speechSynthesis'].callMethod('speak', [utterance]);
    } catch (e) {
      onError?.call('Failed to initialize text-to-speech: $e');
    }
  }

  void stop() {
    if (isSupported) {
      try {
        js.context['speechSynthesis'].callMethod('cancel');
      } catch (e) {
        // Ignore errors when stopping
      }
    }
  }

  bool get isSpeaking {
    if (!isSupported) return false;
    try {
      return js.context['speechSynthesis']['speaking'] ?? false;
    } catch (e) {
      return false;
    }
  }
  String _getLanguageCode(String language) {
    switch (language.toLowerCase()) {
      // Turkish variants
      case 'turkish':
      case 'türkçe':
      case 'tr':
      case 'tr-tr':
        return 'tr-TR';
      // English variants  
      case 'english':
      case 'ingilizce':
      case 'en':
      case 'en-us':
        return 'en-US';
      // German variants
      case 'german':
      case 'almanca':
      case 'deutsch':
      case 'de':
      case 'de-de':
        return 'de-DE';
      default:
        return 'en-US';
    }
  }
}
