import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_provider.dart';
import '../providers/language_provider.dart';
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
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Çıkış Yap',
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
            const SizedBox(height: 24),

            // Dil seçici
            Text(
              'Öğrendiğin dil',
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
              'Ne yapmak istersin?',
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
// Navigation Grid
// ──────────────────────────────────────────────────────────────

class _NavGrid extends StatelessWidget {
  final String? selectedLanguage;
  const _NavGrid({this.selectedLanguage});

  @override
  Widget build(BuildContext context) {
    final items = [
      _NavItem(
        icon: Icons.menu_book_rounded,
        label: 'Dersler',
        subtitle: 'Yapılandırılmış ders içerikleri',
        color: Colors.blue,
        route: '/lessons',
      ),
      _NavItem(
        icon: Icons.chat_bubble_rounded,
        label: 'Pratik',
        subtitle: 'AI ile sohbet yaparak pratik et',
        color: Colors.green,
        route: '/practice',
      ),
      _NavItem(
        icon: Icons.insights_rounded,
        label: 'İlerleme',
        subtitle: 'Güçlü ve zayıf alanlarını gör',
        color: Colors.purple,
        route: '/progress',
      ),
      _NavItem(
        icon: Icons.auto_fix_high_rounded,
        label: 'Hatalarından Öğren',
        subtitle: 'Tekrar gereken konular',
        color: Colors.orange,
        route: '/error-review',
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.15,
      ),
      itemBuilder: (context, i) {
        final item = items[i];
        return _NavCard(item: item);
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

class _NavCard extends StatelessWidget {
  final _NavItem item;
  const _NavCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => context.go(item.route),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: item.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(item.icon, color: item.color, size: 26),
              ),
              const Spacer(),
              Text(
                item.label,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                item.subtitle,
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
    );
  }
}
