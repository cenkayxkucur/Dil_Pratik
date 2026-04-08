// Web-specific implementation of speech service
// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:js' as js;

class SpeechServicePlatform {
  dynamic _recognition;
  bool _isListening = false;
  Function(String)? _onResult;
  Function(String)? _onError;

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

    try {
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
        _recognition['continuous'] = false;
        _recognition['interimResults'] = false;
        _recognition['lang'] = _getLanguageCode(language);
        _recognition['maxAlternatives'] = 1;

        _recognition['onresult'] = js.allowInterop((event) {
          try {
            if (event == null) {
              _onError?.call('Speech recognition event is null');
              return;
            }

            final results = event['results'];
            if (results == null) {
              _onError?.call('Speech recognition results are null');
              return;
            }

            final length = results['length'];
            if (length == null || length == 0) return;

            final lastResult = results[length - 1];
            if (lastResult == null) return;

            final isFinal = lastResult['isFinal'];
            if (isFinal == true) {
              final resultLength = lastResult['length'];
              if (resultLength != null && resultLength > 0) {
                final firstAlternative = lastResult[0];
                if (firstAlternative != null) {
                  final transcript = firstAlternative['transcript'];
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
        });

        _recognition['onerror'] = js.allowInterop((event) {
          try {
            final error = event != null && event['error'] != null
                ? event['error'].toString()
                : 'Unknown speech recognition error';
            _onError?.call('Speech recognition error: $error');
          } catch (e) {
            _onError?.call('Speech recognition error handler failed: $e');
          }
          _isListening = false;
        });

        _recognition['onend'] = js.allowInterop((_) {
          _isListening = false;
        });

        _recognition.callMethod('start');
        _isListening = true;
      }
    } catch (e) {
      onError?.call('Failed to initialize speech recognition: $e');
    }
  }

  void stopListening() {
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
      case 'turkish':
      case 'türkçe':
      case 'tr':
      case 'tr-tr':
        return 'tr-TR';
      case 'english':
      case 'ingilizce':
      case 'en':
      case 'en-us':
        return 'en-US';
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
    _recognition = null;
    _onResult = null;
    _onError = null;
  }
}
