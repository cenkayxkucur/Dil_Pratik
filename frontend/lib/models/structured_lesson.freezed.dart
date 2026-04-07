// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'structured_lesson.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LanguageLevelResponse _$LanguageLevelResponseFromJson(
    Map<String, dynamic> json) {
  return _LanguageLevelResponse.fromJson(json);
}

/// @nodoc
mixin _$LanguageLevelResponse {
  int get id => throw _privateConstructorUsedError;
  String get language => throw _privateConstructorUsedError;
  String get level => throw _privateConstructorUsedError;
  @JsonKey(name: 'display_name')
  String get displayName => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'order_index')
  int get orderIndex => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this LanguageLevelResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LanguageLevelResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LanguageLevelResponseCopyWith<LanguageLevelResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LanguageLevelResponseCopyWith<$Res> {
  factory $LanguageLevelResponseCopyWith(LanguageLevelResponse value,
          $Res Function(LanguageLevelResponse) then) =
      _$LanguageLevelResponseCopyWithImpl<$Res, LanguageLevelResponse>;
  @useResult
  $Res call(
      {int id,
      String language,
      String level,
      @JsonKey(name: 'display_name') String displayName,
      String? description,
      @JsonKey(name: 'order_index') int orderIndex,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'created_at') DateTime createdAt});
}

/// @nodoc
class _$LanguageLevelResponseCopyWithImpl<$Res,
        $Val extends LanguageLevelResponse>
    implements $LanguageLevelResponseCopyWith<$Res> {
  _$LanguageLevelResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LanguageLevelResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? language = null,
    Object? level = null,
    Object? displayName = null,
    Object? description = freezed,
    Object? orderIndex = null,
    Object? isActive = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      orderIndex: null == orderIndex
          ? _value.orderIndex
          : orderIndex // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LanguageLevelResponseImplCopyWith<$Res>
    implements $LanguageLevelResponseCopyWith<$Res> {
  factory _$$LanguageLevelResponseImplCopyWith(
          _$LanguageLevelResponseImpl value,
          $Res Function(_$LanguageLevelResponseImpl) then) =
      __$$LanguageLevelResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String language,
      String level,
      @JsonKey(name: 'display_name') String displayName,
      String? description,
      @JsonKey(name: 'order_index') int orderIndex,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'created_at') DateTime createdAt});
}

/// @nodoc
class __$$LanguageLevelResponseImplCopyWithImpl<$Res>
    extends _$LanguageLevelResponseCopyWithImpl<$Res,
        _$LanguageLevelResponseImpl>
    implements _$$LanguageLevelResponseImplCopyWith<$Res> {
  __$$LanguageLevelResponseImplCopyWithImpl(_$LanguageLevelResponseImpl _value,
      $Res Function(_$LanguageLevelResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of LanguageLevelResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? language = null,
    Object? level = null,
    Object? displayName = null,
    Object? description = freezed,
    Object? orderIndex = null,
    Object? isActive = null,
    Object? createdAt = null,
  }) {
    return _then(_$LanguageLevelResponseImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      orderIndex: null == orderIndex
          ? _value.orderIndex
          : orderIndex // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LanguageLevelResponseImpl implements _LanguageLevelResponse {
  const _$LanguageLevelResponseImpl(
      {required this.id,
      required this.language,
      required this.level,
      @JsonKey(name: 'display_name') required this.displayName,
      this.description,
      @JsonKey(name: 'order_index') this.orderIndex = 0,
      @JsonKey(name: 'is_active') this.isActive = true,
      @JsonKey(name: 'created_at') required this.createdAt});

  factory _$LanguageLevelResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$LanguageLevelResponseImplFromJson(json);

  @override
  final int id;
  @override
  final String language;
  @override
  final String level;
  @override
  @JsonKey(name: 'display_name')
  final String displayName;
  @override
  final String? description;
  @override
  @JsonKey(name: 'order_index')
  final int orderIndex;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @override
  String toString() {
    return 'LanguageLevelResponse(id: $id, language: $language, level: $level, displayName: $displayName, description: $description, orderIndex: $orderIndex, isActive: $isActive, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LanguageLevelResponseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.orderIndex, orderIndex) ||
                other.orderIndex == orderIndex) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, language, level, displayName,
      description, orderIndex, isActive, createdAt);

  /// Create a copy of LanguageLevelResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LanguageLevelResponseImplCopyWith<_$LanguageLevelResponseImpl>
      get copyWith => __$$LanguageLevelResponseImplCopyWithImpl<
          _$LanguageLevelResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LanguageLevelResponseImplToJson(
      this,
    );
  }
}

