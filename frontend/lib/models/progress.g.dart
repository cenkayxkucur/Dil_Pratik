// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProgressImpl _$$ProgressImplFromJson(Map<String, dynamic> json) =>
    _$ProgressImpl(
      id: (json['id'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
      lessonId: (json['lessonId'] as num).toInt(),
      score: (json['score'] as num).toDouble(),
      completed: json['completed'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ProgressImplToJson(_$ProgressImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'lessonId': instance.lessonId,
      'score': instance.score,
      'completed': instance.completed,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_$ProgressCreateImpl _$$ProgressCreateImplFromJson(Map<String, dynamic> json) =>
    _$ProgressCreateImpl(
      lessonId: (json['lessonId'] as num).toInt(),
      score: (json['score'] as num).toDouble(),
      completed: json['completed'] as bool? ?? false,
    );

Map<String, dynamic> _$$ProgressCreateImplToJson(
        _$ProgressCreateImpl instance) =>
    <String, dynamic>{
      'lessonId': instance.lessonId,
      'score': instance.score,
      'completed': instance.completed,
    };

_$EvaluationImpl _$$EvaluationImplFromJson(Map<String, dynamic> json) =>
    _$EvaluationImpl(
      score: (json['score'] as num).toDouble(),
      isCorrect: json['isCorrect'] as bool,
      feedback: json['feedback'] as String,
      corrections: (json['corrections'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$EvaluationImplToJson(_$EvaluationImpl instance) =>
    <String, dynamic>{
      'score': instance.score,
      'isCorrect': instance.isCorrect,
      'feedback': instance.feedback,
      'corrections': instance.corrections,
    };
