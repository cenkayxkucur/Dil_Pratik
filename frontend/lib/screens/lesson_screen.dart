import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:markdown/markdown.dart' as md;
import '../providers/lesson_provider.dart';
import '../widgets/vocabulary_card.dart';
import '../widgets/grammar_card.dart';
import '../widgets/question_card.dart';

class LessonScreen extends ConsumerStatefulWidget {
  final int lessonId;

  const LessonScreen({super.key, required this.lessonId});

  @override
  ConsumerState<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends ConsumerState<LessonScreen> {
  int _currentStep = 0;
  double _score = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(lessonContentProvider.notifier)
          .fetchLessonContent(widget.lessonId);
    });
  }

  String _parseMarkdown(String markdown) {
    final html = md.markdownToHtml(markdown);
    return html;
  }

  @override
  Widget build(BuildContext context) {
    final lessonContent = ref.watch(lessonContentProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ders'),
      ),      body: lessonContent.when(
        data: (content) {
          return Stepper(
            currentStep: _currentStep,
            onStepContinue: () {
              if (_currentStep < 3) {
                setState(() => _currentStep++);
              } else {
                _completeLesson();
              }
            },
            onStepCancel: () {
              if (_currentStep > 0) {
                setState(() => _currentStep--);
              }
            },
            steps: [
              Step(
                title: const Text('İçerik'),
                content: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          content.title,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        SelectableText(_parseMarkdown(content.content)),
                      ],
                    ),
                  ),
                ),
                isActive: _currentStep >= 0,
              ),
              Step(
                title: const Text('Kelimeler'),
                content: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: content.vocabulary.length,
                  itemBuilder: (context, index) {
                    return VocabularyCard(
                      vocabulary: content.vocabulary[index],
                    );
                  },
                ),
                isActive: _currentStep >= 1,
              ),
              Step(
                title: const Text('Dilbilgisi'),
                content: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: content.grammar.length,
                  itemBuilder: (context, index) {
                    return GrammarCard(
                      grammar: content.grammar[index],
                    );
                  },
                ),
                isActive: _currentStep >= 2,
              ),
              Step(
                title: const Text('Alıştırmalar'),
                content: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: content.questions.length,
                  itemBuilder: (context, index) {
                    return QuestionCard(
                      question: content.questions[index],
                      onAnswered: (isCorrect) {
                        if (isCorrect) {
                          setState(() {
                            _score += 1 / content.questions.length;
                          });
                        }
                      },
                    );
                  },
                ),
                isActive: _currentStep >= 3,
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Hata: $error')),
      ),
    );
  }

  void _completeLesson() {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Tebrikler! Dersi ${(_score * 100).toInt()}% başarıyla tamamladınız.'),
        ),
      );
    }
  }
}
