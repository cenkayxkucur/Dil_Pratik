import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/vocabulary_service.dart';
import '../services/user_session_service.dart';

final vocabularyServiceProvider =
    Provider<VocabularyService>((ref) => VocabularyService());

final savedWordsProvider =
    FutureProvider.family<List<SavedWord>, String>((ref, language) async {
  final service = ref.watch(vocabularyServiceProvider);
  final userId = UserSessionService.getCurrentUserId();
  return service.getSavedWords(userId, language);
});
