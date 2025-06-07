// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lesson.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Lesson _$LessonFromJson(Map<String, dynamic> json) {
  return _Lesson.fromJson(json);
}

/// @nodoc
mixin _$Lesson {
  int get id => throw _privateConstructorUsedError;
  int get userId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  LanguageLevel get level => throw _privateConstructorUsedError;
  Language get language => throw _privateConstructorUsedError;
  LessonType get type => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  bool get isCompleted => throw _privateConstructorUsedError;
  int get score => throw _privateConstructorUsedError;

  /// Serializes this Lesson to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Lesson
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LessonCopyWith<Lesson> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LessonCopyWith<$Res> {
  factory $LessonCopyWith(Lesson value, $Res Function(Lesson) then) =
      _$LessonCopyWithImpl<$Res, Lesson>;
  @useResult
  $Res call(
      {int id,
      int userId,
      String title,
      String content,
      LanguageLevel level,
      Language language,
      LessonType type,
      DateTime createdAt,
      DateTime? updatedAt,
      bool isCompleted,
      int score});

  $LanguageCopyWith<$Res> get language;
}

/// @nodoc
class _$LessonCopyWithImpl<$Res, $Val extends Lesson>
    implements $LessonCopyWith<$Res> {
  _$LessonCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Lesson
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? title = null,
    Object? content = null,
    Object? level = null,
    Object? language = null,
    Object? type = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? isCompleted = null,
    Object? score = null,
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
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as LanguageLevel,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as Language,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as LessonType,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      score: null == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }

  /// Create a copy of Lesson
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
abstract class _$$LessonImplCopyWith<$Res> implements $LessonCopyWith<$Res> {
  factory _$$LessonImplCopyWith(
          _$LessonImpl value, $Res Function(_$LessonImpl) then) =
      __$$LessonImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      int userId,
      String title,
      String content,
      LanguageLevel level,
      Language language,
      LessonType type,
      DateTime createdAt,
      DateTime? updatedAt,
      bool isCompleted,
      int score});

  @override
  $LanguageCopyWith<$Res> get language;
}

