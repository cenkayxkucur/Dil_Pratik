// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'error_review.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ErrorReview _$ErrorReviewFromJson(Map<String, dynamic> json) {
  return _ErrorReview.fromJson(json);
}

/// @nodoc
mixin _$ErrorReview {
  int get id => throw _privateConstructorUsedError;
  String get question => throw _privateConstructorUsedError;
  String get userAnswer => throw _privateConstructorUsedError;
  String get correctAnswer => throw _privateConstructorUsedError;
  String get explanation => throw _privateConstructorUsedError;
  String get grammarRule => throw _privateConstructorUsedError;
  Language get language => throw _privateConstructorUsedError;
  LanguageLevel get level => throw _privateConstructorUsedError;
  ErrorType get errorType => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  bool get isReviewed => throw _privateConstructorUsedError;

  /// Serializes this ErrorReview to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ErrorReview
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ErrorReviewCopyWith<ErrorReview> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ErrorReviewCopyWith<$Res> {
  factory $ErrorReviewCopyWith(
          ErrorReview value, $Res Function(ErrorReview) then) =
      _$ErrorReviewCopyWithImpl<$Res, ErrorReview>;
  @useResult
  $Res call(
      {int id,
      String question,
      String userAnswer,
      String correctAnswer,
      String explanation,
      String grammarRule,
      Language language,
      LanguageLevel level,
      ErrorType errorType,
      DateTime createdAt,
      bool isReviewed});

  $LanguageCopyWith<$Res> get language;
}

/// @nodoc
class _$ErrorReviewCopyWithImpl<$Res, $Val extends ErrorReview>
    implements $ErrorReviewCopyWith<$Res> {
  _$ErrorReviewCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ErrorReview
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? question = null,
    Object? userAnswer = null,
    Object? correctAnswer = null,
    Object? explanation = null,
    Object? grammarRule = null,
    Object? language = null,
    Object? level = null,
    Object? errorType = null,
    Object? createdAt = null,
    Object? isReviewed = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      question: null == question
          ? _value.question
          : question // ignore: cast_nullable_to_non_nullable
              as String,
      userAnswer: null == userAnswer
          ? _value.userAnswer
          : userAnswer // ignore: cast_nullable_to_non_nullable
              as String,
      correctAnswer: null == correctAnswer
          ? _value.correctAnswer
          : correctAnswer // ignore: cast_nullable_to_non_nullable
              as String,
      explanation: null == explanation
          ? _value.explanation
          : explanation // ignore: cast_nullable_to_non_nullable
              as String,
      grammarRule: null == grammarRule
          ? _value.grammarRule
          : grammarRule // ignore: cast_nullable_to_non_nullable
              as String,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as Language,
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as LanguageLevel,
      errorType: null == errorType
          ? _value.errorType
          : errorType // ignore: cast_nullable_to_non_nullable
              as ErrorType,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isReviewed: null == isReviewed
          ? _value.isReviewed
          : isReviewed // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  /// Create a copy of ErrorReview
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LanguageCopyWith<$Res> get language {
    return $LanguageCopyWith<$Res>(_value.language, (value) {
      return _then(_value.copyWith(language: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ErrorReviewImplCopyWith<$Res>
    implements $ErrorReviewCopyWith<$Res> {
  factory _$$ErrorReviewImplCopyWith(
          _$ErrorReviewImpl value, $Res Function(_$ErrorReviewImpl) then) =
      __$$ErrorReviewImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String question,
      String userAnswer,
      String correctAnswer,
      String explanation,
      String grammarRule,
      Language language,
      LanguageLevel level,
      ErrorType errorType,
      DateTime createdAt,
      bool isReviewed});

  @override
  $LanguageCopyWith<$Res> get language;
}

/// @nodoc
class __$$ErrorReviewImplCopyWithImpl<$Res>
    extends _$ErrorReviewCopyWithImpl<$Res, _$ErrorReviewImpl>
    implements _$$ErrorReviewImplCopyWith<$Res> {
  __$$ErrorReviewImplCopyWithImpl(
      _$ErrorReviewImpl _value, $Res Function(_$ErrorReviewImpl) _then)
      : super(_value, _then);

  /// Create a copy of ErrorReview
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? question = null,
    Object? userAnswer = null,
    Object? correctAnswer = null,
    Object? explanation = null,
    Object? grammarRule = null,
    Object? language = null,
    Object? level = null,
    Object? errorType = null,
    Object? createdAt = null,
    Object? isReviewed = null,
  }) {
    return _then(_$ErrorReviewImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      question: null == question
          ? _value.question
          : question // ignore: cast_nullable_to_non_nullable
              as String,
      userAnswer: null == userAnswer
          ? _value.userAnswer
          : userAnswer // ignore: cast_nullable_to_non_nullable
              as String,
      correctAnswer: null == correctAnswer
          ? _value.correctAnswer
          : correctAnswer // ignore: cast_nullable_to_non_nullable
              as String,
      explanation: null == explanation
          ? _value.explanation
          : explanation // ignore: cast_nullable_to_non_nullable
              as String,
      grammarRule: null == grammarRule
          ? _value.grammarRule
          : grammarRule // ignore: cast_nullable_to_non_nullable
              as String,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as Language,
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as LanguageLevel,
      errorType: null == errorType
          ? _value.errorType
          : errorType // ignore: cast_nullable_to_non_nullable
              as ErrorType,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isReviewed: null == isReviewed
          ? _value.isReviewed
          : isReviewed // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ErrorReviewImpl implements _ErrorReview {
  const _$ErrorReviewImpl(
      {required this.id,
      required this.question,
      required this.userAnswer,
      required this.correctAnswer,
      required this.explanation,
      required this.grammarRule,
      required this.language,
      required this.level,
      required this.errorType,
      required this.createdAt,
      this.isReviewed = false});

  factory _$ErrorReviewImpl.fromJson(Map<String, dynamic> json) =>
      _$$ErrorReviewImplFromJson(json);

  @override
  final int id;
  @override
  final String question;
  @override
  final String userAnswer;
  @override
  final String correctAnswer;
  @override
  final String explanation;
  @override
  final String grammarRule;
  @override
  final Language language;
  @override
  final LanguageLevel level;
  @override
  final ErrorType errorType;
  @override
  final DateTime createdAt;
  @override
  @JsonKey()
  final bool isReviewed;

  @override
  String toString() {
    return 'ErrorReview(id: $id, question: $question, userAnswer: $userAnswer, correctAnswer: $correctAnswer, explanation: $explanation, grammarRule: $grammarRule, language: $language, level: $level, errorType: $errorType, createdAt: $createdAt, isReviewed: $isReviewed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ErrorReviewImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.question, question) ||
                other.question == question) &&
            (identical(other.userAnswer, userAnswer) ||
                other.userAnswer == userAnswer) &&
            (identical(other.correctAnswer, correctAnswer) ||
                other.correctAnswer == correctAnswer) &&
            (identical(other.explanation, explanation) ||
                other.explanation == explanation) &&
            (identical(other.grammarRule, grammarRule) ||
                other.grammarRule == grammarRule) &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.errorType, errorType) ||
                other.errorType == errorType) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.isReviewed, isReviewed) ||
                other.isReviewed == isReviewed));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      question,
      userAnswer,
      correctAnswer,
      explanation,
      grammarRule,
      language,
      level,
      errorType,
      createdAt,
      isReviewed);

  /// Create a copy of ErrorReview
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ErrorReviewImplCopyWith<_$ErrorReviewImpl> get copyWith =>
      __$$ErrorReviewImplCopyWithImpl<_$ErrorReviewImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ErrorReviewImplToJson(
      this,
    );
  }
}

abstract class _ErrorReview implements ErrorReview {
  const factory _ErrorReview(
      {required final int id,
      required final String question,
      required final String userAnswer,
      required final String correctAnswer,
      required final String explanation,
      required final String grammarRule,
      required final Language language,
      required final LanguageLevel level,
      required final ErrorType errorType,
      required final DateTime createdAt,
      final bool isReviewed}) = _$ErrorReviewImpl;

  factory _ErrorReview.fromJson(Map<String, dynamic> json) =
      _$ErrorReviewImpl.fromJson;

  @override
  int get id;
  @override
  String get question;
  @override
  String get userAnswer;
  @override
  String get correctAnswer;
  @override
  String get explanation;
  @override
  String get grammarRule;
  @override
  Language get language;
  @override
  LanguageLevel get level;
  @override
  ErrorType get errorType;
  @override
  DateTime get createdAt;
  @override
  bool get isReviewed;

  /// Create a copy of ErrorReview
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ErrorReviewImplCopyWith<_$ErrorReviewImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
