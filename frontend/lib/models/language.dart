import 'package:freezed_annotation/freezed_annotation.dart';

part 'language.freezed.dart';
part 'language.g.dart';

@freezed
class Language with _$Language {
  const factory Language({
    required String code,
    required String name,
    required String flag,
    @Default(true) bool isActive,
  }) = _Language;

  factory Language.fromJson(Map<String, dynamic> json) => _$LanguageFromJson(json);
}

// Desteklenen diller
const List<Language> supportedLanguages = [
  Language(code: 'turkish', name: 'Türkçe', flag: '🇹🇷'),
  Language(code: 'english', name: 'English', flag: '🇺🇸'),
  Language(code: 'german', name: 'Deutsch', flag: '🇩🇪'),
];

// Dil seviyeleri
// CEFR (Common European Framework of Reference) standard level identifiers
// ignore: constant_identifier_names
enum LanguageLevel {
  // ignore: constant_identifier_names
  A1,
  // ignore: constant_identifier_names
  A2,
  // ignore: constant_identifier_names
  B1,
  // ignore: constant_identifier_names
  B2,
  // ignore: constant_identifier_names
  C1,
  // ignore: constant_identifier_names
  C2,
}

extension LanguageLevelExtension on LanguageLevel {
  String get code {
    switch (this) {
      case LanguageLevel.A1:
        return 'A1';
      case LanguageLevel.A2:
        return 'A2';
      case LanguageLevel.B1:
        return 'B1';
      case LanguageLevel.B2:
        return 'B2';
      case LanguageLevel.C1:
        return 'C1';
      case LanguageLevel.C2:
        return 'C2';
    }
  }

  String get displayName {
    switch (this) {
      case LanguageLevel.A1:
        return 'A1 - Başlangıç';
      case LanguageLevel.A2:
        return 'A2 - Temel';
      case LanguageLevel.B1:
        return 'B1 - Orta';
      case LanguageLevel.B2:
        return 'B2 - Orta Üstü';
      case LanguageLevel.C1:
        return 'C1 - İleri';
      case LanguageLevel.C2:
        return 'C2 - Uzman';
    }
  }
}
