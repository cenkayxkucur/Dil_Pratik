// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'structured_lesson.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LanguageLevelResponseImpl _$$LanguageLevelResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$LanguageLevelResponseImpl(
      id: (json['id'] as num).toInt(),
      language: json['language'] as String,
      level: json['level'] as String,
      displayName: json['display_name'] as String,
      description: json['description'] as String?,
      orderIndex: (json['order_index'] as num?)?.toInt() ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$LanguageLevelResponseImplToJson(
        _$LanguageLevelResponseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'language': instance.language,
      'level': instance.level,
      'display_name': instance.displayName,
      'description': instance.description,
      'order_index': instance.orderIndex,
      'is_active': instance.isActive,
      'created_at': instance.createdAt.toIso8601String(),
    };

_$GrammarTopicResponseImpl _$$GrammarTopicResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$GrammarTopicResponseImpl(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String?,
      languageLevelId: (json['language_level_id'] as num).toInt(),
      orderIndex: (json['order_index'] as num?)?.toInt() ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$GrammarTopicResponseImplToJson(
        _$GrammarTopicResponseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'language_level_id': instance.languageLevelId,
      'order_index': instance.orderIndex,
      'is_active': instance.isActive,
      'created_at': instance.createdAt.toIso8601String(),
    };

_$StructuredLessonResponseImpl _$$StructuredLessonResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$StructuredLessonResponseImpl(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String?,
      content: json['content'] as String,
      grammarTopicId: (json['grammar_topic_id'] as num).toInt(),
      orderIndex: (json['order_index'] as num?)?.toInt() ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$StructuredLessonResponseImplToJson(
        _$StructuredLessonResponseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'content': instance.content,
      'grammar_topic_id': instance.grammarTopicId,
      'order_index': instance.orderIndex,
      'is_active': instance.isActive,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

_$LanguageLevelWithTopicsImpl _$$LanguageLevelWithTopicsImplFromJson(
        Map<String, dynamic> json) =>
    _$LanguageLevelWithTopicsImpl(
      languageLevel: LanguageLevelResponse.fromJson(
          json['language_level'] as Map<String, dynamic>),
      grammarTopics: (json['grammar_topics'] as List<dynamic>)
          .map((e) => GrammarTopicResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$LanguageLevelWithTopicsImplToJson(
        _$LanguageLevelWithTopicsImpl instance) =>
    <String, dynamic>{
      'language_level': instance.languageLevel,
      'grammar_topics': instance.grammarTopics,
    };

_$GrammarTopicWithLessonsImpl _$$GrammarTopicWithLessonsImplFromJson(
        Map<String, dynamic> json) =>
    _$GrammarTopicWithLessonsImpl(
      grammarTopic: GrammarTopicResponse.fromJson(
          json['grammar_topic'] as Map<String, dynamic>),
      lessons: (json['lessons'] as List<dynamic>)
          .map((e) =>
              StructuredLessonResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$GrammarTopicWithLessonsImplToJson(
        _$GrammarTopicWithLessonsImpl instance) =>
    <String, dynamic>{
      'grammar_topic': instance.grammarTopic,
      'lessons': instance.lessons,
    };

_$LanguageLessonsResponseImpl _$$LanguageLessonsResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$LanguageLessonsResponseImpl(
      language: json['language'] as String,
      level: json['level'] as String?,
      topicId: (json['topicId'] as num?)?.toInt(),
      lessons: (json['lessons'] as List<dynamic>)
          .map((e) =>
              StructuredLessonResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
      offset: (json['offset'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
    );

Map<String, dynamic> _$$LanguageLessonsResponseImplToJson(
        _$LanguageLessonsResponseImpl instance) =>
    <String, dynamic>{
      'language': instance.language,
      'level': instance.level,
      'topicId': instance.topicId,
      'lessons': instance.lessons,
      'total': instance.total,
      'offset': instance.offset,
      'limit': instance.limit,
    };