abstract class _LanguageLevelResponse implements LanguageLevelResponse {
  const factory _LanguageLevelResponse(
          {required final int id,
          required final String language,
          required final String level,
          @JsonKey(name: 'display_name') required final String displayName,
          final String? description,
          @JsonKey(name: 'order_index') final int orderIndex,
          @JsonKey(name: 'is_active') final bool isActive,
          @JsonKey(name: 'created_at') required final DateTime createdAt}) =
      _$LanguageLevelResponseImpl;

  factory _LanguageLevelResponse.fromJson(Map<String, dynamic> json) =
      _$LanguageLevelResponseImpl.fromJson;

  @override
  int get id;
  @override
  String get language;
  @override
  String get level;
  @override
  @JsonKey(name: 'display_name')
  String get displayName;
  @override
  String? get description;
  @override
  @JsonKey(name: 'order_index')
  int get orderIndex;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;

  /// Create a copy of LanguageLevelResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LanguageLevelResponseImplCopyWith<_$LanguageLevelResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

GrammarTopicResponse _$GrammarTopicResponseFromJson(Map<String, dynamic> json) {
  return _GrammarTopicResponse.fromJson(json);
}

/// @nodoc
mixin _$GrammarTopicResponse {
  int get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'language_level_id')
  int get languageLevelId => throw _privateConstructorUsedError;
  @JsonKey(name: 'order_index')
  int get orderIndex => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this GrammarTopicResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GrammarTopicResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GrammarTopicResponseCopyWith<GrammarTopicResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GrammarTopicResponseCopyWith<$Res> {
  factory $GrammarTopicResponseCopyWith(GrammarTopicResponse value,
          $Res Function(GrammarTopicResponse) then) =
      _$GrammarTopicResponseCopyWithImpl<$Res, GrammarTopicResponse>;
  @useResult
  $Res call(
      {int id,
      String title,
      String? description,
      @JsonKey(name: 'language_level_id') int languageLevelId,
      @JsonKey(name: 'order_index') int orderIndex,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'created_at') DateTime createdAt});
}

/// @nodoc
class _$GrammarTopicResponseCopyWithImpl<$Res,
        $Val extends GrammarTopicResponse>
    implements $GrammarTopicResponseCopyWith<$Res> {
  _$GrammarTopicResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GrammarTopicResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? languageLevelId = null,
    Object? orderIndex = null,
    Object? isActive = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      languageLevelId: null == languageLevelId
          ? _value.languageLevelId
          : languageLevelId // ignore: cast_nullable_to_non_nullable
              as int,
      orderIndex: null == orderIndex
          ? _value.orderIndex
          : orderIndex // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GrammarTopicResponseImplCopyWith<$Res>
    implements $GrammarTopicResponseCopyWith<$Res> {
  factory _$$GrammarTopicResponseImplCopyWith(_$GrammarTopicResponseImpl value,
          $Res Function(_$GrammarTopicResponseImpl) then) =
      __$$GrammarTopicResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String title,
      String? description,
      @JsonKey(name: 'language_level_id') int languageLevelId,
      @JsonKey(name: 'order_index') int orderIndex,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'created_at') DateTime createdAt});
}

/// @nodoc
class __$$GrammarTopicResponseImplCopyWithImpl<$Res>
    extends _$GrammarTopicResponseCopyWithImpl<$Res, _$GrammarTopicResponseImpl>
    implements _$$GrammarTopicResponseImplCopyWith<$Res> {
  __$$GrammarTopicResponseImplCopyWithImpl(_$GrammarTopicResponseImpl _value,
      $Res Function(_$GrammarTopicResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of GrammarTopicResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? languageLevelId = null,
    Object? orderIndex = null,
    Object? isActive = null,
    Object? createdAt = null,
  }) {
    return _then(_$GrammarTopicResponseImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      languageLevelId: null == languageLevelId
          ? _value.languageLevelId
          : languageLevelId // ignore: cast_nullable_to_non_nullable
              as int,
      orderIndex: null == orderIndex
          ? _value.orderIndex
          : orderIndex // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GrammarTopicResponseImpl implements _GrammarTopicResponse {
  const _$GrammarTopicResponseImpl(
      {required this.id,
      required this.title,
      this.description,
      @JsonKey(name: 'language_level_id') required this.languageLevelId,
      @JsonKey(name: 'order_index') this.orderIndex = 0,
      @JsonKey(name: 'is_active') this.isActive = true,
      @JsonKey(name: 'created_at') required this.createdAt});

  factory _$GrammarTopicResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$GrammarTopicResponseImplFromJson(json);

  @override
  final int id;
  @override
  final String title;
  @override
  final String? description;
  @override
  @JsonKey(name: 'language_level_id')
  final int languageLevelId;
  @override
  @JsonKey(name: 'order_index')
  final int orderIndex;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @override
  String toString() {
    return 'GrammarTopicResponse(id: $id, title: $title, description: $description, languageLevelId: $languageLevelId, orderIndex: $orderIndex, isActive: $isActive, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GrammarTopicResponseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.languageLevelId, languageLevelId) ||
                other.languageLevelId == languageLevelId) &&
            (identical(other.orderIndex, orderIndex) ||
                other.orderIndex == orderIndex) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, description,
      languageLevelId, orderIndex, isActive, createdAt);

  /// Create a copy of GrammarTopicResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GrammarTopicResponseImplCopyWith<_$GrammarTopicResponseImpl>
      get copyWith =>
          __$$GrammarTopicResponseImplCopyWithImpl<_$GrammarTopicResponseImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GrammarTopicResponseImplToJson(
      this,
    );
  }
}

