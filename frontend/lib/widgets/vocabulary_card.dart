import 'package:flutter/material.dart';
import '../models/lesson.dart';

class VocabularyCard extends StatelessWidget {
  final Vocabulary vocabulary;

  const VocabularyCard({
    super.key,
    required this.vocabulary,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              vocabulary.word,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              vocabulary.translation,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Text(
              vocabulary.example,
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
