import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../widgets/language_selector.dart';
import '../screens/home_screen.dart';
import '../services/api_service.dart';
import '../services/speech_service.dart';

enum ChatMode { text, voice }

final chatModeProvider = StateProvider<ChatMode>((ref) => ChatMode.text);
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

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _speechService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedLanguage = ref.watch(selectedLanguageProvider);
    final chatMode = ref.watch(chatModeProvider);
    final messages = ref.watch(chatMessagesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('${selectedLanguage?.flag} AI Sohbet'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(chatMode == ChatMode.text ? Icons.mic : Icons.keyboard),
            onPressed: () {
              final newMode = chatMode == ChatMode.text ? ChatMode.voice : ChatMode.text;
              ref.read(chatModeProvider.notifier).state = newMode;
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Language Selector
          Container(            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pratik yapmak istediğiniz dili seçin:',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                LanguageSelector(
                  selectedLanguage: selectedLanguage,
                  onLanguageSelected: (language) {
                    ref.read(selectedLanguageProvider.notifier).state = language;
                  },
                ),
                const SizedBox(height: 8),
                Text(
                  chatMode == ChatMode.text 
                    ? '💬 Mesaj modu aktif' 
                    : '🎤 Sesli mod aktif',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          // Chat Messages
          Expanded(
            child: messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'AI ile ${selectedLanguage?.name ?? "dil"} pratiği yapmaya başlayın!',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Sorularınızı sorun ve hatalarınızdan öğrenin.',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16.0),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      return _buildMessageBubble(message);
                    },
                  ),
          ),
          // Input Area
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade300)),
            ),
            child: chatMode == ChatMode.text 
                ? _buildTextInput()
                : _buildVoiceInput(),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: message.isUser ? Colors.blue : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(18.0),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: message.isUser ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildTextInput() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _messageController,
            decoration: InputDecoration(
              hintText: 'Mesajınızı yazın...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 10.0,
              ),
            ),
            onSubmitted: (_) => _sendMessage(),
          ),
        ),
        const SizedBox(width: 8),
        FloatingActionButton(
          mini: true,
          onPressed: _sendMessage,
          backgroundColor: Colors.green,
          child: const Icon(Icons.send, color: Colors.white),
        ),
      ],
    );
  }
  Widget _buildVoiceInput() {
    final isListening = _speechService.isListening;
    
    return Column(
      children: [
        Text(
          isListening 
            ? 'Dinleniyor... Konuşmayı bitirdikten sonra bekleyin'
            : 'Konuşmaya başlamak için mikrofona basın',
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        FloatingActionButton.large(
          onPressed: _speechService.isSupported 
            ? (isListening ? _stopVoiceRecording : _startVoiceRecording)
            : null,
          backgroundColor: isListening ? Colors.red : Colors.blue,
          child: Icon(
            isListening ? Icons.stop : Icons.mic, 
            color: Colors.white, 
            size: 32
          ),
        ),
        if (!_speechService.isSupported) ...[
          const SizedBox(height: 8),
          Text(
            'Sesli kayıt bu tarayıcıda desteklenmiyor',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.red,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
  void _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final selectedLanguage = ref.read(selectedLanguageProvider);
    if (selectedLanguage == null) return;

    final messages = ref.read(chatMessagesProvider);
    final newMessages = [
      ...messages,
      ChatMessage(text: text, isUser: true, timestamp: DateTime.now()),
    ];
    
    ref.read(chatMessagesProvider.notifier).state = newMessages;
    _messageController.clear();

    try {
      // Call real AI API
      final apiService = ApiService();
      final response = await apiService.chatWithAI(
        message: text,
        language: selectedLanguage.code,
        level: 'A1', // TODO: Get from user level
        userId: 'current-user', // TODO: Get from auth state
      );

      if (response['success'] == true) {
        final aiResponse = response['response'] as String;
        final updatedMessages = [
          ...ref.read(chatMessagesProvider),
          ChatMessage(text: aiResponse, isUser: false, timestamp: DateTime.now()),
        ];
        ref.read(chatMessagesProvider.notifier).state = updatedMessages;
      } else {
        // Fallback to mock response if API fails
        final aiResponse = _generateAIResponse(text);
        final updatedMessages = [
          ...ref.read(chatMessagesProvider),
          ChatMessage(text: aiResponse, isUser: false, timestamp: DateTime.now()),
        ];
        ref.read(chatMessagesProvider.notifier).state = updatedMessages;
      }    } catch (e) {
      // Fallback to mock response on error
      // Error: $e (removed debug print for production)
      final aiResponse = _generateAIResponse(text);
      final updatedMessages = [
        ...ref.read(chatMessagesProvider),
        ChatMessage(text: aiResponse, isUser: false, timestamp: DateTime.now()),
      ];
      ref.read(chatMessagesProvider.notifier).state = updatedMessages;
    }
    
    // Scroll to bottom
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
  void _startVoiceRecording() {
    final selectedLanguage = ref.read(selectedLanguageProvider);
    if (selectedLanguage == null) return;

    setState(() {}); // Trigger rebuild for UI update

    _speechService.startListening(
      language: selectedLanguage.code,
      onResult: (transcript) {
        if (transcript.trim().isNotEmpty) {
          _messageController.text = transcript;
          _sendMessage();
        }
        setState(() {}); // Update UI
      },
      onError: (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ses tanıma hatası: $error')),
        );
        setState(() {}); // Update UI
      },
    );
  }

  void _stopVoiceRecording() {
    _speechService.stopListening();
    setState(() {}); // Update UI
  }

  String _generateAIResponse(String userMessage) {
    // TODO: Replace with real AI integration
    final responses = [
      'Harika! Bu konuda daha fazla pratik yapmak ister misiniz?',
      'Çok güzel bir cümle kurmuşsunuz. Devam edin!',
      'Bu konuyu daha iyi anlamak için bir örnek verebilir misiniz?',
      'Mükemmel! Şimdi bu kelimeyi farklı bir cümlede kullanmayı deneyin.',
      'İyi bir başlangıç! Gramer kurallarına dikkat ederek tekrar deneyin.',
    ];
    return responses[DateTime.now().millisecond % responses.length];
  }
}