/// @nodoc
class __$$LessonImplCopyWithImpl<$Res>
    extends _$LessonCopyWithImpl<$Res, _$LessonImpl>
    implements _$$LessonImplCopyWith<$Res> {
  __$$LessonImplCopyWithImpl(
      _$LessonImpl _value, $Res Function(_$LessonImpl) _then)
      : super(_value, _then);

  /// Create a copy of Lesson
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? title = null,
    Object? content = null,
    Object? level = null,
    Object? language = null,
    Object? type = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? isCompleted = null,
    Object? score = null,
  }) {
    return _then(_$LessonImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as LanguageLevel,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as Language,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as LessonType,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      score: null == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LessonImpl implements _Lesson {
  const _$LessonImpl(
      {required this.id,
      required this.userId,
      required this.title,
      required this.content,
      required this.level,
      required this.language,
      required this.type,
      required this.createdAt,
      this.updatedAt,
      this.isCompleted = false,
      this.score = 0});

  factory _$LessonImpl.fromJson(Map<String, dynamic> json) =>
      _$$LessonImplFromJson(json);

  @override
  final int id;
  @override
  final int userId;
  @override
  final String title;
  @override
  final String content;
  @override
  final LanguageLevel level;
  @override
  final Language language;
  @override
  final LessonType type;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;
  @override
  @JsonKey()
  final bool isCompleted;
  @override
  @JsonKey()
  final int score;

  @override
  String toString() {
    return 'Lesson(id: $id, userId: $userId, title: $title, content: $content, level: $level, language: $language, type: $type, createdAt: $createdAt, updatedAt: $updatedAt, isCompleted: $isCompleted, score: $score)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LessonImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            (identical(other.score, score) || other.score == score));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, userId, title, content,
      level, language, type, createdAt, updatedAt, isCompleted, score);

  /// Create a copy of Lesson
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LessonImplCopyWith<_$LessonImpl> get copyWith =>
      __$$LessonImplCopyWithImpl<_$LessonImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LessonImplToJson(
      this,
    );
  }
}

abstract class _Lesson implements Lesson {
  const factory _Lesson(
      {required final int id,
      required final int userId,
      required final String title,
      required final String content,
      required final LanguageLevel level,
      required final Language language,
      required final LessonType type,
      required final DateTime createdAt,
      final DateTime? updatedAt,
      final bool isCompleted,
      final int score}) = _$LessonImpl;

  factory _Lesson.fromJson(Map<String, dynamic> json) = _$LessonImpl.fromJson;

  @override
  int get id;
  @override
  int get userId;
  @override
  String get title;
  @override
  String get content;
  @override
  LanguageLevel get level;
  @override
  Language get language;
  @override
  LessonType get type;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  bool get isCompleted;
  @override
  int get score;

  /// Create a copy of Lesson
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LessonImplCopyWith<_$LessonImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LessonContent _$LessonContentFromJson(Map<String, dynamic> json) {
  return _LessonContent.fromJson(json);
}

/// @nodoc
mixin _$LessonContent {
  String get title => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  String get language => throw _privateConstructorUsedError;
  List<Vocabulary> get vocabulary => throw _privateConstructorUsedError;
  List<Grammar> get grammar => throw _privateConstructorUsedError;
  List<Question> get questions => throw _privateConstructorUsedError;

  /// Serializes this LessonContent to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LessonContent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LessonContentCopyWith<LessonContent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LessonContentCopyWith<$Res> {
  factory $LessonContentCopyWith(
          LessonContent value, $Res Function(LessonContent) then) =
      _$LessonContentCopyWithImpl<$Res, LessonContent>;
  @useResult
  $Res call(
      {String title,
      String content,
      String language,
      List<Vocabulary> vocabulary,
      List<Grammar> grammar,
      List<Question> questions});
}

/// @nodoc
class _$LessonContentCopyWithImpl<$Res, $Val extends LessonContent>
    implements $LessonContentCopyWith<$Res> {
  _$LessonContentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LessonContent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? content = null,
    Object? language = null,
    Object? vocabulary = null,
    Object? grammar = null,
    Object? questions = null,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      vocabulary: null == vocabulary
          ? _value.vocabulary
          : vocabulary // ignore: cast_nullable_to_non_nullable
              as List<Vocabulary>,
      grammar: null == grammar
          ? _value.grammar
          : grammar // ignore: cast_nullable_to_non_nullable
              as List<Grammar>,
      questions: null == questions
          ? _value.questions
          : questions // ignore: cast_nullable_to_non_nullable
              as List<Question>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LessonContentImplCopyWith<$Res>
    implements $LessonContentCopyWith<$Res> {
  factory _$$LessonContentImplCopyWith(
          _$LessonContentImpl value, $Res Function(_$LessonContentImpl) then) =
      __$$LessonContentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String title,
      String content,
      String language,
      List<Vocabulary> vocabulary,
      List<Grammar> grammar,
      List<Question> questions});
}

/// @nodoc
class __$$LessonContentImplCopyWithImpl<$Res>
    extends _$LessonContentCopyWithImpl<$Res, _$LessonContentImpl>
    implements _$$LessonContentImplCopyWith<$Res> {
  __$$LessonContentImplCopyWithImpl(
      _$LessonContentImpl _value, $Res Function(_$LessonContentImpl) _then)
      : super(_value, _then);

  /// Create a copy of LessonContent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? content = null,
    Object? language = null,
    Object? vocabulary = null,
    Object? grammar = null,
    Object? questions = null,
  }) {
    return _then(_$LessonContentImpl(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      vocabulary: null == vocabulary
          ? _value._vocabulary
          : vocabulary // ignore: cast_nullable_to_non_nullable
              as List<Vocabulary>,
      grammar: null == grammar
          ? _value._grammar
          : grammar // ignore: cast_nullable_to_non_nullable
              as List<Grammar>,
      questions: null == questions
          ? _value._questions
          : questions // ignore: cast_nullable_to_non_nullable
              as List<Question>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LessonContentImpl implements _LessonContent {
  const _$LessonContentImpl(
      {required this.title,
      required this.content,
      required this.language,
      required final List<Vocabulary> vocabulary,
      required final List<Grammar> grammar,
      required final List<Question> questions})
      : _vocabulary = vocabulary,
        _grammar = grammar,
        _questions = questions;

  factory _$LessonContentImpl.fromJson(Map<String, dynamic> json) =>
      _$$LessonContentImplFromJson(json);

  @override
  final String title;
  @override
  final String content;
  @override
  final String language;
  final List<Vocabulary> _vocabulary;
  @override
  List<Vocabulary> get vocabulary {
    if (_vocabulary is EqualUnmodifiableListView) return _vocabulary;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_vocabulary);
  }

  final List<Grammar> _grammar;
  @override
  List<Grammar> get grammar {
    if (_grammar is EqualUnmodifiableListView) return _grammar;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_grammar);
  }

  final List<Question> _questions;
  @override
  List<Question> get questions {
    if (_questions is EqualUnmodifiableListView) return _questions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_questions);
  }

  @override
  String toString() {
    return 'LessonContent(title: $title, content: $content, language: $language, vocabulary: $vocabulary, grammar: $grammar, questions: $questions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LessonContentImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.language, language) ||
                other.language == language) &&
            const DeepCollectionEquality()
                .equals(other._vocabulary, _vocabulary) &&
            const DeepCollectionEquality().equals(other._grammar, _grammar) &&
            const DeepCollectionEquality()
                .equals(other._questions, _questions));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      title,
      content,
      language,
      const DeepCollectionEquality().hash(_vocabulary),
      const DeepCollectionEquality().hash(_grammar),
      const DeepCollectionEquality().hash(_questions));

  /// Create a copy of LessonContent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LessonContentImplCopyWith<_$LessonContentImpl> get copyWith =>
      __$$LessonContentImplCopyWithImpl<_$LessonContentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LessonContentImplToJson(
      this,
    );
  }
}

