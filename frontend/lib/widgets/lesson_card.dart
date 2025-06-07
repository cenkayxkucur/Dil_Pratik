import 'package:flutter/material.dart';
import '../models/lesson.dart';

class LessonCard extends StatelessWidget {
  final Lesson lesson;
  final VoidCallback onTap;

  const LessonCard({
    super.key,
    required this.lesson,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(
          lesson.title,
          style: Theme.of(context).textTheme.titleMedium,
        ),        subtitle: Text(
          '${lesson.language.name} - ${lesson.level.name.toUpperCase()}',
          style: TextStyle(color: Theme.of(context).colorScheme.secondary),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
