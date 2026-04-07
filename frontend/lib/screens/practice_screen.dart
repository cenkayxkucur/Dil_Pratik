import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../widgets/language_selector.dart';
import '../widgets/level_selector.dart';
import '../screens/home_screen.dart';
import '../services/api_service.dart';
import '../services/speech_service.dart';
import '../services/tts_service.dart';
import '../services/user_session_service.dart';
import '../providers/auth_provider.dart';
import '../providers/language_provider.dart';

enum ChatMode { text, voice }

final voiceInputEnabledProvider = StateProvider<bool>((ref) => false);
final voiceOutputEnabledProvider = StateProvider<bool>((ref) => false);
final chatMessagesProvider = StateProvider<List<ChatMessage>>((ref) => []);

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

class PracticeScreen extends ConsumerStatefulWidget {
  const PracticeScreen({super.key});

  @override
  ConsumerState<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends ConsumerState<PracticeScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final SpeechService _speechService = SpeechService();
  final TtsService _ttsService = TtsService();
  bool _isListening = false;
  bool _isSpeaking = false;
  @override
  void initState() {
    super.initState();
    // Initialize UserSessionService with Riverpod reference
    WidgetsBinding.instance.addPostFrameCallback((_) {
      UserSessionService.initialize(ref);
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _speechService.dispose();
    _ttsService.stop();
    super.dispose();
  }@override
  Widget build(BuildContext context) {
    final selectedLanguage = ref.watch(selectedLanguageProvider);
    final selectedLevel = ref.watch(selectedLevelProvider);
    final communicationLanguage = ref.watch(communicationLanguageProvider);
    final voiceInputEnabled = ref.watch(voiceInputEnabledProvider);
    final voiceOutputEnabled = ref.watch(voiceOutputEnabledProvider);
    final messages = ref.watch(chatMessagesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dil Pratik - Konuşma'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Language selector
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dil Seçimi:',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                LanguageSelector(
                  selectedLanguage: selectedLanguage,
                  onLanguageSelected: (language) {
                    ref.read(selectedLanguageProvider.notifier).state = language;
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  'Seviye Seçimi:',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),                LevelSelector(
                  selectedLevel: selectedLevel,
                  onLevelSelected: (level) {
                    ref.read(selectedLevelProvider.notifier).state = level;
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  'İletişim Dili:',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                LanguageSelector(
                  selectedLanguage: communicationLanguage,
                  onLanguageSelected: (language) {
                    ref.read(communicationLanguageProvider.notifier).state = language;
                  },
                ),
              ],
            ),
          ),
          
          // Voice controls
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Switch(
                      value: voiceInputEnabled,
                      onChanged: (value) {
                        ref.read(voiceInputEnabledProvider.notifier).state = value;
                        if (!value && _isListening) {
                          _stopVoiceRecording();
                        }
                      },
                    ),
                    const Text('Ses Girişi'),
                  ],
                ),
                Row(
                  children: [
                    Switch(
                      value: voiceOutputEnabled,
                      onChanged: (value) {
                        ref.read(voiceOutputEnabledProvider.notifier).state = value;
                        if (!value && _isSpeaking) {
                          _ttsService.stop();
                          setState(() {
                            _isSpeaking = false;
                          });
                        }
                      },
                    ),
                    const Text('Ses Çıkışı'),
                  ],
                ),
              ],
            ),
          ),
          
          const Divider(),
          
          // Chat messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16.0),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return _buildMessageBubble(message);
              },
            ),
          ),
          
          // Input area
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).colorScheme.outline,
                  width: 1.0,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Mesajınızı yazın...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                if (voiceInputEnabled)
                  IconButton(
                    icon: Icon(
                      _isListening ? Icons.mic : Icons.mic_none,
                      color: _isListening ? Colors.red : null,
                    ),
                    onPressed: _isListening ? _stopVoiceRecording : _startVoiceRecording,
                  ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            decoration: BoxDecoration(
              color: message.isUser
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Text(
              message.text,
              style: TextStyle(
                color: message.isUser
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    // Add user message
    final userMessage = ChatMessage(
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );
    
    ref.read(chatMessagesProvider.notifier).state = [
      ...ref.read(chatMessagesProvider),
      userMessage,
    ];

    _messageController.clear();
    _scrollToBottom();    try {
      // Get current selections
      final selectedLanguage = ref.read(selectedLanguageProvider);
      final selectedLevel = ref.read(selectedLevelProvider);
      final communicationLanguage = ref.read(communicationLanguageProvider);
      
      // Get AI response with all parameters
      final response = await ApiService.getChatResponse(
        text, 
        selectedLanguage,
        level: selectedLevel,
        communicationLanguage: communicationLanguage,
      );
      
      // Add AI response
      final aiMessage = ChatMessage(
        text: response,
        isUser: false,
        timestamp: DateTime.now(),
      );
      
      ref.read(chatMessagesProvider.notifier).state = [
        ...ref.read(chatMessagesProvider),
        aiMessage,
      ];

      _scrollToBottom();

      // Speak the response if voice output is enabled
      final voiceOutputEnabled = ref.read(voiceOutputEnabledProvider);
      if (voiceOutputEnabled) {
        await _speakText(response);
      }
    } catch (e) {
      _showErrorSnackBar('Mesaj gönderilirken hata oluştu: $e');
    }
  }
  void _startVoiceRecording() async {
    try {
      // Check if speech recognition is available
      if (!_speechService.isSupported) {
        _showErrorSnackBar(
          'Ses tanıma bu cihazda desteklenmiyor.',
          action: SnackBarAction(
            label: 'Tamam',
            onPressed: () {},
          ),
        );
        return;
      }

      setState(() {
        _isListening = true;
      });      final communicationLanguage = ref.read(communicationLanguageProvider);
      _speechService.startListening(
        language: communicationLanguage?.name ?? communicationLanguage?.code ?? 'tr',onResult: (result) {
          print('📝 PracticeScreen received speech result: "$result"'); // Debug log
          if (result.isNotEmpty) {
            _messageController.text = result;
            // Automatically send the message if it's not empty
            if (result.trim().isNotEmpty) {
              _sendMessage();
            }
          }
          setState(() {
            _isListening = false;
          });
        },        onError: (error) {
          print('❌ PracticeScreen received speech error: $error'); // Debug log
          _showErrorSnackBar(
            'Ses tanıma hatası: $error',
            action: SnackBarAction(
              label: 'Tekrar Dene',
              onPressed: _startVoiceRecording,
            ),
          );
          setState(() {
            _isListening = false;
          });
        },
      );
    } catch (e) {
      _showErrorSnackBar(
        'Ses tanıma hatası: ${e.toString()}',
        action: SnackBarAction(
          label: 'Tekrar Dene',
          onPressed: _startVoiceRecording,
        ),
      );
      setState(() {
        _isListening = false;
      });
    }
  }
  void _stopVoiceRecording() async {
    try {
      _speechService.stopListening();
    } catch (e) {
      _showErrorSnackBar('Ses kaydı durdurulurken hata oluştu: $e');
    } finally {
      setState(() {
        _isListening = false;
      });
    }
  }
  Future<void> _speakText(String text) async {
    try {
      // Check if TTS is available
      if (!_ttsService.isSupported) {
        _showErrorSnackBar(
          'Sesli okuma bu cihazda desteklenmiyor.',
          action: SnackBarAction(
            label: 'Tamam',
            onPressed: () {},
          ),
        );
        return;
      }

      setState(() {
        _isSpeaking = true;
      });      final selectedLanguage = ref.read(selectedLanguageProvider);
      _ttsService.speak(
        text: text,
        language: selectedLanguage?.name ?? selectedLanguage?.code ?? 'tr',
        onStart: () {
          setState(() {
            _isSpeaking = true;
          });
        },
        onEnd: () {
          setState(() {
            _isSpeaking = false;
          });
        },
        onError: (error) {
          _showErrorSnackBar(
            'Sesli okuma hatası: $error',
            action: SnackBarAction(
              label: 'Tekrar Dene',
              onPressed: () => _speakText(text),
            ),
          );
          setState(() {
            _isSpeaking = false;
          });
        },
      );
    } catch (e) {
      _showErrorSnackBar(
        'Sesli okuma hatası: ${e.toString()}',
        action: SnackBarAction(
          label: 'Tekrar Dene',
          onPressed: () => _speakText(text),
        ),
      );
      setState(() {
        _isSpeaking = false;
      });
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showErrorSnackBar(String message, {SnackBarAction? action}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        action: action,
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}