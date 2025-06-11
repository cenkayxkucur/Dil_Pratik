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
        // Set properties with safety checks
        _recognition['continuous'] = false;
        _recognition['interimResults'] = false;
        _recognition['lang'] = _getLanguageCode(language);
        _recognition['maxAlternatives'] = 1;

        // Set event handlers
        _recognition['onresult'] = js.allowInterop((event) {
          print('🎤 Speech recognition onresult triggered!'); // Debug log
          try {
            // More robust event handling
            if (event == null) {
              print('Speech recognition event is null'); // Debug log
              _onError?.call('Speech recognition event is null');
              return;
            }
            
            final results = event['results'];
            print('Results: $results'); // Debug log
            
            if (results == null) {
              print('Speech recognition results are null'); // Debug log
              _onError?.call('Speech recognition results are null');
              return;
            }
            
            final length = results['length'];
            print('Results length: $length'); // Debug log
            
            if (length == null || length == 0) {
              print('No results yet or length is 0'); // Debug log
              return; // No results yet
            }
            
            final lastResult = results[length - 1];
            print('Last result: $lastResult'); // Debug log
            
            if (lastResult == null) {
              print('Last result is null'); // Debug log
              return;
            }
            
            final isFinal = lastResult['isFinal'];
            print('Is final: $isFinal'); // Debug log
            
            if (isFinal == true) {
              final resultLength = lastResult['length'];
              print('Result length: $resultLength'); // Debug log
              
              if (resultLength != null && resultLength > 0) {
                final firstAlternative = lastResult[0];
                print('First alternative: $firstAlternative'); // Debug log
                
                if (firstAlternative != null) {
                  final transcript = firstAlternative['transcript'];
                  print('Transcript: $transcript'); // Debug log
                  
                  if (transcript != null) {
                    final transcriptText = transcript.toString().trim();
                    print('Final transcript text: $transcriptText'); // Debug log
                    
                    if (transcriptText.isNotEmpty) {
                      print('🎯 Calling onResult with: "$transcriptText"'); // Debug log
                      _onResult?.call(transcriptText);
                    } else {
                      print('Transcript text is empty after trim'); // Debug log
                    }
                  } else {
                    print('Transcript is null'); // Debug log
                  }
                } else {
                  print('First alternative is null'); // Debug log
                }
              } else {
                print('Result length is null or 0'); // Debug log
              }
            } else {
              print('Result is not final yet'); // Debug log
            }
          } catch (e) {
            print('Error in speech recognition: $e'); // Debug log
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
    _recognition = null;
    _onResult = null;
    _onError = null;
  }
}
