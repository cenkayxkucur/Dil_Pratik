import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/language.dart';
import '../models/lesson.dart';
import '../services/api_service.dart';
import '../widgets/expandable_lesson_card.dart';
import '../widgets/state_template.dart';

class LevelLessonsScreen extends ConsumerWidget {
  final Language language;
  final LanguageLevel level;

  const LevelLessonsScreen({
    super.key,
    required this.language,
    required this.level,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lessonsAsync = ref.watch(_levelLessonsProvider((language.code, level.code)));
    
    return Scaffold(
      appBar: AppBar(
        title: Text('${language.flag} ${language.name} - ${level.displayName}'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: StateTemplate<List<Lesson>>(
        asyncValue: lessonsAsync,
        emptyMessage: 'Bu seviyede henüz ders bulunmuyor.\nYakında yeni dersler eklenecek!',
        errorTitle: 'Dersler Yüklenemedi',
        onRetry: () => ref.refresh(_levelLessonsProvider((language.code, level.code))),
        dataBuilder: (lessons) => ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: lessons.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final lesson = lessons[index];
            return ExpandableLessonCard(lesson: lesson);
          },
        ),
      ),
    );
  }
}

final _levelLessonsProvider = FutureProvider.family<List<Lesson>, (String, String)>((ref, tuple) async {
  final apiService = ApiService();
  final response = await apiService.getLessonsByFilter(language: tuple.$1, level: tuple.$2);
  return LessonListResponse.fromJson(response).lessons;
});