abstract class _LessonContent implements LessonContent {
  const factory _LessonContent(
      {required final String title,
      required final String content,
      required final String language,
      required final List<Vocabulary> vocabulary,
      required final List<Grammar> grammar,
      required final List<Question> questions}) = _$LessonContentImpl;

  factory _LessonContent.fromJson(Map<String, dynamic> json) =
      _$LessonContentImpl.fromJson;

  @override
  String get title;
  @override
  String get content;
  @override
  String get language;
  @override
  List<Vocabulary> get vocabulary;
  @override
  List<Grammar> get grammar;
  @override
  List<Question> get questions;

  /// Create a copy of LessonContent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LessonContentImplCopyWith<_$LessonContentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Vocabulary _$VocabularyFromJson(Map<String, dynamic> json) {
  return _Vocabulary.fromJson(json);
}

/// @nodoc
mixin _$Vocabulary {
  String get word => throw _privateConstructorUsedError;
  String get translation => throw _privateConstructorUsedError;
  String get example => throw _privateConstructorUsedError;

  /// Serializes this Vocabulary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Vocabulary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VocabularyCopyWith<Vocabulary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VocabularyCopyWith<$Res> {
  factory $VocabularyCopyWith(
          Vocabulary value, $Res Function(Vocabulary) then) =
      _$VocabularyCopyWithImpl<$Res, Vocabulary>;
  @useResult
  $Res call({String word, String translation, String example});
}

/// @nodoc
class _$VocabularyCopyWithImpl<$Res, $Val extends Vocabulary>
    implements $VocabularyCopyWith<$Res> {
  _$VocabularyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Vocabulary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? word = null,
    Object? translation = null,
    Object? example = null,
  }) {
    return _then(_value.copyWith(
      word: null == word
          ? _value.word
          : word // ignore: cast_nullable_to_non_nullable
              as String,
      translation: null == translation
          ? _value.translation
          : translation // ignore: cast_nullable_to_non_nullable
              as String,
      example: null == example
          ? _value.example
          : example // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VocabularyImplCopyWith<$Res>
    implements $VocabularyCopyWith<$Res> {
  factory _$$VocabularyImplCopyWith(
          _$VocabularyImpl value, $Res Function(_$VocabularyImpl) then) =
      __$$VocabularyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String word, String translation, String example});
}

/// @nodoc
class __$$VocabularyImplCopyWithImpl<$Res>
    extends _$VocabularyCopyWithImpl<$Res, _$VocabularyImpl>
    implements _$$VocabularyImplCopyWith<$Res> {
  __$$VocabularyImplCopyWithImpl(
      _$VocabularyImpl _value, $Res Function(_$VocabularyImpl) _then)
      : super(_value, _then);

  /// Create a copy of Vocabulary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? word = null,
    Object? translation = null,
    Object? example = null,
  }) {
    return _then(_$VocabularyImpl(
      word: null == word
          ? _value.word
          : word // ignore: cast_nullable_to_non_nullable
              as String,
      translation: null == translation
          ? _value.translation
          : translation // ignore: cast_nullable_to_non_nullable
              as String,
      example: null == example
          ? _value.example
          : example // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VocabularyImpl implements _Vocabulary {
  const _$VocabularyImpl(
      {required this.word, required this.translation, required this.example});

  factory _$VocabularyImpl.fromJson(Map<String, dynamic> json) =>
      _$$VocabularyImplFromJson(json);

  @override
  final String word;
  @override
  final String translation;
  @override
  final String example;

  @override
  String toString() {
    return 'Vocabulary(word: $word, translation: $translation, example: $example)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VocabularyImpl &&
            (identical(other.word, word) || other.word == word) &&
            (identical(other.translation, translation) ||
                other.translation == translation) &&
            (identical(other.example, example) || other.example == example));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, word, translation, example);

  /// Create a copy of Vocabulary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VocabularyImplCopyWith<_$VocabularyImpl> get copyWith =>
      __$$VocabularyImplCopyWithImpl<_$VocabularyImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VocabularyImplToJson(
      this,
    );
  }
}

