import 'package:flutter/material.dart';
import '../models/lesson.dart';

class GrammarCard extends StatelessWidget {
  final Grammar grammar;

  const GrammarCard({
    super.key,
    required this.grammar,
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
              grammar.point,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              grammar.explanation,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Text(
              grammar.example,
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
