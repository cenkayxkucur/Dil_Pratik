import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/language_provider.dart';
import '../providers/progress_provider.dart';
import '../services/progress_service.dart';

class ErrorReviewScreen extends ConsumerWidget {
  const ErrorReviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLanguage = ref.watch(selectedLanguageProvider);
    final language = selectedLanguage?.code ?? 'english';
    final queueAsync = ref.watch(reviewQueueProvider(language));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hatalarından Öğren'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(reviewQueueProvider(language)),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(reviewQueueProvider(language)),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: queueAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.only(top: 80),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => _ErrorCard(message: e.toString()),
            data: (queue) => queue.isEmpty
                ? _EmptyState(
                    onPractice: () => context.go('/practice'),
                  )
                : _QueueContent(queue: queue, language: language),
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// Main content
// ──────────────────────────────────────────────────────────────

class _QueueContent extends StatelessWidget {
  final ReviewQueue queue;
  final String language;

  const _QueueContent({required this.queue, required this.language});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Özet banner
        _SummaryBanner(queue: queue),
        const SizedBox(height: 20),

        // Tekrar zamanı gelen kelimeler
        if (queue.dueWords.isNotEmpty) ...[
          _SectionHeader(
            icon: Icons.schedule_rounded,
            title: 'Tekrar Zamanı Geldi',
            count: queue.dueWords.length,
            color: Colors.red,
          ),
          const SizedBox(height: 8),
          _WordChipGrid(words: queue.dueWords, color: Colors.red),
          const SizedBox(height: 20),
        ],

        // Zayıf gramer
        if (queue.weakGrammar.isNotEmpty) ...[
          _SectionHeader(
            icon: Icons.edit_note_rounded,
            title: 'Zayıf Gramer Kuralları',
            count: queue.weakGrammar.length,
            color: Colors.orange,
          ),
          const SizedBox(height: 8),
          ...queue.weakGrammar.map((g) => _GrammarRuleCard(grammar: g)),
          const SizedBox(height: 20),
        ],

        // Zayıf kelimeler
        if (queue.weakVocabulary.isNotEmpty) ...[
          _SectionHeader(
            icon: Icons.spellcheck_rounded,
            title: 'Tekrar Gereken Kelimeler',
            count: queue.weakVocabulary.length,
            color: Colors.deepOrange,
          ),
          const SizedBox(height: 8),
          _WordChipGrid(words: queue.weakVocabulary, color: Colors.deepOrange),
          const SizedBox(height: 20),
        ],

        // Pratik yap butonu
        _PracticeButton(language: language),
        const SizedBox(height: 20),
      ],
    );
  }
}

// ──────────────────────────────────────────────────────────────
// Summary banner
// ──────────────────────────────────────────────────────────────

class _SummaryBanner extends StatelessWidget {
  final ReviewQueue queue;
  const _SummaryBanner({required this.queue});

  @override
  Widget build(BuildContext context) {
    final totalItems =
        queue.dueWords.length + queue.weakGrammar.length + queue.weakVocabulary.length;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE65100), Color(0xFFFF8F00)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.auto_fix_high_rounded, color: Colors.white, size: 36),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$totalItems konu dikkatini bekliyor',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${queue.dueWords.length} kelime • ${queue.weakGrammar.length} gramer kuralı',
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// Section header
// ──────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final int count;
  final Color color;

  const _SectionHeader({
    required this.icon,
    required this.title,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '$count',
            style: TextStyle(
                color: color, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────────────────────
// Word chip grid
// ──────────────────────────────────────────────────────────────

class _WordChipGrid extends StatelessWidget {
  final List<ReviewWord> words;
  final Color color;

  const _WordChipGrid({required this.words, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: words.map((w) {
            final intensity = 0.35 + (w.errorRate * 0.65);
            return Tooltip(
              message: '${(w.errorRate * 100).toInt()}% hata · '
                  '${w.incorrect}✗ ${w.correct}✓',
              child: Chip(
                label: Text(
                  w.word,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600),
                ),
                backgroundColor:
                    color.withOpacity(intensity.clamp(0.0, 1.0)),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// Grammar rule card
// ──────────────────────────────────────────────────────────────

class _GrammarRuleCard extends StatelessWidget {
  final ReviewGrammar grammar;
  const _GrammarRuleCard({required this.grammar});

  Color get _color {
    if (grammar.errorRate >= 0.7) return Colors.red;
    if (grammar.errorRate >= 0.4) return Colors.orange;
    return Colors.amber[700]!;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    grammar.display,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${(grammar.errorRate * 100).toInt()}% hata',
                  style: TextStyle(
                    color: _color,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            LinearProgressIndicator(
              value: grammar.errorRate,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(_color),
              minHeight: 5,
              borderRadius: BorderRadius.circular(3),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                _Pill(
                  label: '${grammar.incorrect} yanlış',
                  color: Colors.red,
                ),
                const SizedBox(width: 6),
                _Pill(
                  label: '${grammar.correct} doğru',
                  color: Colors.green,
                ),
                if (grammar.level.isNotEmpty) ...[
                  const SizedBox(width: 6),
                  _Pill(label: grammar.level, color: Colors.blue),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String label;
  final Color color;
  const _Pill({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// Practice CTA
// ──────────────────────────────────────────────────────────────

class _PracticeButton extends StatelessWidget {
  final String language;
  const _PracticeButton({required this.language});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.chat_bubble_rounded),
        label: const Text('AI ile Pratik Yap'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: () => context.go('/practice'),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// Empty & error states
// ──────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final VoidCallback onPractice;
  const _EmptyState({required this.onPractice});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 60),
        child: Column(
          children: [
            Icon(Icons.celebration_rounded, size: 72, color: Colors.green[300]),
            const SizedBox(height: 20),
            Text(
              'Harika! Tekrar bekleyen konu yok.',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Pratik yaptıkça AI zayıf noktalarını\nburada gösterir.',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.grey[500]),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              icon: const Icon(Icons.chat_bubble_rounded),
              label: const Text('Pratik Yap'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: onPractice,
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final String message;
  const _ErrorCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.red[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.red),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
      ),
    );
  }
}