abstract class _Vocabulary implements Vocabulary {
  const factory _Vocabulary(
      {required final String word,
      required final String translation,
      required final String example}) = _$VocabularyImpl;

  factory _Vocabulary.fromJson(Map<String, dynamic> json) =
      _$VocabularyImpl.fromJson;

  @override
  String get word;
  @override
  String get translation;
  @override
  String get example;

  /// Create a copy of Vocabulary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VocabularyImplCopyWith<_$VocabularyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Grammar _$GrammarFromJson(Map<String, dynamic> json) {
  return _Grammar.fromJson(json);
}

/// @nodoc
mixin _$Grammar {
  String get point => throw _privateConstructorUsedError;
  String get explanation => throw _privateConstructorUsedError;
  String get example => throw _privateConstructorUsedError;

  /// Serializes this Grammar to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Grammar
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GrammarCopyWith<Grammar> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GrammarCopyWith<$Res> {
  factory $GrammarCopyWith(Grammar value, $Res Function(Grammar) then) =
      _$GrammarCopyWithImpl<$Res, Grammar>;
  @useResult
  $Res call({String point, String explanation, String example});
}

/// @nodoc
class _$GrammarCopyWithImpl<$Res, $Val extends Grammar>
    implements $GrammarCopyWith<$Res> {
  _$GrammarCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Grammar
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? point = null,
    Object? explanation = null,
    Object? example = null,
  }) {
    return _then(_value.copyWith(
      point: null == point
          ? _value.point
          : point // ignore: cast_nullable_to_non_nullable
              as String,
      explanation: null == explanation
          ? _value.explanation
          : explanation // ignore: cast_nullable_to_non_nullable
              as String,
      example: null == example
          ? _value.example
          : example // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GrammarImplCopyWith<$Res> implements $GrammarCopyWith<$Res> {
  factory _$$GrammarImplCopyWith(
          _$GrammarImpl value, $Res Function(_$GrammarImpl) then) =
      __$$GrammarImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String point, String explanation, String example});
}

/// @nodoc
class __$$GrammarImplCopyWithImpl<$Res>
    extends _$GrammarCopyWithImpl<$Res, _$GrammarImpl>
    implements _$$GrammarImplCopyWith<$Res> {
  __$$GrammarImplCopyWithImpl(
      _$GrammarImpl _value, $Res Function(_$GrammarImpl) _then)
      : super(_value, _then);

  /// Create a copy of Grammar
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? point = null,
    Object? explanation = null,
    Object? example = null,
  }) {
    return _then(_$GrammarImpl(
      point: null == point
          ? _value.point
          : point // ignore: cast_nullable_to_non_nullable
              as String,
      explanation: null == explanation
          ? _value.explanation
          : explanation // ignore: cast_nullable_to_non_nullable
              as String,
      example: null == example
          ? _value.example
          : example // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GrammarImpl implements _Grammar {
  const _$GrammarImpl(
      {required this.point, required this.explanation, required this.example});

  factory _$GrammarImpl.fromJson(Map<String, dynamic> json) =>
      _$$GrammarImplFromJson(json);

  @override
  final String point;
  @override
  final String explanation;
  @override
  final String example;

  @override
  String toString() {
    return 'Grammar(point: $point, explanation: $explanation, example: $example)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GrammarImpl &&
            (identical(other.point, point) || other.point == point) &&
            (identical(other.explanation, explanation) ||
                other.explanation == explanation) &&
            (identical(other.example, example) || other.example == example));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, point, explanation, example);

  /// Create a copy of Grammar
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GrammarImplCopyWith<_$GrammarImpl> get copyWith =>
      __$$GrammarImplCopyWithImpl<_$GrammarImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GrammarImplToJson(
      this,
    );
  }
}