abstract class _GrammarTopicResponse implements GrammarTopicResponse {
  const factory _GrammarTopicResponse(
      {required final int id,
      required final String title,
      final String? description,
      @JsonKey(name: 'language_level_id') required final int languageLevelId,
      @JsonKey(name: 'order_index') final int orderIndex,
      @JsonKey(name: 'is_active') final bool isActive,
      @JsonKey(name: 'created_at')
      required final DateTime createdAt}) = _$GrammarTopicResponseImpl;

  factory _GrammarTopicResponse.fromJson(Map<String, dynamic> json) =
      _$GrammarTopicResponseImpl.fromJson;

  @override
  int get id;
  @override
  String get title;
  @override
  String? get description;
  @override
  @JsonKey(name: 'language_level_id')
  int get languageLevelId;
  @override
  @JsonKey(name: 'order_index')
  int get orderIndex;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;

  /// Create a copy of GrammarTopicResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GrammarTopicResponseImplCopyWith<_$GrammarTopicResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

StructuredLessonResponse _$StructuredLessonResponseFromJson(
    Map<String, dynamic> json) {
  return _StructuredLessonResponse.fromJson(json);
}

/// @nodoc
mixin _$StructuredLessonResponse {
  int get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  @JsonKey(name: 'grammar_topic_id')
  int get grammarTopicId => throw _privateConstructorUsedError;
  @JsonKey(name: 'order_index')
  int get orderIndex => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this StructuredLessonResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StructuredLessonResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StructuredLessonResponseCopyWith<StructuredLessonResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StructuredLessonResponseCopyWith<$Res> {
  factory $StructuredLessonResponseCopyWith(StructuredLessonResponse value,
          $Res Function(StructuredLessonResponse) then) =
      _$StructuredLessonResponseCopyWithImpl<$Res, StructuredLessonResponse>;
  @useResult
  $Res call(
      {int id,
      String title,
      String? description,
      String content,
      @JsonKey(name: 'grammar_topic_id') int grammarTopicId,
      @JsonKey(name: 'order_index') int orderIndex,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class _$StructuredLessonResponseCopyWithImpl<$Res,
        $Val extends StructuredLessonResponse>
    implements $StructuredLessonResponseCopyWith<$Res> {
  _$StructuredLessonResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StructuredLessonResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? content = null,
    Object? grammarTopicId = null,
    Object? orderIndex = null,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      grammarTopicId: null == grammarTopicId
          ? _value.grammarTopicId
          : grammarTopicId // ignore: cast_nullable_to_non_nullable
              as int,
      orderIndex: null == orderIndex
          ? _value.orderIndex
          : orderIndex // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
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
abstract class _$$StructuredLessonResponseImplCopyWith<$Res>
    implements $StructuredLessonResponseCopyWith<$Res> {
  factory _$$StructuredLessonResponseImplCopyWith(
          _$StructuredLessonResponseImpl value,
          $Res Function(_$StructuredLessonResponseImpl) then) =
      __$$StructuredLessonResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String title,
      String? description,
      String content,
      @JsonKey(name: 'grammar_topic_id') int grammarTopicId,
      @JsonKey(name: 'order_index') int orderIndex,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class __$$StructuredLessonResponseImplCopyWithImpl<$Res>
    extends _$StructuredLessonResponseCopyWithImpl<$Res,
        _$StructuredLessonResponseImpl>
    implements _$$StructuredLessonResponseImplCopyWith<$Res> {
  __$$StructuredLessonResponseImplCopyWithImpl(
      _$StructuredLessonResponseImpl _value,
      $Res Function(_$StructuredLessonResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of StructuredLessonResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? content = null,
    Object? grammarTopicId = null,
    Object? orderIndex = null,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_$StructuredLessonResponseImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      grammarTopicId: null == grammarTopicId
          ? _value.grammarTopicId
          : grammarTopicId // ignore: cast_nullable_to_non_nullable
              as int,
      orderIndex: null == orderIndex
          ? _value.orderIndex
          : orderIndex // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
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
class _$StructuredLessonResponseImpl implements _StructuredLessonResponse {
  const _$StructuredLessonResponseImpl(
      {required this.id,
      required this.title,
      this.description,
      required this.content,
      @JsonKey(name: 'grammar_topic_id') required this.grammarTopicId,
      @JsonKey(name: 'order_index') this.orderIndex = 0,
      @JsonKey(name: 'is_active') this.isActive = true,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt});

  factory _$StructuredLessonResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$StructuredLessonResponseImplFromJson(json);

  @override
  final int id;
  @override
  final String title;
  @override
  final String? description;
  @override
  final String content;
  @override
  @JsonKey(name: 'grammar_topic_id')
  final int grammarTopicId;
  @override
  @JsonKey(name: 'order_index')
  final int orderIndex;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'StructuredLessonResponse(id: $id, title: $title, description: $description, content: $content, grammarTopicId: $grammarTopicId, orderIndex: $orderIndex, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StructuredLessonResponseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.grammarTopicId, grammarTopicId) ||
                other.grammarTopicId == grammarTopicId) &&
            (identical(other.orderIndex, orderIndex) ||
                other.orderIndex == orderIndex) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, description, content,
      grammarTopicId, orderIndex, isActive, createdAt, updatedAt);

  /// Create a copy of StructuredLessonResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StructuredLessonResponseImplCopyWith<_$StructuredLessonResponseImpl>
      get copyWith => __$$StructuredLessonResponseImplCopyWithImpl<
          _$StructuredLessonResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StructuredLessonResponseImplToJson(
      this,
    );
  }
}

abstract class _StructuredLessonResponse implements StructuredLessonResponse {
  const factory _StructuredLessonResponse(
          {required final int id,
          required final String title,
          final String? description,
          required final String content,
          @JsonKey(name: 'grammar_topic_id') required final int grammarTopicId,
          @JsonKey(name: 'order_index') final int orderIndex,
          @JsonKey(name: 'is_active') final bool isActive,
          @JsonKey(name: 'created_at') required final DateTime createdAt,
          @JsonKey(name: 'updated_at') final DateTime? updatedAt}) =
      _$StructuredLessonResponseImpl;

  factory _StructuredLessonResponse.fromJson(Map<String, dynamic> json) =
      _$StructuredLessonResponseImpl.fromJson;

  @override
  int get id;
  @override
  String get title;
  @override
  String? get description;
  @override
  String get content;
  @override
  @JsonKey(name: 'grammar_topic_id')
  int get grammarTopicId;
  @override
  @JsonKey(name: 'order_index')
  int get orderIndex;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;

  /// Create a copy of StructuredLessonResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StructuredLessonResponseImplCopyWith<_$StructuredLessonResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

LanguageLevelWithTopics _$LanguageLevelWithTopicsFromJson(
    Map<String, dynamic> json) {
  return _LanguageLevelWithTopics.fromJson(json);
}

/// @nodoc
mixin _$LanguageLevelWithTopics {
  @JsonKey(name: 'language_level')
  LanguageLevelResponse get languageLevel => throw _privateConstructorUsedError;
  @JsonKey(name: 'grammar_topics')
  List<GrammarTopicResponse> get grammarTopics =>
      throw _privateConstructorUsedError;

  /// Serializes this LanguageLevelWithTopics to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LanguageLevelWithTopics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LanguageLevelWithTopicsCopyWith<LanguageLevelWithTopics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LanguageLevelWithTopicsCopyWith<$Res> {
  factory $LanguageLevelWithTopicsCopyWith(LanguageLevelWithTopics value,
          $Res Function(LanguageLevelWithTopics) then) =
      _$LanguageLevelWithTopicsCopyWithImpl<$Res, LanguageLevelWithTopics>;
  @useResult
  $Res call(
      {@JsonKey(name: 'language_level') LanguageLevelResponse languageLevel,
      @JsonKey(name: 'grammar_topics')
      List<GrammarTopicResponse> grammarTopics});

  $LanguageLevelResponseCopyWith<$Res> get languageLevel;
}

/// @nodoc
class _$LanguageLevelWithTopicsCopyWithImpl<$Res,
        $Val extends LanguageLevelWithTopics>
    implements $LanguageLevelWithTopicsCopyWith<$Res> {
  _$LanguageLevelWithTopicsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LanguageLevelWithTopics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? languageLevel = null,
    Object? grammarTopics = null,
  }) {
    return _then(_value.copyWith(
      languageLevel: null == languageLevel
          ? _value.languageLevel
          : languageLevel // ignore: cast_nullable_to_non_nullable
              as LanguageLevelResponse,
      grammarTopics: null == grammarTopics
          ? _value.grammarTopics
          : grammarTopics // ignore: cast_nullable_to_non_nullable
              as List<GrammarTopicResponse>,
    ) as $Val);
  }

  /// Create a copy of LanguageLevelWithTopics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LanguageLevelResponseCopyWith<$Res> get languageLevel {
    return $LanguageLevelResponseCopyWith<$Res>(_value.languageLevel, (value) {
      return _then(_value.copyWith(languageLevel: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$LanguageLevelWithTopicsImplCopyWith<$Res>
    implements $LanguageLevelWithTopicsCopyWith<$Res> {
  factory _$$LanguageLevelWithTopicsImplCopyWith(
          _$LanguageLevelWithTopicsImpl value,
          $Res Function(_$LanguageLevelWithTopicsImpl) then) =
      __$$LanguageLevelWithTopicsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'language_level') LanguageLevelResponse languageLevel,
      @JsonKey(name: 'grammar_topics')
      List<GrammarTopicResponse> grammarTopics});

  @override
  $LanguageLevelResponseCopyWith<$Res> get languageLevel;
}

/// @nodoc
class __$$LanguageLevelWithTopicsImplCopyWithImpl<$Res>
    extends _$LanguageLevelWithTopicsCopyWithImpl<$Res,
        _$LanguageLevelWithTopicsImpl>
    implements _$$LanguageLevelWithTopicsImplCopyWith<$Res> {
  __$$LanguageLevelWithTopicsImplCopyWithImpl(
      _$LanguageLevelWithTopicsImpl _value,
      $Res Function(_$LanguageLevelWithTopicsImpl) _then)
      : super(_value, _then);

  /// Create a copy of LanguageLevelWithTopics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? languageLevel = null,
    Object? grammarTopics = null,
  }) {
    return _then(_$LanguageLevelWithTopicsImpl(
      languageLevel: null == languageLevel
          ? _value.languageLevel
          : languageLevel // ignore: cast_nullable_to_non_nullable
              as LanguageLevelResponse,
      grammarTopics: null == grammarTopics
          ? _value._grammarTopics
          : grammarTopics // ignore: cast_nullable_to_non_nullable
              as List<GrammarTopicResponse>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LanguageLevelWithTopicsImpl implements _LanguageLevelWithTopics {
  const _$LanguageLevelWithTopicsImpl(
      {@JsonKey(name: 'language_level') required this.languageLevel,
      @JsonKey(name: 'grammar_topics')
      required final List<GrammarTopicResponse> grammarTopics})
      : _grammarTopics = grammarTopics;

  factory _$LanguageLevelWithTopicsImpl.fromJson(Map<String, dynamic> json) =>
      _$$LanguageLevelWithTopicsImplFromJson(json);

  @override
  @JsonKey(name: 'language_level')
  final LanguageLevelResponse languageLevel;
  final List<GrammarTopicResponse> _grammarTopics;
  @override
  @JsonKey(name: 'grammar_topics')
  List<GrammarTopicResponse> get grammarTopics {
    if (_grammarTopics is EqualUnmodifiableListView) return _grammarTopics;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_grammarTopics);
  }

  @override
  String toString() {
    return 'LanguageLevelWithTopics(languageLevel: $languageLevel, grammarTopics: $grammarTopics)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LanguageLevelWithTopicsImpl &&
            (identical(other.languageLevel, languageLevel) ||
                other.languageLevel == languageLevel) &&
            const DeepCollectionEquality()
                .equals(other._grammarTopics, _grammarTopics));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, languageLevel,
      const DeepCollectionEquality().hash(_grammarTopics));

  /// Create a copy of LanguageLevelWithTopics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LanguageLevelWithTopicsImplCopyWith<_$LanguageLevelWithTopicsImpl>
      get copyWith => __$$LanguageLevelWithTopicsImplCopyWithImpl<
          _$LanguageLevelWithTopicsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LanguageLevelWithTopicsImplToJson(
      this,
    );
  }
}

abstract class _LanguageLevelWithTopics implements LanguageLevelWithTopics {
  const factory _LanguageLevelWithTopics(
          {@JsonKey(name: 'language_level')
          required final LanguageLevelResponse languageLevel,
          @JsonKey(name: 'grammar_topics')
          required final List<GrammarTopicResponse> grammarTopics}) =
      _$LanguageLevelWithTopicsImpl;

  factory _LanguageLevelWithTopics.fromJson(Map<String, dynamic> json) =
      _$LanguageLevelWithTopicsImpl.fromJson;

  @override
  @JsonKey(name: 'language_level')
  LanguageLevelResponse get languageLevel;
  @override
  @JsonKey(name: 'grammar_topics')
  List<GrammarTopicResponse> get grammarTopics;

  /// Create a copy of LanguageLevelWithTopics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LanguageLevelWithTopicsImplCopyWith<_$LanguageLevelWithTopicsImpl>
      get copyWith => throw _privateConstructorUsedError;
}

GrammarTopicWithLessons _$GrammarTopicWithLessonsFromJson(
    Map<String, dynamic> json) {
  return _GrammarTopicWithLessons.fromJson(json);
}

/// @nodoc
mixin _$GrammarTopicWithLessons {
  @JsonKey(name: 'grammar_topic')
  GrammarTopicResponse get grammarTopic => throw _privateConstructorUsedError;
  List<StructuredLessonResponse> get lessons =>
      throw _privateConstructorUsedError;

  /// Serializes this GrammarTopicWithLessons to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GrammarTopicWithLessons
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GrammarTopicWithLessonsCopyWith<GrammarTopicWithLessons> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GrammarTopicWithLessonsCopyWith<$Res> {
  factory $GrammarTopicWithLessonsCopyWith(GrammarTopicWithLessons value,
          $Res Function(GrammarTopicWithLessons) then) =
      _$GrammarTopicWithLessonsCopyWithImpl<$Res, GrammarTopicWithLessons>;
  @useResult
  $Res call(
      {@JsonKey(name: 'grammar_topic') GrammarTopicResponse grammarTopic,
      List<StructuredLessonResponse> lessons});

  $GrammarTopicResponseCopyWith<$Res> get grammarTopic;
}

/// @nodoc
class _$GrammarTopicWithLessonsCopyWithImpl<$Res,
        $Val extends GrammarTopicWithLessons>
    implements $GrammarTopicWithLessonsCopyWith<$Res> {
  _$GrammarTopicWithLessonsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GrammarTopicWithLessons
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? grammarTopic = null,
    Object? lessons = null,
  }) {
    return _then(_value.copyWith(
      grammarTopic: null == grammarTopic
          ? _value.grammarTopic
          : grammarTopic // ignore: cast_nullable_to_non_nullable
              as GrammarTopicResponse,
      lessons: null == lessons
          ? _value.lessons
          : lessons // ignore: cast_nullable_to_non_nullable
              as List<StructuredLessonResponse>,
    ) as $Val);
  }

  /// Create a copy of GrammarTopicWithLessons
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GrammarTopicResponseCopyWith<$Res> get grammarTopic {
    return $GrammarTopicResponseCopyWith<$Res>(_value.grammarTopic, (value) {
      return _then(_value.copyWith(grammarTopic: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$GrammarTopicWithLessonsImplCopyWith<$Res>
    implements $GrammarTopicWithLessonsCopyWith<$Res> {
  factory _$$GrammarTopicWithLessonsImplCopyWith(
          _$GrammarTopicWithLessonsImpl value,
          $Res Function(_$GrammarTopicWithLessonsImpl) then) =
      __$$GrammarTopicWithLessonsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'grammar_topic') GrammarTopicResponse grammarTopic,
      List<StructuredLessonResponse> lessons});

  @override
  $GrammarTopicResponseCopyWith<$Res> get grammarTopic;
}

/// @nodoc
class __$$GrammarTopicWithLessonsImplCopyWithImpl<$Res>
    extends _$GrammarTopicWithLessonsCopyWithImpl<$Res,
        _$GrammarTopicWithLessonsImpl>
    implements _$$GrammarTopicWithLessonsImplCopyWith<$Res> {
  __$$GrammarTopicWithLessonsImplCopyWithImpl(
      _$GrammarTopicWithLessonsImpl _value,
      $Res Function(_$GrammarTopicWithLessonsImpl) _then)
      : super(_value, _then);

  /// Create a copy of GrammarTopicWithLessons
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? grammarTopic = null,
    Object? lessons = null,
  }) {
    return _then(_$GrammarTopicWithLessonsImpl(
      grammarTopic: null == grammarTopic
          ? _value.grammarTopic
          : grammarTopic // ignore: cast_nullable_to_non_nullable
              as GrammarTopicResponse,
      lessons: null == lessons
          ? _value._lessons
          : lessons // ignore: cast_nullable_to_non_nullable
              as List<StructuredLessonResponse>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GrammarTopicWithLessonsImpl implements _GrammarTopicWithLessons {
  const _$GrammarTopicWithLessonsImpl(
      {@JsonKey(name: 'grammar_topic') required this.grammarTopic,
      required final List<StructuredLessonResponse> lessons})
      : _lessons = lessons;

  factory _$GrammarTopicWithLessonsImpl.fromJson(Map<String, dynamic> json) =>
      _$$GrammarTopicWithLessonsImplFromJson(json);

  @override
  @JsonKey(name: 'grammar_topic')
  final GrammarTopicResponse grammarTopic;
  final List<StructuredLessonResponse> _lessons;
  @override
  List<StructuredLessonResponse> get lessons {
    if (_lessons is EqualUnmodifiableListView) return _lessons;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_lessons);
  }

  @override
  String toString() {
    return 'GrammarTopicWithLessons(grammarTopic: $grammarTopic, lessons: $lessons)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GrammarTopicWithLessonsImpl &&
            (identical(other.grammarTopic, grammarTopic) ||
                other.grammarTopic == grammarTopic) &&
            const DeepCollectionEquality().equals(other._lessons, _lessons));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, grammarTopic, const DeepCollectionEquality().hash(_lessons));

  /// Create a copy of GrammarTopicWithLessons
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GrammarTopicWithLessonsImplCopyWith<_$GrammarTopicWithLessonsImpl>
      get copyWith => __$$GrammarTopicWithLessonsImplCopyWithImpl<
          _$GrammarTopicWithLessonsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GrammarTopicWithLessonsImplToJson(
      this,
    );
  }
}

abstract class _GrammarTopicWithLessons implements GrammarTopicWithLessons {
  const factory _GrammarTopicWithLessons(
          {@JsonKey(name: 'grammar_topic')
          required final GrammarTopicResponse grammarTopic,
          required final List<StructuredLessonResponse> lessons}) =
      _$GrammarTopicWithLessonsImpl;

  factory _GrammarTopicWithLessons.fromJson(Map<String, dynamic> json) =
      _$GrammarTopicWithLessonsImpl.fromJson;

  @override
  @JsonKey(name: 'grammar_topic')
  GrammarTopicResponse get grammarTopic;
  @override
  List<StructuredLessonResponse> get lessons;

  /// Create a copy of GrammarTopicWithLessons
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GrammarTopicWithLessonsImplCopyWith<_$GrammarTopicWithLessonsImpl>
      get copyWith => throw _privateConstructorUsedError;
}

LanguageLessonsResponse _$LanguageLessonsResponseFromJson(
    Map<String, dynamic> json) {
  return _LanguageLessonsResponse.fromJson(json);
}

/// @nodoc
mixin _$LanguageLessonsResponse {
  String get language => throw _privateConstructorUsedError;
  String? get level => throw _privateConstructorUsedError;
  int? get topicId => throw _privateConstructorUsedError;
  List<StructuredLessonResponse> get lessons =>
      throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;
  int get offset => throw _privateConstructorUsedError;
  int get limit => throw _privateConstructorUsedError;

  /// Serializes this LanguageLessonsResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LanguageLessonsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LanguageLessonsResponseCopyWith<LanguageLessonsResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LanguageLessonsResponseCopyWith<$Res> {
  factory $LanguageLessonsResponseCopyWith(LanguageLessonsResponse value,
          $Res Function(LanguageLessonsResponse) then) =
      _$LanguageLessonsResponseCopyWithImpl<$Res, LanguageLessonsResponse>;
  @useResult
  $Res call(
      {String language,
      String? level,
      int? topicId,
      List<StructuredLessonResponse> lessons,
      int total,
      int offset,
      int limit});
}

/// @nodoc
class _$LanguageLessonsResponseCopyWithImpl<$Res,
        $Val extends LanguageLessonsResponse>
    implements $LanguageLessonsResponseCopyWith<$Res> {
  _$LanguageLessonsResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LanguageLessonsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? language = null,
    Object? level = freezed,
    Object? topicId = freezed,
    Object? lessons = null,
    Object? total = null,
    Object? offset = null,
    Object? limit = null,
  }) {
    return _then(_value.copyWith(
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      level: freezed == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as String?,
      topicId: freezed == topicId
          ? _value.topicId
          : topicId // ignore: cast_nullable_to_non_nullable
              as int?,
      lessons: null == lessons
          ? _value.lessons
          : lessons // ignore: cast_nullable_to_non_nullable
              as List<StructuredLessonResponse>,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      offset: null == offset
          ? _value.offset
          : offset // ignore: cast_nullable_to_non_nullable
              as int,
      limit: null == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LanguageLessonsResponseImplCopyWith<$Res>
    implements $LanguageLessonsResponseCopyWith<$Res> {
  factory _$$LanguageLessonsResponseImplCopyWith(
          _$LanguageLessonsResponseImpl value,
          $Res Function(_$LanguageLessonsResponseImpl) then) =
      __$$LanguageLessonsResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String language,
      String? level,
      int? topicId,
      List<StructuredLessonResponse> lessons,
      int total,
      int offset,
      int limit});
}

/// @nodoc
class __$$LanguageLessonsResponseImplCopyWithImpl<$Res>
    extends _$LanguageLessonsResponseCopyWithImpl<$Res,
        _$LanguageLessonsResponseImpl>
    implements _$$LanguageLessonsResponseImplCopyWith<$Res> {
  __$$LanguageLessonsResponseImplCopyWithImpl(
      _$LanguageLessonsResponseImpl _value,
      $Res Function(_$LanguageLessonsResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of LanguageLessonsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? language = null,
    Object? level = freezed,
    Object? topicId = freezed,
    Object? lessons = null,
    Object? total = null,
    Object? offset = null,
    Object? limit = null,
  }) {
    return _then(_$LanguageLessonsResponseImpl(
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      level: freezed == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as String?,
      topicId: freezed == topicId
          ? _value.topicId
          : topicId // ignore: cast_nullable_to_non_nullable
              as int?,
      lessons: null == lessons
          ? _value._lessons
          : lessons // ignore: cast_nullable_to_non_nullable
              as List<StructuredLessonResponse>,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      offset: null == offset
          ? _value.offset
          : offset // ignore: cast_nullable_to_non_nullable
              as int,
      limit: null == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LanguageLessonsResponseImpl implements _LanguageLessonsResponse {
  const _$LanguageLessonsResponseImpl(
      {required this.language,
      this.level,
      this.topicId,
      required final List<StructuredLessonResponse> lessons,
      required this.total,
      required this.offset,
      required this.limit})
      : _lessons = lessons;

  factory _$LanguageLessonsResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$LanguageLessonsResponseImplFromJson(json);

  @override
  final String language;
  @override
  final String? level;
  @override
  final int? topicId;
  final List<StructuredLessonResponse> _lessons;
  @override
  List<StructuredLessonResponse> get lessons {
    if (_lessons is EqualUnmodifiableListView) return _lessons;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_lessons);
  }

  @override
  final int total;
  @override
  final int offset;
  @override
  final int limit;

  @override
  String toString() {
    return 'LanguageLessonsResponse(language: $language, level: $level, topicId: $topicId, lessons: $lessons, total: $total, offset: $offset, limit: $limit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LanguageLessonsResponseImpl &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.topicId, topicId) || other.topicId == topicId) &&
            const DeepCollectionEquality().equals(other._lessons, _lessons) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.offset, offset) || other.offset == offset) &&
            (identical(other.limit, limit) || other.limit == limit));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, language, level, topicId,
      const DeepCollectionEquality().hash(_lessons), total, offset, limit);

  /// Create a copy of LanguageLessonsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LanguageLessonsResponseImplCopyWith<_$LanguageLessonsResponseImpl>
      get copyWith => __$$LanguageLessonsResponseImplCopyWithImpl<
          _$LanguageLessonsResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LanguageLessonsResponseImplToJson(
      this,
    );
  }
}

abstract class _LanguageLessonsResponse implements LanguageLessonsResponse {
  const factory _LanguageLessonsResponse(
      {required final String language,
      final String? level,
      final int? topicId,
      required final List<StructuredLessonResponse> lessons,
      required final int total,
      required final int offset,
      required final int limit}) = _$LanguageLessonsResponseImpl;

  factory _LanguageLessonsResponse.fromJson(Map<String, dynamic> json) =
      _$LanguageLessonsResponseImpl.fromJson;

  @override
  String get language;
  @override
  String? get level;
  @override
  int? get topicId;
  @override
  List<StructuredLessonResponse> get lessons;
  @override
  int get total;
  @override
  int get offset;
  @override
  int get limit;

  /// Create a copy of LanguageLessonsResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LanguageLessonsResponseImplCopyWith<_$LanguageLessonsResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
