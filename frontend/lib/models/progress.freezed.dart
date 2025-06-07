// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'progress.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Progress _$ProgressFromJson(Map<String, dynamic> json) {
  return _Progress.fromJson(json);
}

/// @nodoc
mixin _$Progress {
  int get id => throw _privateConstructorUsedError;
  int get userId => throw _privateConstructorUsedError;
  int get lessonId => throw _privateConstructorUsedError;
  double get score => throw _privateConstructorUsedError;
  bool get completed => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Progress to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Progress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProgressCopyWith<Progress> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProgressCopyWith<$Res> {
  factory $ProgressCopyWith(Progress value, $Res Function(Progress) then) =
      _$ProgressCopyWithImpl<$Res, Progress>;
  @useResult
  $Res call(
      {int id,
      int userId,
      int lessonId,
      double score,
      bool completed,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$ProgressCopyWithImpl<$Res, $Val extends Progress>
    implements $ProgressCopyWith<$Res> {
  _$ProgressCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Progress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? lessonId = null,
    Object? score = null,
    Object? completed = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      lessonId: null == lessonId
          ? _value.lessonId
          : lessonId // ignore: cast_nullable_to_non_nullable
              as int,
      score: null == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as double,
      completed: null == completed
          ? _value.completed
          : completed // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProgressImplCopyWith<$Res>
    implements $ProgressCopyWith<$Res> {
  factory _$$ProgressImplCopyWith(
          _$ProgressImpl value, $Res Function(_$ProgressImpl) then) =
      __$$ProgressImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      int userId,
      int lessonId,
      double score,
      bool completed,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$ProgressImplCopyWithImpl<$Res>
    extends _$ProgressCopyWithImpl<$Res, _$ProgressImpl>
    implements _$$ProgressImplCopyWith<$Res> {
  __$$ProgressImplCopyWithImpl(
      _$ProgressImpl _value, $Res Function(_$ProgressImpl) _then)
      : super(_value, _then);

  /// Create a copy of Progress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? lessonId = null,
    Object? score = null,
    Object? completed = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_$ProgressImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      lessonId: null == lessonId
          ? _value.lessonId
          : lessonId // ignore: cast_nullable_to_non_nullable
              as int,
      score: null == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as double,
      completed: null == completed
          ? _value.completed
          : completed // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProgressImpl implements _Progress {
  const _$ProgressImpl(
      {required this.id,
      required this.userId,
      required this.lessonId,
      required this.score,
      this.completed = false,
      required this.createdAt,
      this.updatedAt});

  factory _$ProgressImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProgressImplFromJson(json);

  @override
  final int id;
  @override
  final int userId;
  @override
  final int lessonId;
  @override
  final double score;
  @override
  @JsonKey()
  final bool completed;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Progress(id: $id, userId: $userId, lessonId: $lessonId, score: $score, completed: $completed, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProgressImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.lessonId, lessonId) ||
                other.lessonId == lessonId) &&
            (identical(other.score, score) || other.score == score) &&
            (identical(other.completed, completed) ||
                other.completed == completed) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, userId, lessonId, score,
      completed, createdAt, updatedAt);

  /// Create a copy of Progress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProgressImplCopyWith<_$ProgressImpl> get copyWith =>
      __$$ProgressImplCopyWithImpl<_$ProgressImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProgressImplToJson(
      this,
    );
  }
}

abstract class _Progress implements Progress {
  const factory _Progress(
      {required final int id,
      required final int userId,
      required final int lessonId,
      required final double score,
      final bool completed,
      required final DateTime createdAt,
      final DateTime? updatedAt}) = _$ProgressImpl;

  factory _Progress.fromJson(Map<String, dynamic> json) =
      _$ProgressImpl.fromJson;

  @override
  int get id;
  @override
  int get userId;
  @override
  int get lessonId;
  @override
  double get score;
  @override
  bool get completed;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of Progress
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProgressImplCopyWith<_$ProgressImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProgressCreate _$ProgressCreateFromJson(Map<String, dynamic> json) {
  return _ProgressCreate.fromJson(json);
}

/// @nodoc
mixin _$ProgressCreate {
  int get lessonId => throw _privateConstructorUsedError;
  double get score => throw _privateConstructorUsedError;
  bool get completed => throw _privateConstructorUsedError;

  /// Serializes this ProgressCreate to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProgressCreate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProgressCreateCopyWith<ProgressCreate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProgressCreateCopyWith<$Res> {
  factory $ProgressCreateCopyWith(
          ProgressCreate value, $Res Function(ProgressCreate) then) =
      _$ProgressCreateCopyWithImpl<$Res, ProgressCreate>;
  @useResult
  $Res call({int lessonId, double score, bool completed});
}

/// @nodoc
class _$ProgressCreateCopyWithImpl<$Res, $Val extends ProgressCreate>
    implements $ProgressCreateCopyWith<$Res> {
  _$ProgressCreateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProgressCreate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lessonId = null,
    Object? score = null,
    Object? completed = null,
  }) {
    return _then(_value.copyWith(
      lessonId: null == lessonId
          ? _value.lessonId
          : lessonId // ignore: cast_nullable_to_non_nullable
              as int,
      score: null == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as double,
      completed: null == completed
          ? _value.completed
          : completed // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProgressCreateImplCopyWith<$Res>
    implements $ProgressCreateCopyWith<$Res> {
  factory _$$ProgressCreateImplCopyWith(_$ProgressCreateImpl value,
          $Res Function(_$ProgressCreateImpl) then) =
      __$$ProgressCreateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int lessonId, double score, bool completed});
}

/// @nodoc
class __$$ProgressCreateImplCopyWithImpl<$Res>
    extends _$ProgressCreateCopyWithImpl<$Res, _$ProgressCreateImpl>
    implements _$$ProgressCreateImplCopyWith<$Res> {
  __$$ProgressCreateImplCopyWithImpl(
      _$ProgressCreateImpl _value, $Res Function(_$ProgressCreateImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProgressCreate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lessonId = null,
    Object? score = null,
    Object? completed = null,
  }) {
    return _then(_$ProgressCreateImpl(
      lessonId: null == lessonId
          ? _value.lessonId
          : lessonId // ignore: cast_nullable_to_non_nullable
              as int,
      score: null == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as double,
      completed: null == completed
          ? _value.completed
          : completed // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProgressCreateImpl implements _ProgressCreate {
  const _$ProgressCreateImpl(
      {required this.lessonId, required this.score, this.completed = false});

  factory _$ProgressCreateImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProgressCreateImplFromJson(json);

  @override
  final int lessonId;
  @override
  final double score;
  @override
  @JsonKey()
  final bool completed;

  @override
  String toString() {
    return 'ProgressCreate(lessonId: $lessonId, score: $score, completed: $completed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProgressCreateImpl &&
            (identical(other.lessonId, lessonId) ||
                other.lessonId == lessonId) &&
            (identical(other.score, score) || other.score == score) &&
            (identical(other.completed, completed) ||
                other.completed == completed));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, lessonId, score, completed);

  /// Create a copy of ProgressCreate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProgressCreateImplCopyWith<_$ProgressCreateImpl> get copyWith =>
      __$$ProgressCreateImplCopyWithImpl<_$ProgressCreateImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProgressCreateImplToJson(
      this,
    );
  }
}

abstract class _ProgressCreate implements ProgressCreate {
  const factory _ProgressCreate(
      {required final int lessonId,
      required final double score,
      final bool completed}) = _$ProgressCreateImpl;

  factory _ProgressCreate.fromJson(Map<String, dynamic> json) =
      _$ProgressCreateImpl.fromJson;

  @override
  int get lessonId;
  @override
  double get score;
  @override
  bool get completed;

  /// Create a copy of ProgressCreate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProgressCreateImplCopyWith<_$ProgressCreateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Evaluation _$EvaluationFromJson(Map<String, dynamic> json) {
  return _Evaluation.fromJson(json);
}

/// @nodoc
mixin _$Evaluation {
  double get score => throw _privateConstructorUsedError;
  bool get isCorrect => throw _privateConstructorUsedError;
  String get feedback => throw _privateConstructorUsedError;
  List<String> get corrections => throw _privateConstructorUsedError;

  /// Serializes this Evaluation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Evaluation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EvaluationCopyWith<Evaluation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EvaluationCopyWith<$Res> {
  factory $EvaluationCopyWith(
          Evaluation value, $Res Function(Evaluation) then) =
      _$EvaluationCopyWithImpl<$Res, Evaluation>;
  @useResult
  $Res call(
      {double score,
      bool isCorrect,
      String feedback,
      List<String> corrections});
}

/// @nodoc
class _$EvaluationCopyWithImpl<$Res, $Val extends Evaluation>
    implements $EvaluationCopyWith<$Res> {
  _$EvaluationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Evaluation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? score = null,
    Object? isCorrect = null,
    Object? feedback = null,
    Object? corrections = null,
  }) {
    return _then(_value.copyWith(
      score: null == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as double,
      isCorrect: null == isCorrect
          ? _value.isCorrect
          : isCorrect // ignore: cast_nullable_to_non_nullable
              as bool,
      feedback: null == feedback
          ? _value.feedback
          : feedback // ignore: cast_nullable_to_non_nullable
              as String,
      corrections: null == corrections
          ? _value.corrections
          : corrections // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EvaluationImplCopyWith<$Res>
    implements $EvaluationCopyWith<$Res> {
  factory _$$EvaluationImplCopyWith(
          _$EvaluationImpl value, $Res Function(_$EvaluationImpl) then) =
      __$$EvaluationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double score,
      bool isCorrect,
      String feedback,
      List<String> corrections});
}

/// @nodoc
class __$$EvaluationImplCopyWithImpl<$Res>
    extends _$EvaluationCopyWithImpl<$Res, _$EvaluationImpl>
    implements _$$EvaluationImplCopyWith<$Res> {
  __$$EvaluationImplCopyWithImpl(
      _$EvaluationImpl _value, $Res Function(_$EvaluationImpl) _then)
      : super(_value, _then);

  /// Create a copy of Evaluation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? score = null,
    Object? isCorrect = null,
    Object? feedback = null,
    Object? corrections = null,
  }) {
    return _then(_$EvaluationImpl(
      score: null == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as double,
      isCorrect: null == isCorrect
          ? _value.isCorrect
          : isCorrect // ignore: cast_nullable_to_non_nullable
              as bool,
      feedback: null == feedback
          ? _value.feedback
          : feedback // ignore: cast_nullable_to_non_nullable
              as String,
      corrections: null == corrections
          ? _value._corrections
          : corrections // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EvaluationImpl implements _Evaluation {
  const _$EvaluationImpl(
      {required this.score,
      required this.isCorrect,
      required this.feedback,
      required final List<String> corrections})
      : _corrections = corrections;

  factory _$EvaluationImpl.fromJson(Map<String, dynamic> json) =>
      _$$EvaluationImplFromJson(json);

  @override
  final double score;
  @override
  final bool isCorrect;
  @override
  final String feedback;
  final List<String> _corrections;
  @override
  List<String> get corrections {
    if (_corrections is EqualUnmodifiableListView) return _corrections;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_corrections);
  }

  @override
  String toString() {
    return 'Evaluation(score: $score, isCorrect: $isCorrect, feedback: $feedback, corrections: $corrections)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EvaluationImpl &&
            (identical(other.score, score) || other.score == score) &&
            (identical(other.isCorrect, isCorrect) ||
                other.isCorrect == isCorrect) &&
            (identical(other.feedback, feedback) ||
                other.feedback == feedback) &&
            const DeepCollectionEquality()
                .equals(other._corrections, _corrections));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, score, isCorrect, feedback,
      const DeepCollectionEquality().hash(_corrections));

  /// Create a copy of Evaluation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EvaluationImplCopyWith<_$EvaluationImpl> get copyWith =>
      __$$EvaluationImplCopyWithImpl<_$EvaluationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EvaluationImplToJson(
      this,
    );
  }
}

abstract class _Evaluation implements Evaluation {
  const factory _Evaluation(
      {required final double score,
      required final bool isCorrect,
      required final String feedback,
      required final List<String> corrections}) = _$EvaluationImpl;

  factory _Evaluation.fromJson(Map<String, dynamic> json) =
      _$EvaluationImpl.fromJson;

  @override
  double get score;
  @override
  bool get isCorrect;
  @override
  String get feedback;
  @override
  List<String> get corrections;

  /// Create a copy of Evaluation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EvaluationImplCopyWith<_$EvaluationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