abstract class _Grammar implements Grammar {
  const factory _Grammar(
      {required final String point,
      required final String explanation,
      required final String example}) = _$GrammarImpl;

  factory _Grammar.fromJson(Map<String, dynamic> json) = _$GrammarImpl.fromJson;

  @override
  String get point;
  @override
  String get explanation;
  @override
  String get example;

  /// Create a copy of Grammar
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GrammarImplCopyWith<_$GrammarImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Question _$QuestionFromJson(Map<String, dynamic> json) {
  return _Question.fromJson(json);
}

/// @nodoc
mixin _$Question {
  String get question => throw _privateConstructorUsedError;
  String get correctAnswer => throw _privateConstructorUsedError;
  List<String> get options => throw _privateConstructorUsedError;

  /// Serializes this Question to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Question
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuestionCopyWith<Question> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuestionCopyWith<$Res> {
  factory $QuestionCopyWith(Question value, $Res Function(Question) then) =
      _$QuestionCopyWithImpl<$Res, Question>;
  @useResult
  $Res call({String question, String correctAnswer, List<String> options});
}

/// @nodoc
class _$QuestionCopyWithImpl<$Res, $Val extends Question>
    implements $QuestionCopyWith<$Res> {
  _$QuestionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Question
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? question = null,
    Object? correctAnswer = null,
    Object? options = null,
  }) {
    return _then(_value.copyWith(
      question: null == question
          ? _value.question
          : question // ignore: cast_nullable_to_non_nullable
              as String,
      correctAnswer: null == correctAnswer
          ? _value.correctAnswer
          : correctAnswer // ignore: cast_nullable_to_non_nullable
              as String,
      options: null == options
          ? _value.options
          : options // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QuestionImplCopyWith<$Res>
    implements $QuestionCopyWith<$Res> {
  factory _$$QuestionImplCopyWith(
          _$QuestionImpl value, $Res Function(_$QuestionImpl) then) =
      __$$QuestionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String question, String correctAnswer, List<String> options});
}

/// @nodoc
class __$$QuestionImplCopyWithImpl<$Res>
    extends _$QuestionCopyWithImpl<$Res, _$QuestionImpl>
    implements _$$QuestionImplCopyWith<$Res> {
  __$$QuestionImplCopyWithImpl(
      _$QuestionImpl _value, $Res Function(_$QuestionImpl) _then)
      : super(_value, _then);

  /// Create a copy of Question
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? question = null,
    Object? correctAnswer = null,
    Object? options = null,
  }) {
    return _then(_$QuestionImpl(
      question: null == question
          ? _value.question
          : question // ignore: cast_nullable_to_non_nullable
              as String,
      correctAnswer: null == correctAnswer
          ? _value.correctAnswer
          : correctAnswer // ignore: cast_nullable_to_non_nullable
              as String,
      options: null == options
          ? _value._options
          : options // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QuestionImpl implements _Question {
  const _$QuestionImpl(
      {required this.question,
      required this.correctAnswer,
      required final List<String> options})
      : _options = options;

  factory _$QuestionImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuestionImplFromJson(json);

  @override
  final String question;
  @override
  final String correctAnswer;
  final List<String> _options;
  @override
  List<String> get options {
    if (_options is EqualUnmodifiableListView) return _options;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_options);
  }

  @override
  String toString() {
    return 'Question(question: $question, correctAnswer: $correctAnswer, options: $options)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuestionImpl &&
            (identical(other.question, question) ||
                other.question == question) &&
            (identical(other.correctAnswer, correctAnswer) ||
                other.correctAnswer == correctAnswer) &&
            const DeepCollectionEquality().equals(other._options, _options));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, question, correctAnswer,
      const DeepCollectionEquality().hash(_options));

  /// Create a copy of Question
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuestionImplCopyWith<_$QuestionImpl> get copyWith =>
      __$$QuestionImplCopyWithImpl<_$QuestionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuestionImplToJson(
      this,
    );
  }
}

abstract class _Question implements Question {
  const factory _Question(
      {required final String question,
      required final String correctAnswer,
      required final List<String> options}) = _$QuestionImpl;

  factory _Question.fromJson(Map<String, dynamic> json) =
      _$QuestionImpl.fromJson;

  @override
  String get question;
  @override
  String get correctAnswer;
  @override
  List<String> get options;

  /// Create a copy of Question
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuestionImplCopyWith<_$QuestionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
