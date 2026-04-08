import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_provider.dart';
import '../providers/language_provider.dart';
import '../providers/progress_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/ui_language_provider.dart';
import '../services/progress_service.dart';
import '../services/user_session_service.dart';
import '../widgets/language_selector.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider);
    final selectedLanguage = ref.watch(selectedLanguageProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dil Pratik'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          // Arayüz dili seçici
          _UiLangButton(),
          // Tema toggle
          IconButton(
            icon: Icon(ref.watch(themeModeProvider) == ThemeMode.dark
                ? Icons.light_mode_outlined
                : Icons.dark_mode_outlined),
            tooltip: ref.watch(appStringsProvider).changeTheme,
            onPressed: () => ref.read(themeModeProvider.notifier).toggle(),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: ref.watch(appStringsProvider).logout,
            onPressed: () async {
              await ref.read(authControllerProvider.notifier).signOut();
              if (context.mounted) context.go('/login');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kullanıcı karşılama kartı
            _GreetingCard(username: user?.username ?? ''),

            // Streak & günlük hedef
            if (selectedLanguage != null) ...[
              const SizedBox(height: 16),
              _StreakBar(language: selectedLanguage.code),
            ],
            const SizedBox(height: 24),

            // Dil seçici
            Text(
              ref.watch(appStringsProvider).learningLanguage,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(color: Colors.grey[600], fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            LanguageSelector(
              selectedLanguage: selectedLanguage,
              onLanguageSelected: (language) {
                ref.read(selectedLanguageProvider.notifier).state = language;
              },
            ),
            const SizedBox(height: 28),

            // Navigasyon kartları
            Text(
              ref.watch(appStringsProvider).whatToDo,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(color: Colors.grey[600], fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            _NavGrid(selectedLanguage: selectedLanguage?.code),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// Greeting Card
// ──────────────────────────────────────────────────────────────

class _GreetingCard extends StatelessWidget {
  final String username;
  const _GreetingCard({required this.username});

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Günaydın';
    if (hour < 18) return 'İyi günler';
    return 'İyi akşamlar';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1976D2), Color(0xFF42A5F5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.school, color: Colors.white, size: 40),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$_greeting${username.isNotEmpty ? ', $username' : ''}!',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Dil öğrenme yolculuğuna devam et',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
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
// Streak & Daily Goal Bar
// ──────────────────────────────────────────────────────────────

class _StreakBar extends ConsumerWidget {
  final String language;
  const _StreakBar({required this.language});

  Future<void> _showGoalDialog(
    BuildContext context,
    WidgetRef ref,
    StreakData streak,
  ) async {
    int selected = streak.dailyGoalTarget;
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Günlük Hedef'),
        content: StatefulBuilder(
          builder: (ctx, setState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Günde kaç pratik yapmak istiyorsun?',
                style: Theme.of(ctx).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: selected > 1
                        ? () => setState(() => selected--)
                        : null,
                  ),
                  Text(
                    '$selected',
                    style: Theme.of(ctx).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: selected < 50
                        ? () => setState(() => selected++)
                        : null,
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('İptal'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              final service = ref.read(progressServiceProvider);
              final userId = UserSessionService.getCurrentUserId();
              await service.setDailyGoal(userId, language, selected);
              ref.invalidate(streakProvider(language));
            },
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streakAsync = ref.watch(streakProvider(language));

    return streakAsync.when(
      loading: () => const SizedBox(height: 72, child: Center(child: LinearProgressIndicator())),
      error: (_, __) => const SizedBox.shrink(),
      data: (streak) => GestureDetector(
        onTap: () => _showGoalDialog(context, ref, streak),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              // Streak
              _StreakChip(streak: streak.currentStreak),
              const SizedBox(width: 16),
              // Daily goal
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          streak.goalCompleted
                              ? 'Günlük hedef tamamlandı!'
                              : 'Günlük hedef',
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: streak.goalCompleted
                                    ? Colors.green[700]
                                    : null,
                              ),
                        ),
                        Text(
                          '${streak.todayCount}/${streak.dailyGoalTarget}',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: streak.todayProgress,
                        minHeight: 8,
                        backgroundColor: Colors.grey[300],
                        color: streak.goalCompleted ? Colors.green : Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.edit_outlined, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

class _StreakChip extends StatelessWidget {
  final int streak;
  const _StreakChip({required this.streak});

  @override
  Widget build(BuildContext context) {
    final active = streak > 0;
    return Column(
      children: [
        Text(
          active ? '\u{1F525}' : '\u2B50',
          style: const TextStyle(fontSize: 26),
        ),
        Text(
          '$streak gün',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: active ? Colors.deepOrange : Colors.grey,
              ),
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────────────────────
// Navigation Grid
// ──────────────────────────────────────────────────────────────

class _NavGrid extends ConsumerWidget {
  final String? selectedLanguage;
  const _NavGrid({this.selectedLanguage});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appStringsProvider);
    final items = [
      _NavItem(
        icon: Icons.menu_book_rounded,
        label: s.lessons,
        subtitle: s.lessonsSubtitle,
        color: Colors.blue,
        route: '/lessons',
      ),
      _NavItem(
        icon: Icons.chat_bubble_rounded,
        label: s.practice,
        subtitle: s.practiceSubtitle,
        color: Colors.green,
        route: '/practice',
      ),
      _NavItem(
        icon: Icons.insights_rounded,
        label: s.progress,
        subtitle: s.progressSubtitle,
        color: Colors.purple,
        route: '/progress',
      ),
      _NavItem(
        icon: Icons.auto_fix_high_rounded,
        label: s.learnFromErrors,
        subtitle: s.learnFromErrorsSubtitle,
        color: Colors.orange,
        route: '/error-review',
      ),
      _NavItem(
        icon: Icons.translate_rounded,
        label: s.vocabulary,
        subtitle: s.vocabularySubtitle,
        color: Colors.teal,
        route: '/vocabulary',
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        // Geniş ekranda 3 kolon, dar ekranda 2 kolon
        final cols = constraints.maxWidth >= 640 ? 3 : 2;
        final cardWidth = (constraints.maxWidth - 12 * (cols - 1)) / cols;
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: items.map((item) {
            return SizedBox(
              width: cardWidth,
              height: cardWidth / 1.15,
              child: _NavCard(item: item),
            );
          }).toList(),
        );
      },
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final String route;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.route,
  });
}

class _NavCard extends StatefulWidget {
  final _NavItem item;
  const _NavCard({required this.item});

  @override
  State<_NavCard> createState() => _NavCardState();
}

class _NavCardState extends State<_NavCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '${widget.item.label}. ${widget.item.subtitle}',
      child: AnimatedScale(
        scale: _pressed ? 0.94 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        child: Card(
          elevation: _pressed ? 1 : 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTapDown: (_) => setState(() => _pressed = true),
            onTapUp: (_) => setState(() => _pressed = false),
            onTapCancel: () => setState(() => _pressed = false),
            onTap: () => context.go(widget.item.route),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: widget.item.color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child:
                        Icon(widget.item.icon, color: widget.item.color, size: 26),
                  ),
                  const Spacer(),
                  Text(
                    widget.item.label,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.item.subtitle,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.grey[600]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// Arayüz Dili Seçici (AppBar butonu)
// ──────────────────────────────────────────────────────────────

class _UiLangButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentCode = ref.watch(uiLanguageProvider);
    final s = ref.watch(appStringsProvider);

    return PopupMenuButton<String>(
      tooltip: s.changeLanguage,
      icon: Text(
        flagForLang(currentCode),
        style: const TextStyle(fontSize: 20),
      ),
      itemBuilder: (_) => kUiLangOptions
          .map(
            (opt) => PopupMenuItem<String>(
              value: opt.code,
              child: Row(
                children: [
                  Text(opt.flag, style: const TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  Text(opt.label),
                  if (opt.code == currentCode) ...[
                    const Spacer(),
                    const Icon(Icons.check, size: 16, color: Colors.blue),
                  ],
                ],
              ),
            ),
          )
          .toList(),
      onSelected: (code) =>
          ref.read(uiLanguageProvider.notifier).setLanguage(code),
    );
  }
}
