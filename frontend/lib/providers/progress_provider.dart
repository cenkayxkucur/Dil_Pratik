import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/progress.dart';
import '../services/progress_service.dart';

final progressServiceProvider =
    Provider<ProgressService>((ref) => ProgressService());

final progressProvider =
    StateNotifierProvider<ProgressNotifier, AsyncValue<List<Progress>>>((ref) {
  return ProgressNotifier(ref.watch(progressServiceProvider));
});

class ProgressNotifier extends StateNotifier<AsyncValue<List<Progress>>> {
  final ProgressService _progressService;

  ProgressNotifier(this._progressService) : super(const AsyncValue.loading()) {
    _fetchProgress();
  }

  Future<void> _fetchProgress() async {
    try {
      state = const AsyncValue.loading();
      final progress = await _progressService.getProgress();
      state = AsyncValue.data(progress);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> createProgress(
      int lessonId, double score, bool completed) async {
    try {
      await _progressService.createProgress(lessonId, score, completed);
      await _fetchProgress();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> refresh() async {
    await _fetchProgress();
  }
}
