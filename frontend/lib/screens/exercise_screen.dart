import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/app_config.dart';
import '../services/token_manager.dart';

// ──────────────────────────────────────────────────────────────
// Egzersiz veri modelleri
// ──────────────────────────────────────────────────────────────

abstract class Exercise {
  String get type;
}

class MultipleChoiceExercise implements Exercise {
  @override
  final String type = 'multiple_choice';
  final String question;
  final List<String> options;
  final String correctAnswer;
  final String explanation;

  const MultipleChoiceExercise({
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
  });

  factory MultipleChoiceExercise.fromJson(Map<String, dynamic> j) =>
      MultipleChoiceExercise(
        question: j['question'] as String,
        options: (j['options'] as List).cast<String>(),
        correctAnswer: j['correct_answer'] as String,
        explanation: j['explanation'] as String? ?? '',
      );
}

class FillBlankExercise implements Exercise {
  @override
  final String type = 'fill_blank';
  final String sentence;
  final String answer;
  final String hint;

  const FillBlankExercise({
    required this.sentence,
    required this.answer,
    required this.hint,
  });

  factory FillBlankExercise.fromJson(Map<String, dynamic> j) =>
      FillBlankExercise(
        sentence: j['sentence'] as String,
        answer: j['answer'] as String,
        hint: j['hint'] as String? ?? '',
      );
}

class TranslationExercise implements Exercise {
  @override
  final String type = 'translation';
  final String sourceText;
  final String sourceLanguage;
  final String targetLanguage;
  final String expectedAnswer;
  final List<String> alternatives;

  const TranslationExercise({
    required this.sourceText,
    required this.sourceLanguage,
    required this.targetLanguage,
    required this.expectedAnswer,
    required this.alternatives,
  });

  factory TranslationExercise.fromJson(Map<String, dynamic> j) =>
      TranslationExercise(
        sourceText: j['source_text'] as String,
        sourceLanguage: j['source_language'] as String? ?? '',
        targetLanguage: j['target_language'] as String? ?? '',
        expectedAnswer: j['expected_answer'] as String,
        alternatives:
            (j['alternatives'] as List? ?? []).cast<String>(),
      );
}

Exercise _parseExercise(Map<String, dynamic> j) {
  final type = j['type'] as String?;
  switch (type) {
    case 'fill_blank':
      return FillBlankExercise.fromJson(j);
    case 'translation':
      return TranslationExercise.fromJson(j);
    default:
      return MultipleChoiceExercise.fromJson(j);
  }
}

// ──────────────────────────────────────────────────────────────
// Egzersiz Ekranı
// ──────────────────────────────────────────────────────────────

class ExerciseScreen extends StatefulWidget {
  final String lessonContent;
  final String lessonTitle;
  final String language;
  final String level;

  const ExerciseScreen({
    super.key,
    required this.lessonContent,
    required this.lessonTitle,
    required this.language,
    required this.level,
  });

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  List<Exercise>? _exercises;
  bool _loading = true;
  String? _error;
  int _current = 0;
  int _score = 0;
  bool _finished = false;

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  Future<void> _loadExercises() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final storage = const FlutterSecureStorage();
      final token = await storage.read(key: 'auth_token');
      final dio = Dio(BaseOptions(baseUrl: AppConfig.apiBaseUrl));
      if (token != null) {
        dio.options.headers['Authorization'] = 'Bearer $token';
      }
      dio.interceptors.add(InterceptorsWrapper(
        onError: (e, handler) async {
          if (e.response?.statusCode == 401) {
            await TokenManager.handleUnauthorized();
          }
          return handler.next(e);
        },
      ));

      final response = await dio.post('/ai/generate-exercises', data: {
        'lesson_content': widget.lessonContent,
        'language': widget.language,
        'level': widget.level,
      });

