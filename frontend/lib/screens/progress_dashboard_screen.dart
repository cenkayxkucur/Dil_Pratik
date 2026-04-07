import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';

import '../providers/language_provider.dart';
import '../providers/progress_provider.dart';
import '../services/progress_service.dart';

class ProgressDashboardScreen extends ConsumerWidget {
  const ProgressDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLanguage = ref.watch(selectedLanguageProvider);
    final language = selectedLanguage?.code ?? 'english';

    final profileAsync = ref.watch(learningProfileProvider(language));
    final activityAsync = ref.watch(
      activityProvider(ActivityParams(language, 7)),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('${selectedLanguage?.flag ?? ''} İlerleme'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(learningProfileProvider(language));
              ref.invalidate(activityProvider(ActivityParams(language, 7)));
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(learningProfileProvider(language));
          ref.invalidate(activityProvider(ActivityParams(language, 7)));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: profileAsync.when(
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.only(top: 80),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (e, _) => _ErrorCard(message: e.toString()),
            data: (profile) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (profile.totalInteractions == 0)
                  _EmptyState(language: language)
                else ...[
                  _StatsRow(profile: profile),
                  const SizedBox(height: 20),
                  activityAsync.when(
                    loading: () => const _ChartSkeleton(),
                    error: (_, __) => const SizedBox.shrink(),
                    data: (days) => _ActivityChart(days: days),
                  ),
                  const SizedBox(height: 20),
                  if (profile.weakGrammar.isNotEmpty) ...[
                    _WeakGrammarCard(areas: profile.weakGrammar),
                    const SizedBox(height: 20),
                  ],
                  if (profile.weakVocabulary.isNotEmpty) ...[
                    _WeakVocabCard(words: profile.weakVocabulary),
                    const SizedBox(height: 20),
                  ],
                  if (profile.strongGrammar.isNotEmpty) ...[
                    _StrongGrammarCard(areas: profile.strongGrammar),
                    const SizedBox(height: 20),
                  ],
                  if (profile.frequentTopics.isNotEmpty)
                    _TopicsCard(topics: profile.frequentTopics),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// Stats row
// ──────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  final LearningProfile profile;
  const _StatsRow({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: 'Toplam Pratik',
            value: '${profile.totalInteractions}',
            icon: Icons.chat_bubble_outline,
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            label: 'Zayıf Alan',
            value: '${profile.weakGrammar.length + profile.weakVocabulary.length}',
            icon: Icons.warning_amber_rounded,
            color: Colors.orange,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            label: 'Güçlü Alan',
            value: '${profile.strongGrammar.length + profile.strongVocabulary.length}',
            icon: Icons.star_outline,
            color: Colors.green,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 6),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// Activity chart (son 7 gün)
// ──────────────────────────────────────────────────────────────

class _ActivityChart extends StatelessWidget {
  final List<DayActivity> days;
  const _ActivityChart({required this.days});

  @override
  Widget build(BuildContext context) {
    final maxCount = days.map((d) => d.count).fold(0, (a, b) => a > b ? a : b);
    final maxY = (maxCount < 5 ? 5 : maxCount + 1).toDouble();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Son 7 Gün — Günlük Pratik',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 160,
              child: BarChart(
                BarChartData(
                  maxY: maxY,
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles:
                        const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles:
                        const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles:
                        const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, _) {
                          final idx = value.toInt();
                          if (idx < 0 || idx >= days.length) {
                            return const Text('');
                          }
                          final date = days[idx].date;
                          final parts = date.split('-');
                          return Text(
                            '${parts[2]}/${parts[1]}',
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                  ),
                  barGroups: List.generate(days.length, (i) {
                    final d = days[i];
                    return BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: d.count.toDouble(),
                          color: d.count > 0 ? Colors.blue : Colors.grey[300],
                          width: 18,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(4),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChartSkeleton extends StatelessWidget {
  const _ChartSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// Weak grammar
// ──────────────────────────────────────────────────────────────

class _WeakGrammarCard extends StatelessWidget {
  final List<GrammarArea> areas;
  const _WeakGrammarCard({required this.areas});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Zayıf Gramer Alanları',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...areas.take(6).map((a) => _AreaBar(
                  label: a.display,
                  errorRate: a.errorRate,
                  color: _colorForErrorRate(a.errorRate),
                )),
          ],
        ),
      ),
    );
  }

  Color _colorForErrorRate(double rate) {
    if (rate >= 0.7) return Colors.red;
    if (rate >= 0.4) return Colors.orange;
    return Colors.yellow[700]!;
  }
}

class _AreaBar extends StatelessWidget {
  final String label;
  final double errorRate;
  final Color color;

  const _AreaBar({
    required this.label,
    required this.errorRate,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(label,
                    style: Theme.of(context).textTheme.bodyMedium,
                    overflow: TextOverflow.ellipsis),
              ),
              Text(
                '${(errorRate * 100).toInt()}% hata',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: color, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: errorRate,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// Weak vocabulary
// ──────────────────────────────────────────────────────────────

class _WeakVocabCard extends StatelessWidget {
  final List<VocabArea> words;
  const _WeakVocabCard({required this.words});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.spellcheck, color: Colors.red, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Tekrar Gereken Kelimeler',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: words.take(10).map((w) {
                final opacity = 0.4 + (w.errorRate * 0.6);
                return Chip(
                  label: Text(w.word),
                  backgroundColor:
                      Colors.red.withValues(alpha: opacity.clamp(0.0, 1.0)),
                  labelStyle: const TextStyle(color: Colors.white),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// Strong grammar
// ──────────────────────────────────────────────────────────────

class _StrongGrammarCard extends StatelessWidget {
  final List<GrammarArea> areas;
  const _StrongGrammarCard({required this.areas});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.star, color: Colors.green, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Güçlü Alanlar',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...areas.take(4).map((a) => _AreaBar(
                  label: a.display,
                  errorRate: a.errorRate,
                  color: Colors.green,
                )),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// Topics
// ──────────────────────────────────────────────────────────────

class _TopicsCard extends StatelessWidget {
  final List<String> topics;
  const _TopicsCard({required this.topics});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.topic, color: Colors.purple, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Çalışılan Konular',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: topics
                  .map((t) => Chip(
                        label: Text(t),
                        backgroundColor:
                            Colors.purple.withValues(alpha: 0.12),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// Empty & error states
// ──────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final String language;
  const _EmptyState({required this.language});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 60),
        child: Column(
          children: [
            Icon(Icons.insights, size: 72, color: Colors.grey[300]),
            const SizedBox(height: 20),
            Text(
              'Henüz veri yok',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'Pratik yaptıkça AI zayıf ve güçlü\nalanlarını burada gösterir.',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.grey[500]),
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
