import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/language.dart';
import '../models/error_review.dart';
import '../widgets/language_selector.dart';
import '../screens/home_screen.dart';

// Mock error data for demonstration
final errorReviewProvider = StateProvider<List<ErrorReview>>((ref) => [
  ErrorReview(
    id: 1,
    question: "Complete the sentence: I _____ to school every day.",
    userAnswer: "goes",
    correctAnswer: "go",
    explanation: "Subject-verb agreement: 'I' is first person singular, so we use 'go' not 'goes'.",
    grammarRule: "Subject-Verb Agreement: First person singular (I) uses the base form of the verb.",
    language: supportedLanguages[1], // English
    level: LanguageLevel.A1,
    errorType: ErrorType.grammar,
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
    isReviewed: false,
  ),
  ErrorReview(
    id: 2,
    question: "What is the Turkish word for 'book'?",
    userAnswer: "masa",
    correctAnswer: "kitap",
    explanation: "'Masa' means 'table'. The correct word for 'book' is 'kitap'.",
    grammarRule: "Basic Vocabulary: Common nouns and their meanings.",
    language: supportedLanguages[0], // Turkish
    level: LanguageLevel.A1,
    errorType: ErrorType.vocabulary,
    createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    isReviewed: true,
  ),
]);

class ErrorReviewScreen extends ConsumerWidget {
  const ErrorReviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLanguage = ref.watch(selectedLanguageProvider);
    final allErrors = ref.watch(errorReviewProvider);
    
    // Filter errors by selected language
    final filteredErrors = allErrors
        .where((error) => error.language.code == selectedLanguage?.code)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hatalarından Ders Al'),
        backgroundColor: Colors.orange,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${selectedLanguage?.flag} ${selectedLanguage?.name} Hatalarınız',
                  style: Theme.of(context).textTheme.titleLarge,
                ),                Chip(
                  label: Text('${filteredErrors.length} hata'),
                  backgroundColor: Colors.orange.withValues(alpha: 0.2),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (filteredErrors.isEmpty)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.celebration,
                        size: 64,
                        color: Colors.green.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Harika! ${selectedLanguage?.name ?? "Bu dil"}de henüz hata yapmadınız.',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.green.shade600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Dersler ve pratik yaparak devam edin!',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: filteredErrors.length,
                  itemBuilder: (context, index) {
                    final error = filteredErrors[index];
                    return _buildErrorCard(context, error, ref);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorCard(BuildContext context, ErrorReview error, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  error.errorType.icon,
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    error.errorType.displayName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),                Chip(
                  label: Text(error.level.displayName.split(' - ')[0]),
                  backgroundColor: _getLevelColor(error.level).withValues(alpha: 0.2),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Soru:',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(error.question),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Container(                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Verdiğiniz Cevap:',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.red.shade700,
                          ),
                        ),
                        Text(error.userAnswer),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(                      color: Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Doğru Cevap:',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade700,
                          ),
                        ),
                        Text(error.correctAnswer),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12.0),              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Açıklama:',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.amber.shade700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(error.explanation),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Container(              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.purple.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.purple.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dil Bilgisi Kuralı:',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.purple.shade700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(error.grammarRule),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tarih: ${_formatDate(error.createdAt)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _showPracticeQuestions(context, error),
                  icon: const Icon(Icons.quiz),
                  label: const Text('Pratik Yap'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
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

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} gün önce';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} saat önce';
    } else {
      return '${difference.inMinutes} dakika önce';
    }
  }

  void _showPracticeQuestions(BuildContext context, ErrorReview error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${error.errorType.displayName} Pratiği'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Bu hata türü için özel pratik soruları yakında eklenecek!'),
            const SizedBox(height: 16),
            Text(
              'Şimdilik bu kuralı hatırlayın:\n${error.grammarRule}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }
}
