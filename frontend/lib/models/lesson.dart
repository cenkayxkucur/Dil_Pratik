import 'package:freezed_annotation/freezed_annotation.dart';
import 'language.dart';

part 'lesson.freezed.dart';
part 'lesson.g.dart';

@freezed
class Lesson with _$Lesson {
  const factory Lesson({
    required int id,
    required int userId,
    required String title,
    required String content,
    required LanguageLevel level,
    required Language language,
    required LessonType type,
    required DateTime createdAt,
    DateTime? updatedAt,
    @Default(false) bool isCompleted,
    @Default(0) int score,
  }) = _Lesson;

  factory Lesson.fromJson(Map<String, dynamic> json) => _$LessonFromJson(json);
}

enum LessonType {
  grammar,
  vocabulary,
  listening,
  speaking,
  reading,
  writing,
}

extension LessonTypeExtension on LessonType {
  String get displayName {
    switch (this) {
      case LessonType.grammar:
        return 'Dil Bilgisi';
      case LessonType.vocabulary:
        return 'Kelime Bilgisi';
      case LessonType.listening:
        return 'Dinleme';
      case LessonType.speaking:
        return 'Konuşma';
      case LessonType.reading:
        return 'Okuma';
      case LessonType.writing:
        return 'Yazma';
    }
  }

  String get icon {
    switch (this) {
      case LessonType.grammar:
        return '📝';
      case LessonType.vocabulary:
        return '📚';
      case LessonType.listening:
        return '👂';
      case LessonType.speaking:
        return '🗣️';
      case LessonType.reading:
        return '📖';      case LessonType.writing:
        return '✍️';
    }
  }
}

@freezed
class LessonContent with _$LessonContent {
  const factory LessonContent({
    required String title,
    required String content,
    required String language,
    required List<Vocabulary> vocabulary,
    required List<Grammar> grammar,
    required List<Question> questions,
  }) = _LessonContent;

  factory LessonContent.fromJson(Map<String, dynamic> json) =>
      _$LessonContentFromJson(json);
}

@freezed
class Vocabulary with _$Vocabulary {
  const factory Vocabulary({
    required String word,
    required String translation,
    required String example,
  }) = _Vocabulary;

  factory Vocabulary.fromJson(Map<String, dynamic> json) =>
      _$VocabularyFromJson(json);
}

@freezed
class Grammar with _$Grammar {
  const factory Grammar({
    required String point,
    required String explanation,
    required String example,
  }) = _Grammar;

  factory Grammar.fromJson(Map<String, dynamic> json) =>
      _$GrammarFromJson(json);
}

@freezed
class Question with _$Question {
  const factory Question({
    required String question,
    required String correctAnswer,
    required List<String> options,
  }) = _Question;

  factory Question.fromJson(Map<String, dynamic> json) =>
      _$QuestionFromJson(json);
}
