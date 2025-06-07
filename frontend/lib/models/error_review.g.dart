// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ErrorReviewImpl _$$ErrorReviewImplFromJson(Map<String, dynamic> json) =>
    _$ErrorReviewImpl(
      id: (json['id'] as num).toInt(),
      question: json['question'] as String,
      userAnswer: json['userAnswer'] as String,
      correctAnswer: json['correctAnswer'] as String,
      explanation: json['explanation'] as String,
      grammarRule: json['grammarRule'] as String,
      language: Language.fromJson(json['language'] as Map<String, dynamic>),
      level: $enumDecode(_$LanguageLevelEnumMap, json['level']),
      errorType: $enumDecode(_$ErrorTypeEnumMap, json['errorType']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      isReviewed: json['isReviewed'] as bool? ?? false,
    );

Map<String, dynamic> _$$ErrorReviewImplToJson(_$ErrorReviewImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'question': instance.question,
      'userAnswer': instance.userAnswer,
      'correctAnswer': instance.correctAnswer,
      'explanation': instance.explanation,
      'grammarRule': instance.grammarRule,
      'language': instance.language,
      'level': _$LanguageLevelEnumMap[instance.level]!,
      'errorType': _$ErrorTypeEnumMap[instance.errorType]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'isReviewed': instance.isReviewed,
    };

const _$LanguageLevelEnumMap = {
  LanguageLevel.A1: 'A1',
  LanguageLevel.A2: 'A2',
  LanguageLevel.B1: 'B1',
  LanguageLevel.B2: 'B2',
  LanguageLevel.C1: 'C1',
  LanguageLevel.C2: 'C2',
};

const _$ErrorTypeEnumMap = {
  ErrorType.grammar: 'grammar',
  ErrorType.vocabulary: 'vocabulary',
  ErrorType.pronunciation: 'pronunciation',
  ErrorType.comprehension: 'comprehension',
};
