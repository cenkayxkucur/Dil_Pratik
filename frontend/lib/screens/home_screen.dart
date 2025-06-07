import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_provider.dart';
import '../models/language.dart';
import '../widgets/language_selector.dart';

// Selected language provider
final selectedLanguageProvider = StateProvider<Language?>((ref) => supportedLanguages.first);

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLanguage = ref.watch(selectedLanguageProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dil Pratik'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authControllerProvider.notifier).signOut();
              context.go('/login');
            },
          ),
        ],
      ),      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Icon(
              Icons.school,
              size: 80,
              color: Colors.blue,
            ),
            const SizedBox(height: 20),
            const Text(
              'Hoş Geldiniz!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),            const SizedBox(height: 10),            const Text(
              'Dil öğrenme yolculuğunuza başlayın',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Text(
              'Öğrenmek istediğiniz dili seçin:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            LanguageSelector(
              selectedLanguage: selectedLanguage,
              onLanguageSelected: (language) {
                ref.read(selectedLanguageProvider.notifier).state = language;
              },
            ),
            const SizedBox(height: 30),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(children: [                    ListTile(
                      leading: const Icon(Icons.book, color: Colors.blue),
                      title: const Text('Dersler'),
                      subtitle: const Text('Dil derslerine göz atın'),
                      onTap: () {
                        context.go('/lessons');
                      },
                    ),                    ListTile(
                      leading: const Icon(Icons.quiz, color: Colors.green),
                      title: const Text('Pratik'),
                      subtitle: const Text('AI ile sohbet yapın'),
                      onTap: () {
                        context.go('/practice');
                      },
                    ),                    ListTile(
                      leading: const Icon(Icons.lightbulb, color: Colors.orange),
                      title: const Text('Hatalarından Ders Al'),
                      subtitle: const Text('Hatalarınızı gözden geçirin'),
                      onTap: () {
                        context.go('/error-review');
                      },
                    ),                    ListTile(
                      leading: const Icon(Icons.analytics, color: Colors.purple),
                      title: const Text('İlerleme'),
                      subtitle: const Text('Kurs ilerlemenizi takip edin'),
                      onTap: () {
                        context.go('/progress');
                      },
                    ),
                  ],                ),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    context.go('/login');
                  },
                  child: const Text('Giriş Yap'),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.go('/register');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Kayıt Ol'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