      final list = (response.data['exercises'] as List? ?? []);
      setState(() {
        _exercises =
            list.map((e) => _parseExercise(e as Map<String, dynamic>)).toList();
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Egzersizler yüklenemedi: $e';
        _loading = false;
      });
    }
  }

  void _onAnswered(bool correct) {
    if (correct) _score++;
    if (_current + 1 >= (_exercises?.length ?? 0)) {
      setState(() => _finished = true);
    } else {
      setState(() => _current++);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Egzersiz: ${widget.lessonTitle}'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_error!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red)),
                      const SizedBox(height: 16),
                      FilledButton.icon(
                        onPressed: _loadExercises,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Tekrar Dene'),
                      ),
                    ],
                  ),
                )
              : _finished
                  ? _ResultScreen(
                      score: _score,
                      total: _exercises!.length,
                      onRetry: () {
                        setState(() {
                          _current = 0;
                          _score = 0;
                          _finished = false;
                        });
                      },
                      onNew: _loadExercises,
                    )
                  : _buildExercise(),
    );
  }

  Widget _buildExercise() {
    final exercises = _exercises!;
    final exercise = exercises[_current];
    final progress = (_current + 1) / exercises.length;

    return Column(
      children: [
        // İlerleme çubuğu
        LinearProgressIndicator(value: progress, minHeight: 6),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${_current + 1} / ${exercises.length}',
                  style: Theme.of(context).textTheme.bodySmall),
              Text('Puan: $_score',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: switch (exercise) {
              MultipleChoiceExercise e => _MultipleChoiceCard(
                  exercise: e, onAnswered: _onAnswered),
              FillBlankExercise e =>
                _FillBlankCard(exercise: e, onAnswered: _onAnswered),
              TranslationExercise e =>
                _TranslationCard(exercise: e, onAnswered: _onAnswered),
              _ => const SizedBox.shrink(),
            },
          ),
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────────────────────
// Çoktan Seçmeli
// ──────────────────────────────────────────────────────────────

class _MultipleChoiceCard extends StatefulWidget {
  final MultipleChoiceExercise exercise;
  final void Function(bool) onAnswered;
  const _MultipleChoiceCard(
      {required this.exercise, required this.onAnswered});

  @override
  State<_MultipleChoiceCard> createState() => _MultipleChoiceCardState();
}

class _MultipleChoiceCardState extends State<_MultipleChoiceCard> {
  String? _selected;
  bool _answered = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ExerciseTypeChip(label: 'Çoktan Seçmeli', color: Colors.blue),
            const SizedBox(height: 16),
            Text(widget.exercise.question,
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            ...widget.exercise.options.map((opt) {
              Color? tileColor;
              if (_answered) {
                if (opt == widget.exercise.correctAnswer) {
                  tileColor = Colors.green.withOpacity(0.15);
                } else if (opt == _selected) {
                  tileColor = Colors.red.withOpacity(0.1);
                }
              }
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: tileColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: _answered && opt == widget.exercise.correctAnswer
                        ? Colors.green
                        : Colors.grey.withOpacity(0.3),
                  ),
                ),
                child: RadioListTile<String>(
                  title: Text(opt),
                  value: opt,
                  groupValue: _selected,
                  onChanged:
                      _answered ? null : (v) => setState(() => _selected = v),
                ),
              );
            }),
            if (_answered) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _selected == widget.exercise.correctAnswer
                      ? Colors.green.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _selected == widget.exercise.correctAnswer
                          ? '✓ Doğru!'
                          : '✗ Yanlış. Doğru cevap: ${widget.exercise.correctAnswer}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _selected == widget.exercise.correctAnswer
                            ? Colors.green[700]
                            : Colors.red[700],
                      ),
                    ),
                    if (widget.exercise.explanation.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(widget.exercise.explanation,
                          style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton(
                  onPressed: () => widget.onAnswered(
                      _selected == widget.exercise.correctAnswer),
                  child: const Text('Devam'),
                ),
              ),
            ] else
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton(
                  onPressed: _selected == null
                      ? null
                      : () => setState(() => _answered = true),
                  child: const Text('Yanıtla'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// Boşluk Doldurma
// ──────────────────────────────────────────────────────────────

class _FillBlankCard extends StatefulWidget {
  final FillBlankExercise exercise;
  final void Function(bool) onAnswered;
  const _FillBlankCard({required this.exercise, required this.onAnswered});

  @override
  State<_FillBlankCard> createState() => _FillBlankCardState();
}

class _FillBlankCardState extends State<_FillBlankCard> {
  final _ctrl = TextEditingController();
  bool _answered = false;
  bool _correct = false;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _check() {
    final userAnswer = _ctrl.text.trim().toLowerCase();
    final expected = widget.exercise.answer.toLowerCase();
    setState(() {
      _correct = userAnswer == expected;
      _answered = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final parts = widget.exercise.sentence.split('___');

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ExerciseTypeChip(label: 'Boşluk Doldurma', color: Colors.orange),
            const SizedBox(height: 16),
            // Cümle gösterimi
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                if (parts.isNotEmpty) Text(parts[0], style: Theme.of(context).textTheme.titleMedium),
                Container(
                  width: 120,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: TextField(
                    controller: _ctrl,
                    enabled: !_answered,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      border: const OutlineInputBorder(),
                      filled: _answered,
                      fillColor: _answered
                          ? (_correct
                              ? Colors.green.withOpacity(0.15)
                              : Colors.red.withOpacity(0.1))
                          : null,
                    ),
                    onSubmitted: (_answered) ? null : (_) => _check(),
                  ),
                ),
                if (parts.length > 1) Text(parts[1], style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            if (widget.exercise.hint.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text('İpucu: ${widget.exercise.hint}',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.grey[600], fontStyle: FontStyle.italic)),
            ],
            const SizedBox(height: 16),
            if (_answered) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _correct
                      ? Colors.green.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _correct
                      ? '✓ Doğru!'
                      : '✗ Doğru cevap: "${widget.exercise.answer}"',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _correct ? Colors.green[700] : Colors.red[700],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton(
                  onPressed: () => widget.onAnswered(_correct),
                  child: const Text('Devam'),
                ),
              ),
            ] else
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton(onPressed: _check, child: const Text('Kontrol Et')),
              ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// Çeviri
// ──────────────────────────────────────────────────────────────

class _TranslationCard extends StatefulWidget {
  final TranslationExercise exercise;
  final void Function(bool) onAnswered;
  const _TranslationCard({required this.exercise, required this.onAnswered});

  @override
  State<_TranslationCard> createState() => _TranslationCardState();
}

class _TranslationCardState extends State<_TranslationCard> {
  final _ctrl = TextEditingController();
  bool _answered = false;
  bool _correct = false;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _check() {
    final userAnswer = _ctrl.text.trim().toLowerCase();
    final expected = widget.exercise.expectedAnswer.toLowerCase();
    final alts = widget.exercise.alternatives
        .map((a) => a.toLowerCase())
        .toList();
    setState(() {
      _correct =
          userAnswer == expected || alts.any((a) => userAnswer == a);
      _answered = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ExerciseTypeChip(label: 'Çeviri', color: Colors.teal),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.teal.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.teal.withOpacity(0.2)),
              ),
              child: Text(
                widget.exercise.sourceText,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontStyle: FontStyle.italic),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '${widget.exercise.targetLanguage} diline çevir:',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _ctrl,
              enabled: !_answered,
              maxLines: 2,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: 'Çevirinizi yazın...',
                filled: _answered,
                fillColor: _answered
                    ? (_correct
                        ? Colors.green.withOpacity(0.1)
                        : Colors.red.withOpacity(0.08))
                    : null,
              ),
            ),
            const SizedBox(height: 12),
            if (_answered) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _correct
                      ? Colors.green.withOpacity(0.1)
                      : Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _correct ? '✓ Harika çeviri!' : 'Beklenen cevap:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _correct ? Colors.green[700] : Colors.orange[800],
                      ),
                    ),
                    if (!_correct) ...[
                      const SizedBox(height: 4),
                      Text(widget.exercise.expectedAnswer),
                      if (widget.exercise.alternatives.isNotEmpty)
                        Text(
                          'Alternatifler: ${widget.exercise.alternatives.join(", ")}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (!_correct)
                    TextButton(
                      onPressed: () => widget.onAnswered(true),
                      child: const Text('Kabul Et (yakın)'),
                    ),
                  FilledButton(
                    onPressed: () => widget.onAnswered(_correct),
                    child: const Text('Devam'),
                  ),
                ],
              ),
            ] else
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton(onPressed: _check, child: const Text('Kontrol Et')),
              ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// Sonuç Ekranı
// ──────────────────────────────────────────────────────────────

class _ResultScreen extends StatelessWidget {
  final int score;
  final int total;
  final VoidCallback onRetry;
  final VoidCallback onNew;

  const _ResultScreen({
    required this.score,
    required this.total,
    required this.onRetry,
    required this.onNew,
  });

  @override
  Widget build(BuildContext context) {
    final pct = total > 0 ? (score / total * 100).round() : 0;
    final emoji = pct >= 80 ? '🎉' : pct >= 50 ? '👍' : '💪';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 64)),
            const SizedBox(height: 16),
            Text('Egzersiz Tamamlandı!',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    )),
            const SizedBox(height: 8),
            Text(
              '$score / $total doğru (%$pct)',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: pct >= 70 ? Colors.green : Colors.orange,
                  ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.replay),
                  label: const Text('Tekrar'),
                ),
                const SizedBox(width: 12),
                FilledButton.icon(
                  onPressed: onNew,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Yeni Egzersiz'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// Yardımcı widget
// ──────────────────────────────────────────────────────────────

class _ExerciseTypeChip extends StatelessWidget {
  final String label;
  final Color color;
  const _ExerciseTypeChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
