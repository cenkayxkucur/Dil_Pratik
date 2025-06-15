// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LessonImpl _$$LessonImplFromJson(Map<String, dynamic> json) => _$LessonImpl(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String?,
      language: json['language'] as String,
      level: json['level'] as String,
      content: json['content'] as String,
      orderIndex: (json['orderIndex'] as num?)?.toInt() ?? 0,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$LessonImplToJson(_$LessonImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'language': instance.language,
      'level': instance.level,
      'content': instance.content,
      'orderIndex': instance.orderIndex,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_$LessonListResponseImpl _$$LessonListResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$LessonListResponseImpl(
      lessons: (json['lessons'] as List<dynamic>)
          .map((e) => Lesson.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
      offset: (json['offset'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
    );

Map<String, dynamic> _$$LessonListResponseImplToJson(
        _$LessonListResponseImpl instance) =>
    <String, dynamic>{
      'lessons': instance.lessons,
      'total': instance.total,
      'offset': instance.offset,
      'limit': instance.limit,
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
