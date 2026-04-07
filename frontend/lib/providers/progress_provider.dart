import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/progress_service.dart';
import '../services/user_session_service.dart';

final progressServiceProvider =
    Provider<ProgressService>((ref) => ProgressService());

// ──────────────────────────────────────────────────────────────
// Öğrenme Profili (zayıf/güçlü alanlar)
// ──────────────────────────────────────────────────────────────

final learningProfileProvider = FutureProvider.family<LearningProfile, String>(
  (ref, language) async {
    final service = ref.watch(progressServiceProvider);
    final userId = UserSessionService.getCurrentUserId();
    return service.getProfile(userId, language);
  },
);

// ──────────────────────────────────────────────────────────────
// Günlük aktivite (grafik için)
// ──────────────────────────────────────────────────────────────

class ActivityParams {
  final String language;
  final int days;
  const ActivityParams(this.language, this.days);

  @override
  bool operator ==(Object other) =>
      other is ActivityParams && other.language == language && other.days == days;

  @override
  int get hashCode => Object.hash(language, days);
}

final activityProvider =
    FutureProvider.family<List<DayActivity>, ActivityParams>(
  (ref, params) async {
    final service = ref.watch(progressServiceProvider);
    final userId = UserSessionService.getCurrentUserId();
    return service.getActivity(userId, params.language, days: params.days);
  },
);
