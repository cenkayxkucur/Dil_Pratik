import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/language.dart';
import '../widgets/language_selector.dart';
import '../screens/home_screen.dart';
import 'structured_level_lessons_screen.dart';

class LessonsScreen extends ConsumerWidget {
  const LessonsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLanguage = ref.watch(selectedLanguageProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('${selectedLanguage?.flag ?? ''} ${selectedLanguage?.name ?? ''} Dersleri'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dil Seçimi:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            LanguageSelector(
              selectedLanguage: selectedLanguage,
              onLanguageSelected: (language) {
                ref.read(selectedLanguageProvider.notifier).state = language;
              },
            ),
            const SizedBox(height: 20),
            Text(
              'Seviye Seçin:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: LanguageLevel.values.length,
                itemBuilder: (context, index) {
                  final level = LanguageLevel.values[index];
                  return Card(
                    elevation: 4,
                    child: InkWell(
                      onTap: () {                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => StructuredLevelLessonsScreen(
                              language: selectedLanguage!,
                              level: level,
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.school,
                              size: 40,
                              color: _getLevelColor(level),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              level.displayName.split(' - ')[0],
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: _getLevelColor(level),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              level.displayName.split(' - ')[1],
                              style: Theme.of(context).textTheme.bodyMedium,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getLevelColor(LanguageLevel level) {
    switch (level) {
      case LanguageLevel.A1:
        return Colors.green;
      case LanguageLevel.A2:
        return Colors.lightGreen;
      case LanguageLevel.B1:
        return Colors.orange;
      case LanguageLevel.B2:
        return Colors.deepOrange;
      case LanguageLevel.C1:
        return Colors.red;
      case LanguageLevel.C2:
        return Colors.purple;
    }
  }
}
