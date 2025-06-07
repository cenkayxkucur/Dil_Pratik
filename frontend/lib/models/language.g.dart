// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'language.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LanguageImpl _$$LanguageImplFromJson(Map<String, dynamic> json) =>
    _$LanguageImpl(
      code: json['code'] as String,
      name: json['name'] as String,
      flag: json['flag'] as String,
      isActive: json['isActive'] as bool? ?? true,
    );

Map<String, dynamic> _$$LanguageImplToJson(_$LanguageImpl instance) =>
    <String, dynamic>{
      'code': instance.code,
      'name': instance.name,
      'flag': instance.flag,
      'isActive': instance.isActive,
    };
