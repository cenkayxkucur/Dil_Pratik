import 'package:freezed_annotation/freezed_annotation.dart';
import 'language.dart';

part 'error_review.freezed.dart';
part 'error_review.g.dart';

@freezed
class ErrorReview with _$ErrorReview {
  const factory ErrorReview({
    required int id,
    required String question,
    required String userAnswer,
    required String correctAnswer,
    required String explanation,
    required String grammarRule,
    required Language language,
    required LanguageLevel level,
    required ErrorType errorType,
    required DateTime createdAt,
    @Default(false) bool isReviewed,
  }) = _ErrorReview;

  factory ErrorReview.fromJson(Map<String, dynamic> json) => _$ErrorReviewFromJson(json);
}

enum ErrorType {
  grammar,
  vocabulary,
  pronunciation,
  comprehension,
}

extension ErrorTypeExtension on ErrorType {
  String get displayName {
    switch (this) {
      case ErrorType.grammar:
        return 'Dil Bilgisi';
      case ErrorType.vocabulary:
        return 'Kelime Bilgisi';
      case ErrorType.pronunciation:
        return 'Telaffuz';
      case ErrorType.comprehension:
        return 'Anlama';
    }
  }

  String get icon {
    switch (this) {
      case ErrorType.grammar:
        return '📝';
      case ErrorType.vocabulary:
        return '📚';
      case ErrorType.pronunciation:
        return '🗣️';
      case ErrorType.comprehension:
        return '🧠';
    }
  }
}
