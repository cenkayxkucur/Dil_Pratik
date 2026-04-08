// Cross-platform speech service wrapper
// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:js' as js;
import 'dart:async';

class SpeechService {
  dynamic _recognition;
  bool _isListening = false;
  Function(String)? _onResult;
  Function(String)? _onError;
  Timer? _timeoutTimer;
    // Timeout ayarları - bu değerleri değiştirerek sessizlik süresini kontrol edebilirsiniz
  static const int silenceTimeoutSeconds = 5; // 5 saniye sessizlik sonrası durdur
  static const int maxListeningTimeSeconds = 30; // Maksimum dinleme süresi
  
  // KULLANIM: Farklı timeout değerleri ile kullanım
  // speechService.startListening(
  //   language: 'turkish',
  //   silenceTimeoutSeconds: 5, // 5 saniye bekle
  //   maxListeningTimeSeconds: 15, // Maksimum 15 saniye dinle
  //   onResult: (text) => print(text),
  //   onError: (error) => print(error),
  // );
  
  bool get isListening => _isListening;

  bool get isSupported {
    try {
      return js.context.hasProperty('SpeechRecognition') ||
             js.context.hasProperty('webkitSpeechRecognition');
    } catch (e) {
      return false;
    }
  }
  void startListening({
    required String language,
    Function(String)? onResult,
    Function(String)? onError,
    int? silenceTimeoutSeconds, // Özel timeout süresi (opsiyonel)
    int? maxListeningTimeSeconds, // Özel maksimum dinleme süresi (opsiyonel)
  }) {
    if (!isSupported) {
      onError?.call('Speech recognition not supported');
      return;
    }

    if (_isListening) {
      stopListening();
    }

    _onResult = onResult;
    _onError = onError;
    
    // Timeout timer'ını başlat
    final effectiveSilenceTimeout = silenceTimeoutSeconds ?? SpeechService.silenceTimeoutSeconds;
    final effectiveMaxTimeout = maxListeningTimeSeconds ?? SpeechService.maxListeningTimeSeconds;
    
    _timeoutTimer = Timer(Duration(seconds: effectiveMaxTimeout), () {
      if (_isListening) {
        stopListening();
        onError?.call('Speech recognition timeout - maksimum dinleme süresi aşıldı');
      }
    });

    try {
      // Create SpeechRecognition instance
      dynamic speechRecognition;
      if (js.context.hasProperty('SpeechRecognition')) {
        speechRecognition = js.context['SpeechRecognition'];
      } else if (js.context.hasProperty('webkitSpeechRecognition')) {
        speechRecognition = js.context['webkitSpeechRecognition'];
      } else {
        onError?.call('SpeechRecognition not available in this browser');
        return;
      }

      _recognition = js.JsObject(speechRecognition, []);

      if (_recognition != null) {
        // Set properties
        _recognition['continuous'] = false;
        _recognition['interimResults'] = false;
        _recognition['lang'] = _getLanguageCode(language);
        _recognition['maxAlternatives'] = 1;        // Set event handlers
        _recognition['onresult'] = js.allowInterop((event) {
          try {
            if (event == null) return;

            final jsEvent = js.JsObject.fromBrowserObject(event);
            final results = jsEvent['results'];
            if (results == null) return;

            final jsResults = js.JsObject.fromBrowserObject(results);
            final length = jsResults['length'];
            if (length == null || length == 0) return;

            final lastResult = jsResults[length - 1];
            if (lastResult == null) return;

            final jsLastResult = js.JsObject.fromBrowserObject(lastResult);
            final isFinal = jsLastResult['isFinal'];
            if (isFinal == true) {
              final resultLength = jsLastResult['length'];
              if (resultLength != null && resultLength > 0) {
                final firstAlternative = jsLastResult[0];
                if (firstAlternative != null) {
                  final jsAlternative = js.JsObject.fromBrowserObject(firstAlternative);
                  final transcript = jsAlternative['transcript'];
                  if (transcript != null) {
                    final transcriptText = transcript.toString().trim();
                    if (transcriptText.isNotEmpty) {
                      _onResult?.call(transcriptText);
                    }
                  }
                }
              }
            }
          } catch (e) {
            _onError?.call('Error processing speech result: $e');
          }
        });        _recognition['onerror'] = js.allowInterop((event) {
          try {
            String error = 'Unknown speech recognition error';
            if (event != null) {
              final jsEvent = js.JsObject.fromBrowserObject(event);
              final errorProperty = jsEvent['error'];
              if (errorProperty != null) {
                error = errorProperty.toString();
              }
            }
            _onError?.call('Speech recognition error: $error');
          } catch (e) {
            _onError?.call('Speech recognition error handler failed: $e');
          }
          _isListening = false;
        });

        _recognition['onend'] = js.allowInterop((_) {
          _isListening = false;
        });

        // Start recognition
        _recognition.callMethod('start');
        _isListening = true;
      }
    } catch (e) {
      onError?.call('Failed to initialize speech recognition: $e');
    }
  }
  void stopListening() {
    // Timer'ı temizle
    _timeoutTimer?.cancel();
    _timeoutTimer = null;
    
    if (_recognition != null && _isListening) {
      try {
        _recognition.callMethod('stop');
      } catch (e) {
        // Ignore errors when stopping
      }
      _isListening = false;
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
  void dispose() {
    stopListening();
    _timeoutTimer?.cancel();
    _timeoutTimer = null;
    _recognition = null;
    _onResult = null;
    _onError = null;
  }
}
