import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/lesson.dart';
import '../services/lesson_service.dart';

final lessonServiceProvider = Provider<LessonService>((ref) => LessonService());

final lessonListProvider =
    StateNotifierProvider<LessonListNotifier, AsyncValue<List<Lesson>>>((ref) {
  return LessonListNotifier(ref.watch(lessonServiceProvider));
});

final lessonContentProvider =
    StateNotifierProvider<LessonContentNotifier, AsyncValue<LessonContent>>(
        (ref) {
  return LessonContentNotifier(ref.watch(lessonServiceProvider));
});

class LessonListNotifier extends StateNotifier<AsyncValue<List<Lesson>>> {
  final LessonService _lessonService;

  LessonListNotifier(this._lessonService) : super(const AsyncValue.loading()) {
    _fetchLessons();
  }

  Future<void> _fetchLessons() async {
    try {
      state = const AsyncValue.loading();
      final lessons = await _lessonService.getLessons();
      state = AsyncValue.data(lessons);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> refresh() async {
    await _fetchLessons();
  }
}

class LessonContentNotifier extends StateNotifier<AsyncValue<LessonContent>> {
  final LessonService _lessonService;
  int? _currentLessonId;

  LessonContentNotifier(this._lessonService)
      : super(const AsyncValue.loading());

  Future<void> fetchLessonContent(int lessonId) async {
    if (_currentLessonId == lessonId) return;
    _currentLessonId = lessonId;

    try {
      state = const AsyncValue.loading();
      final content = await _lessonService.getLessonContent(lessonId);
      state = AsyncValue.data(content);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> refresh() async {
    if (_currentLessonId != null) {
      await fetchLessonContent(_currentLessonId!);
    }
  }
}
