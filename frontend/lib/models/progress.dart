import 'package:freezed_annotation/freezed_annotation.dart';

part 'progress.freezed.dart';
part 'progress.g.dart';

@freezed
class Progress with _$Progress {
  const factory Progress({
    required int id,
    required int userId,
    required int lessonId,
    required double score,
    @Default(false) bool completed,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _Progress;

  factory Progress.fromJson(Map<String, dynamic> json) =>
      _$ProgressFromJson(json);
}

@freezed
class ProgressCreate with _$ProgressCreate {
  const factory ProgressCreate({
    required int lessonId,
    required double score,
    @Default(false) bool completed,
  }) = _ProgressCreate;

  factory ProgressCreate.fromJson(Map<String, dynamic> json) =>
      _$ProgressCreateFromJson(json);
}

@freezed
class Evaluation with _$Evaluation {
  const factory Evaluation({
    required double score,
    required bool isCorrect,
    required String feedback,
    required List<String> corrections,
  }) = _Evaluation;

  factory Evaluation.fromJson(Map<String, dynamic> json) =>
      _$EvaluationFromJson(json);
}
