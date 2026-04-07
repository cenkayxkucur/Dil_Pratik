import 'package:freezed_annotation/freezed_annotation.dart';

part 'structured_lesson.freezed.dart';
part 'structured_lesson.g.dart';

@freezed
class LanguageLevelResponse with _$LanguageLevelResponse {
  const factory LanguageLevelResponse({
    required int id,
    required String language,
    required String level,
    @JsonKey(name: 'display_name') required String displayName,
    String? description,
    @JsonKey(name: 'order_index') @Default(0) int orderIndex,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _LanguageLevelResponse;

  factory LanguageLevelResponse.fromJson(Map<String, dynamic> json) => _$LanguageLevelResponseFromJson(json);
}

@freezed
class GrammarTopicResponse with _$GrammarTopicResponse {
  const factory GrammarTopicResponse({
    required int id,
    required String title,
    String? description,
    @JsonKey(name: 'language_level_id') required int languageLevelId,
    @JsonKey(name: 'order_index') @Default(0) int orderIndex,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _GrammarTopicResponse;

  factory GrammarTopicResponse.fromJson(Map<String, dynamic> json) => _$GrammarTopicResponseFromJson(json);
}

@freezed
class StructuredLessonResponse with _$StructuredLessonResponse {
  const factory StructuredLessonResponse({
    required int id,
    required String title,
    String? description,
    required String content,
    @JsonKey(name: 'grammar_topic_id') required int grammarTopicId,
    @JsonKey(name: 'order_index') @Default(0) int orderIndex,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _StructuredLessonResponse;

  factory StructuredLessonResponse.fromJson(Map<String, dynamic> json) => _$StructuredLessonResponseFromJson(json);
}

@freezed
class LanguageLevelWithTopics with _$LanguageLevelWithTopics {
  const factory LanguageLevelWithTopics({
    @JsonKey(name: 'language_level') required LanguageLevelResponse languageLevel,
    @JsonKey(name: 'grammar_topics') required List<GrammarTopicResponse> grammarTopics,
  }) = _LanguageLevelWithTopics;

  factory LanguageLevelWithTopics.fromJson(Map<String, dynamic> json) => _$LanguageLevelWithTopicsFromJson(json);
}

@freezed
class GrammarTopicWithLessons with _$GrammarTopicWithLessons {
  const factory GrammarTopicWithLessons({
    @JsonKey(name: 'grammar_topic') required GrammarTopicResponse grammarTopic,
    required List<StructuredLessonResponse> lessons,
  }) = _GrammarTopicWithLessons;

  factory GrammarTopicWithLessons.fromJson(Map<String, dynamic> json) => _$GrammarTopicWithLessonsFromJson(json);
}

@freezed
class LanguageLessonsResponse with _$LanguageLessonsResponse {
  const factory LanguageLessonsResponse({
    required String language,
    String? level,
    int? topicId,
    required List<StructuredLessonResponse> lessons,
    required int total,
    required int offset,
    required int limit,
  }) = _LanguageLessonsResponse;

  factory LanguageLessonsResponse.fromJson(Map<String, dynamic> json) => _$LanguageLessonsResponseFromJson(json);
}
