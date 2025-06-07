// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LessonImpl _$$LessonImplFromJson(Map<String, dynamic> json) => _$LessonImpl(
      id: (json['id'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
      title: json['title'] as String,
      content: json['content'] as String,
      level: $enumDecode(_$LanguageLevelEnumMap, json['level']),
      language: Language.fromJson(json['language'] as Map<String, dynamic>),
      type: $enumDecode(_$LessonTypeEnumMap, json['type']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      isCompleted: json['isCompleted'] as bool? ?? false,
      score: (json['score'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$LessonImplToJson(_$LessonImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'title': instance.title,
      'content': instance.content,
      'level': _$LanguageLevelEnumMap[instance.level]!,
      'language': instance.language,
      'type': _$LessonTypeEnumMap[instance.type]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'isCompleted': instance.isCompleted,
      'score': instance.score,
    };

const _$LanguageLevelEnumMap = {
  LanguageLevel.A1: 'A1',
  LanguageLevel.A2: 'A2',
  LanguageLevel.B1: 'B1',
  LanguageLevel.B2: 'B2',
  LanguageLevel.C1: 'C1',
  LanguageLevel.C2: 'C2',
};

const _$LessonTypeEnumMap = {
  LessonType.grammar: 'grammar',
  LessonType.vocabulary: 'vocabulary',
  LessonType.listening: 'listening',
  LessonType.speaking: 'speaking',
  LessonType.reading: 'reading',
  LessonType.writing: 'writing',
};

_$LessonContentImpl _$$LessonContentImplFromJson(Map<String, dynamic> json) =>
    _$LessonContentImpl(
      title: json['title'] as String,
      content: json['content'] as String,
      language: json['language'] as String,
      vocabulary: (json['vocabulary'] as List<dynamic>)
          .map((e) => Vocabulary.fromJson(e as Map<String, dynamic>))
          .toList(),
      grammar: (json['grammar'] as List<dynamic>)
          .map((e) => Grammar.fromJson(e as Map<String, dynamic>))
          .toList(),
      questions: (json['questions'] as List<dynamic>)
          .map((e) => Question.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$LessonContentImplToJson(_$LessonContentImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'content': instance.content,
      'language': instance.language,
      'vocabulary': instance.vocabulary,
      'grammar': instance.grammar,
      'questions': instance.questions,
    };

_$VocabularyImpl _$$VocabularyImplFromJson(Map<String, dynamic> json) =>
    _$VocabularyImpl(
      word: json['word'] as String,
      translation: json['translation'] as String,
      example: json['example'] as String,
    );

Map<String, dynamic> _$$VocabularyImplToJson(_$VocabularyImpl instance) =>
    <String, dynamic>{
      'word': instance.word,
      'translation': instance.translation,
      'example': instance.example,
    };

_$GrammarImpl _$$GrammarImplFromJson(Map<String, dynamic> json) =>
    _$GrammarImpl(
      point: json['point'] as String,
      explanation: json['explanation'] as String,
      example: json['example'] as String,
    );

Map<String, dynamic> _$$GrammarImplToJson(_$GrammarImpl instance) =>
    <String, dynamic>{
      'point': instance.point,
      'explanation': instance.explanation,
      'example': instance.example,
    };

_$QuestionImpl _$$QuestionImplFromJson(Map<String, dynamic> json) =>
    _$QuestionImpl(
      question: json['question'] as String,
      correctAnswer: json['correctAnswer'] as String,
      options:
          (json['options'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$QuestionImplToJson(_$QuestionImpl instance) =>
    <String, dynamic>{
      'question': instance.question,
      'correctAnswer': instance.correctAnswer,
      'options': instance.options,
    };
