import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../widgets/language_selector.dart';
import '../widgets/level_selector.dart';
import '../services/api_service.dart';
import '../services/speech_service.dart';
import '../services/tts_service.dart';
import '../services/user_session_service.dart';
import '../providers/language_provider.dart';
import '../providers/vocabulary_provider.dart';
import '../providers/ui_language_provider.dart';

final voiceInputEnabledProvider = StateProvider<bool>((ref) => false);
final voiceOutputEnabledProvider = StateProvider<bool>((ref) => false);
final pronunciationModeProvider = StateProvider<bool>((ref) => false);
final ttsRateProvider = StateProvider<TtsRate>((ref) => TtsRate.normal);
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
    final pronunciationMode = ref.watch(pronunciationModeProvider);
    final ttsRate = ref.watch(ttsRateProvider);
    final messages = ref.watch(chatMessagesProvider);
    final s = ref.watch(appStringsProvider);
    final isWide = MediaQuery.of(context).size.width >= 700;

    final settingsPanel = _SettingsPanel(
      selectedLanguage: selectedLanguage,
      selectedLevel: selectedLevel,
      communicationLanguage: communicationLanguage,
      voiceInputEnabled: voiceInputEnabled,
      voiceOutputEnabled: voiceOutputEnabled,
      pronunciationMode: pronunciationMode,
      ttsRate: ttsRate,
      isListening: _isListening,
      isSpeaking: _isSpeaking,
      onLanguageChanged: (l) =>
          ref.read(selectedLanguageProvider.notifier).state = l,
      onLevelChanged: (l) =>
          ref.read(selectedLevelProvider.notifier).state = l,
      onCommLangChanged: (l) =>
          ref.read(communicationLanguageProvider.notifier).state = l,
      onVoiceInputChanged: (v) {
        ref.read(voiceInputEnabledProvider.notifier).state = v;
        if (!v && _isListening) _stopVoiceRecording();
      },
      onVoiceOutputChanged: (v) {
        ref.read(voiceOutputEnabledProvider.notifier).state = v;
        if (!v && _isSpeaking) {
          _ttsService.stop();
          setState(() => _isSpeaking = false);
        }
      },
      onPronunciationModeChanged: (v) {
        ref.read(pronunciationModeProvider.notifier).state = v;
        if (v) {
          final hint = ChatMessage(
            text: s.pronunciationHint,
            isUser: false,
            timestamp: DateTime.now(),
          );
          ref.read(chatMessagesProvider.notifier).state = [
            ...ref.read(chatMessagesProvider),
            hint,
          ];
        }
      },
      onTtsRateChanged: (r) {
        ref.read(ttsRateProvider.notifier).state = r;
        _ttsService.setRate(r);
      },
    );

    final chatPanel = Column(
      children: [
        if (pronunciationMode)
          Consumer(builder: (context, ref, _) {
            final s2 = ref.watch(appStringsProvider);
            return Container(
              margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.deepPurple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: Colors.deepPurple.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.record_voice_over,
                      size: 16, color: Colors.deepPurple),
                  const SizedBox(width: 6),
                  Text(
                    s2.pronunciationMode,
                    style: const TextStyle(
                        color: Colors.deepPurple,
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            );
          }),
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16.0),
            itemCount: messages.length,
            itemBuilder: (context, index) =>
                _buildMessageBubble(messages[index]),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border(
              top: BorderSide(
                  color: Theme.of(context).colorScheme.outline, width: 1),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: s.typeMessage,
                    border: const OutlineInputBorder(),
                    isDense: true,
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
                  onPressed: _isListening
                      ? _stopVoiceRecording
                      : _startVoiceRecording,
                ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: _sendMessage,
              ),
            ],
          ),
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(s.practiceTitle),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            tooltip: 'Ana Sayfa',
            onPressed: () => context.go('/'),
          ),
        ],
      ),
      body: isWide
          ? Row(
              children: [
                // Sol panel: ayarlar (sabit genişlik)
                SizedBox(
                  width: 280,
                  child: SingleChildScrollView(child: settingsPanel),
                ),
                const VerticalDivider(width: 1),
                // Sağ panel: sohbet
                Expanded(child: chatPanel),
              ],
            )
          : Column(
              children: [
                settingsPanel,
                const Divider(height: 1),
                Expanded(child: chatPanel),
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
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.72,
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
          if (!message.isUser) ...[
            const SizedBox(width: 4),
            IconButton(
              icon: const Icon(Icons.menu_book_outlined, size: 18),
              color: Colors.teal,
              tooltip: 'Kelime kaydet',
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
              onPressed: () => _showSaveWordDialog(),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _showSaveWordDialog() async {
    final selectedLanguage = ref.read(selectedLanguageProvider);
    final language = selectedLanguage?.code ?? 'english';

    final wordCtrl = TextEditingController();
    final translationCtrl = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: const [
            Icon(Icons.menu_book, color: Colors.teal),
            SizedBox(width: 8),
            Text('Kelime Kaydet'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: wordCtrl,
              decoration: const InputDecoration(
                labelText: 'Kelime',
                hintText: 'Kaydetmek istediğin kelime',
              ),
              autofocus: true,
              textCapitalization: TextCapitalization.none,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: translationCtrl,
              decoration: const InputDecoration(
                labelText: 'Anlam / Not (isteğe bağlı)',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('İptal'),
          ),
          FilledButton(
            onPressed: () async {
              final word = wordCtrl.text.trim();
              if (word.isEmpty) return;
              Navigator.of(ctx).pop();
              final service = ref.read(vocabularyServiceProvider);
              final userId = UserSessionService.getCurrentUserId();
              final ok = await service.saveWord(
                userId: userId,
                language: language,
                word: word,
                translation: translationCtrl.text.trim().isEmpty
                    ? null
                    : translationCtrl.text.trim(),
              );
              if (ok && mounted) {
                ref.invalidate(savedWordsProvider(language));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('"$word" kelime defterine eklendi')),
                );
              }
            },
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );

    wordCtrl.dispose();
    translationCtrl.dispose();
  }

  void _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    ref.read(chatMessagesProvider.notifier).state = [
      ...ref.read(chatMessagesProvider),
      ChatMessage(text: text, isUser: true, timestamp: DateTime.now()),
    ];
    _messageController.clear();
    _scrollToBottom();

    try {
      final selectedLanguage = ref.read(selectedLanguageProvider);
      final selectedLevel = ref.read(selectedLevelProvider);
      final communicationLanguage = ref.read(communicationLanguageProvider);
      final isPronunciation = ref.read(pronunciationModeProvider);

      final response = await ApiService.getChatResponse(
        text,
        selectedLanguage,
        level: selectedLevel,
        communicationLanguage: communicationLanguage,
        sessionType: isPronunciation ? 'pronunciation' : 'conversation',
      );

      ref.read(chatMessagesProvider.notifier).state = [
        ...ref.read(chatMessagesProvider),
        ChatMessage(text: response, isUser: false, timestamp: DateTime.now()),
      ];
      _scrollToBottom();

      if (ref.read(voiceOutputEnabledProvider)) {
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
      final currentRate = ref.read(ttsRateProvider);
      _ttsService.speak(
        text: text,
        language: selectedLanguage?.name ?? selectedLanguage?.code ?? 'tr',
        rate: currentRate,
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

// ──────────────────────────────────────────────────────────────
// Settings Panel (responsive: sol kolon veya üst bölüm)
// ──────────────────────────────────────────────────────────────

class _SettingsPanel extends ConsumerWidget {
  final dynamic selectedLanguage;
  final dynamic selectedLevel;
  final dynamic communicationLanguage;
  final bool voiceInputEnabled;
  final bool voiceOutputEnabled;
  final bool pronunciationMode;
  final TtsRate ttsRate;
  final bool isListening;
  final bool isSpeaking;
  final void Function(dynamic) onLanguageChanged;
  final void Function(dynamic) onLevelChanged;
  final void Function(dynamic) onCommLangChanged;
  final void Function(bool) onVoiceInputChanged;
  final void Function(bool) onVoiceOutputChanged;
  final void Function(bool) onPronunciationModeChanged;
  final void Function(TtsRate) onTtsRateChanged;

  const _SettingsPanel({
    required this.selectedLanguage,
    required this.selectedLevel,
    required this.communicationLanguage,
    required this.voiceInputEnabled,
    required this.voiceOutputEnabled,
    required this.pronunciationMode,
    required this.ttsRate,
    required this.isListening,
    required this.isSpeaking,
    required this.onLanguageChanged,
    required this.onLevelChanged,
    required this.onCommLangChanged,
    required this.onVoiceInputChanged,
    required this.onVoiceOutputChanged,
    required this.onPronunciationModeChanged,
    required this.onTtsRateChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appStringsProvider);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Dil', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 6),
          LanguageSelector(
            selectedLanguage: selectedLanguage,
            onLanguageSelected: onLanguageChanged,
          ),
          const SizedBox(height: 12),
          Text('Seviye', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 6),
          LevelSelector(
            selectedLevel: selectedLevel,
            onLevelSelected: onLevelChanged,
          ),
          const SizedBox(height: 12),
          Text('Yanıt Dili', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 6),
          LanguageSelector(
            selectedLanguage: communicationLanguage,
            onLanguageSelected: onCommLangChanged,
          ),
          const SizedBox(height: 16),
          const Divider(),
          _SwitchRow(
            icon: Icons.mic,
            label: 'Ses Girişi',
            value: voiceInputEnabled,
            onChanged: onVoiceInputChanged,
          ),
          _SwitchRow(
            icon: Icons.volume_up,
            label: 'Ses Çıkışı',
            value: voiceOutputEnabled,
            onChanged: onVoiceOutputChanged,
          ),
          // TTS hız kontrolü — yalnızca ses çıkışı aktifken göster
          if (voiceOutputEnabled) ...[
            const SizedBox(height: 8),
            Semantics(
              label: '${s.speechSpeed}: ${_rateName(ttsRate, s)}',
              child: Row(
                children: [
                  Icon(Icons.speed, size: 18, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(s.speechSpeed,
                      style: Theme.of(context).textTheme.bodyMedium),
                  const Spacer(),
                  SegmentedButton<TtsRate>(
                    showSelectedIcon: false,
                    style: SegmentedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                    ),
                    segments: [
                      ButtonSegment(
                          value: TtsRate.slow,
                          label: Text(s.slow,
                              style: const TextStyle(fontSize: 11))),
                      ButtonSegment(
                          value: TtsRate.normal,
                          label: Text(s.normal,
                              style: const TextStyle(fontSize: 11))),
                      ButtonSegment(
                          value: TtsRate.fast,
                          label: Text(s.fast,
                              style: const TextStyle(fontSize: 11))),
                    ],
                    selected: {ttsRate},
                    onSelectionChanged: (set) => onTtsRateChanged(set.first),
                  ),
                ],
              ),
            ),
          ],
          _SwitchRow(
            icon: Icons.record_voice_over,
            label: s.pronunciationMode,
            value: pronunciationMode,
            onChanged: onPronunciationModeChanged,
            activeColor: Colors.deepPurple,
          ),
        ],
      ),
    );
  }

  String _rateName(TtsRate r, dynamic s) {
    switch (r) {
      case TtsRate.slow:
        return s.slow as String;
      case TtsRate.fast:
        return s.fast as String;
      default:
        return s.normal as String;
    }
  }
}

class _SwitchRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool value;
  final void Function(bool) onChanged;
  final Color? activeColor;

  const _SwitchRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(child: Text(label)),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: activeColor,
        ),
      ],
    );
  }
}