import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/structured_lesson.dart';
import '../services/api_service.dart';
import '../services/user_session_service.dart';

class LessonChatWidget extends ConsumerStatefulWidget {
  final StructuredLessonResponse lesson;
  final String language;
  final String level;

  const LessonChatWidget({
    super.key,
    required this.lesson,
    required this.language,
    required this.level,
  });

  @override
  ConsumerState<LessonChatWidget> createState() => _LessonChatWidgetState();
}

class _LessonChatWidgetState extends ConsumerState<LessonChatWidget>
    with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    
    // Welcome message
    _addMessage(ChatMessage(
      text: 'Merhaba! ${widget.lesson.title} dersi hakkında sorularınızı yanıtlamaya hazırım. 📚',
      isUser: false,
      timestamp: DateTime.now(),
    ));
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
    
    if (_isExpanded) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  void _addMessage(ChatMessage message) {
    setState(() {
      _messages.add(message);
    });
    _scrollToBottom();
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

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty || _isLoading) return;

    // Add user message
    _addMessage(ChatMessage(
      text: message,
      isUser: true,
      timestamp: DateTime.now(),
    ));

    _messageController.clear();
    setState(() {
      _isLoading = true;
    });

    try {
      final apiService = ApiService();
      final response = await apiService.lessonChat(
        message: message,
        lessonId: widget.lesson.id,
        lessonContent: widget.lesson.content,
        lessonTitle: widget.lesson.title,
        language: widget.language,
        level: widget.level,
        userId: UserSessionService.getCurrentUserId(),
      );

      // Add AI response
      _addMessage(ChatMessage(
        text: response,
        isUser: false,
        timestamp: DateTime.now(),
      ));
    } catch (e) {
      _addMessage(ChatMessage(
        text: 'Üzgünüm, şu anda mesajınızı işleyemiyorum. Lütfen tekrar deneyin.',
        isUser: false,
        timestamp: DateTime.now(),
        isError: true,
      ));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      right: 20,
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: _isExpanded ? 350 : 60,
          height: _isExpanded ? 400 : 60,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: _isExpanded ? _buildExpandedChat() : _buildCollapsedButton(),
        ),
      ),
    );
  }

  Widget _buildCollapsedButton() {
    return InkWell(
      onTap: _toggleExpansion,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade400, Colors.blue.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(
          Icons.chat_bubble_outline,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }

  Widget _buildExpandedChat() {
    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade400, Colors.blue.shade600],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Row(
            children: [
              const Icon(Icons.school, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Ders Asistanı',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              IconButton(
                onPressed: _toggleExpansion,
                icon: const Icon(Icons.close, color: Colors.white, size: 20),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),
        
        // Messages
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(8),
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessageBubble(_messages[index]);
              },
            ),
          ),
        ),
        
        // Loading indicator
        if (_isLoading)
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                const SizedBox(width: 8),
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade400),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Asistan yazıyor...',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        
        // Input
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.grey.shade200),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Ders hakkında soru sorun...',
                    hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  style: const TextStyle(fontSize: 14),
                  maxLines: null,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
              const SizedBox(width: 8),
              Material(
                color: Colors.blue.shade400,
                borderRadius: BorderRadius.circular(20),
                child: InkWell(
                  onTap: _isLoading ? null : _sendMessage,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            CircleAvatar(
              radius: 12,
              backgroundColor: message.isError ? Colors.red.shade100 : Colors.blue.shade100,
              child: Icon(
                message.isError ? Icons.error_outline : Icons.school,
                size: 14,
                color: message.isError ? Colors.red.shade600 : Colors.blue.shade600,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: message.isUser
                    ? Colors.blue.shade400
                    : message.isError
                        ? Colors.red.shade50
                        : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: message.isUser
                      ? Colors.white
                      : message.isError
                          ? Colors.red.shade700
                          : Colors.black87,
                  fontSize: 13,
                ),
              ),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 12,
              backgroundColor: Colors.green.shade100,
              child: Icon(
                Icons.person,
                size: 14,
                color: Colors.green.shade600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final bool isError;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.isError = false,
  });
}
