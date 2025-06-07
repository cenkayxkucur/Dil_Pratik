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
      // Create SpeechRecognition instance
      if (js.context.hasProperty('SpeechRecognition')) {
        _recognition = js.context.callMethod('eval', ['new SpeechRecognition()']);
      } else if (js.context.hasProperty('webkitSpeechRecognition')) {
        _recognition = js.context.callMethod('eval', ['new webkitSpeechRecognition()']);
      }

      if (_recognition != null) {
        // Set properties
        _recognition['continuous'] = false;
        _recognition['interimResults'] = false;
        _recognition['lang'] = _getLanguageCode(language);

        // Set event handlers
        _recognition['onresult'] = js.allowInterop((event) {
          try {
            final results = event['results'];
            if (results != null && results['length'] > 0) {
              final lastResult = results[results['length'] - 1];
              if (lastResult['isFinal'] == true && lastResult['length'] > 0) {
                final transcript = lastResult[0]['transcript'];
                if (transcript != null && transcript.toString().trim().isNotEmpty) {
                  _onResult?.call(transcript.toString().trim());
                }
              }
            }
          } catch (e) {
            _onError?.call('Error processing speech result: $e');
          }
        });

        _recognition['onerror'] = js.allowInterop((event) {
          final error = event['error'] ?? 'Unknown error';
          _onError?.call('Speech recognition error: $error');
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
        return 'tr-TR';
      case 'english':
      case 'ingilizce':
        return 'en-US';
      case 'german':
      case 'almanca':
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
