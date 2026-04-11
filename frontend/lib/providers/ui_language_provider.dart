import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../l10n/app_l10n.dart';

const _kUiLangKey = 'ui_language';

/// Kullanıcının seçtiği arayüz dilini yönetir (tr / en / de).
/// SharedPreferences ile kalıcı olarak saklanır.
class UiLanguageNotifier extends StateNotifier<String> {
  UiLanguageNotifier() : super('tr') {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_kUiLangKey);
    if (saved != null && ['tr', 'en', 'de'].contains(saved)) {
      state = saved;
    }
  }

  Future<void> setLanguage(String code) async {
    if (state == code) return;
    state = code;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kUiLangKey, code);
  }
}

final uiLanguageProvider =
    StateNotifierProvider<UiLanguageNotifier, String>((ref) {
  return UiLanguageNotifier();
});

/// Kısayol — mevcut dil koduna göre hazır `AppStrings` döndürür.
final appStringsProvider = Provider<AppStrings>((ref) {
  final code = ref.watch(uiLanguageProvider);
  return AppL10n.of(code);
});

/// Arayüz dili seçimi için flag + label veri yapısı.
class UiLangOption {
  final String code;
  final String flag;
  final String label;

  const UiLangOption(this.code, this.flag, this.label);
}

const kUiLangOptions = [
  UiLangOption('tr', '🇹🇷', 'Türkçe'),
  UiLangOption('en', '🇬🇧', 'English'),
  UiLangOption('de', '🇩🇪', 'Deutsch'),
];

/// Dil koduna göre flag emoji döndürür.
String flagForLang(String code) {
  switch (code) {
    case 'en':
      return '🇬🇧';
    case 'de':
      return '🇩🇪';
    default:
      return '🇹🇷';
  }
}

/// Klavye navigasyonu için tüm uygulama focus sıralamasını yöneten traversal policy.
/// Web platformunda klavye ile Tab tuşu ile gezinmeyi destekler.
class AppFocusTraversalPolicy extends ReadingOrderTraversalPolicy {
  AppFocusTraversalPolicy();
}
