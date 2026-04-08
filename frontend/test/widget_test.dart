// Flutter widget tests — Dil Pratik
// Bu testler backend gerektirmeden saf UI bileşenlerini test eder.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:dil_pratik/l10n/app_l10n.dart';
import 'package:dil_pratik/providers/ui_language_provider.dart';

// ──────────────────────────────────────────────────────────────
// AppL10n unit testleri — network bağımsız
// ──────────────────────────────────────────────────────────────

void main() {
  group('AppL10n', () {
    test('Türkçe (tr) stringleri doğru döner', () {
      final s = AppL10n.of('tr');
      expect(s.appTitle, 'Dil Pratik');
      expect(s.lessons, 'Dersler');
      expect(s.loginButton, 'Giriş Yap');
      expect(s.registerButton, 'Kayıt Ol');
      expect(s.doExercise, 'Egzersiz Yap');
    });

    test('İngilizce (en) stringleri doğru döner', () {
      final s = AppL10n.of('en');
      expect(s.appTitle, 'Dil Pratik');
      expect(s.lessons, 'Lessons');
      expect(s.loginButton, 'Log In');
      expect(s.registerButton, 'Sign Up');
      expect(s.doExercise, 'Do Exercise');
    });

    test('Almanca (de) stringleri doğru döner', () {
      final s = AppL10n.of('de');
      expect(s.appTitle, 'Dil Pratik');
      expect(s.lessons, 'Lektionen');
      expect(s.loginButton, 'Anmelden');
      expect(s.registerButton, 'Registrieren');
    });

    test('Bilinmeyen dil kodu Türkçe\'ye düşer', () {
      final s = AppL10n.of('xx');
      expect(s.lessons, 'Dersler');
    });

    test('Tüm dillerde kritik alanlar boş değil', () {
      for (final code in ['tr', 'en', 'de']) {
        final s = AppL10n.of(code);
        expect(s.appTitle.isNotEmpty, true, reason: '$code: appTitle boş');
        expect(s.email.isNotEmpty, true, reason: '$code: email boş');
        expect(s.password.isNotEmpty, true, reason: '$code: password boş');
        expect(s.loginButton.isNotEmpty, true, reason: '$code: loginButton boş');
        expect(s.cancel.isNotEmpty, true, reason: '$code: cancel boş');
        expect(s.save.isNotEmpty, true, reason: '$code: save boş');
        expect(s.networkError.isNotEmpty, true,
            reason: '$code: networkError boş');
      }
    });
  });

  // ──────────────────────────────────────────────────────────────
  // UiLanguageNotifier unit testleri
  // ──────────────────────────────────────────────────────────────

  group('UiLanguageNotifier', () {
    test('Başlangıç dili Türkçe (tr)', () {
      final notifier = UiLanguageNotifier();
      // SharedPreferences yok → default tr
      expect(notifier.debugState, 'tr');
    });

    test('Desteklenen flag emojisi doğru döner', () {
      expect(flagForLang('tr'), '🇹🇷');
      expect(flagForLang('en'), '🇬🇧');
      expect(flagForLang('de'), '🇩🇪');
      expect(flagForLang('xx'), '🇹🇷'); // fallback
    });

    test('kUiLangOptions 3 dil içerir', () {
      expect(kUiLangOptions.length, 3);
      final codes = kUiLangOptions.map((o) => o.code).toList();
      expect(codes, containsAll(['tr', 'en', 'de']));
    });
  });

  // ──────────────────────────────────────────────────────────────
  // Widget testleri — izole UI bileşenleri
  // ──────────────────────────────────────────────────────────────

  group('AppStrings widget rendering', () {
    testWidgets('AppL10n stringleri Text widget ile doğru render edilir',
        (WidgetTester tester) async {
      final s = AppL10n.of('en');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                Text(s.lessons, key: const Key('lessons')),
                Text(s.practice, key: const Key('practice')),
                Text(s.loginButton, key: const Key('login')),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Lessons'), findsOneWidget);
      expect(find.text('Practice'), findsOneWidget);
      expect(find.text('Log In'), findsOneWidget);
    });
  });

  group('ProviderScope + appStringsProvider', () {
    testWidgets('Provider varsayılan olarak Türkçe string döndürür',
        (WidgetTester tester) async {
      late AppStrings strings;

      await tester.pumpWidget(
        ProviderScope(
          child: Consumer(
            builder: (context, ref, _) {
              strings = ref.watch(appStringsProvider);
              return const MaterialApp(home: SizedBox());
            },
          ),
        ),
      );

      await tester.pump();
      expect(strings.lessons, 'Dersler');
    });

    testWidgets('uiLanguageProvider override ile İngilizce string döndürür',
        (WidgetTester tester) async {
      late AppStrings strings;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            uiLanguageProvider.overrideWith(
              (ref) => _FixedLangNotifier('en'),
            ),
          ],
          child: Consumer(
            builder: (context, ref, _) {
              strings = ref.watch(appStringsProvider);
              return const MaterialApp(home: SizedBox());
            },
          ),
        ),
      );

      await tester.pump();
      expect(strings.lessons, 'Lessons');
    });
  });

  // ──────────────────────────────────────────────────────────────
  // Form validation testleri (bağımsız validator fonksiyonları)
  // ──────────────────────────────────────────────────────────────

  group('Login form validation', () {
    final s = AppL10n.of('tr');

    String? validateEmail(String? value) {
      if (value == null || value.isEmpty) return s.emailRequired;
      if (!value.contains('@')) return s.emailInvalid;
      return null;
    }

    String? validatePassword(String? value) {
      if (value == null || value.isEmpty) return s.passwordRequired;
      if (value.length < 6) return s.passwordTooShort;
      return null;
    }

    test('Boş email hata mesajı döndürür', () {
      expect(validateEmail(''), s.emailRequired);
      expect(validateEmail(null), s.emailRequired);
    });

    test('Geçersiz email hata mesajı döndürür', () {
      expect(validateEmail('notanemail'), s.emailInvalid);
    });

    test('Geçerli email null döndürür', () {
      expect(validateEmail('user@example.com'), null);
    });

    test('Boş şifre hata mesajı döndürür', () {
      expect(validatePassword(''), s.passwordRequired);
    });

    test('Kısa şifre hata mesajı döndürür', () {
      expect(validatePassword('abc'), s.passwordTooShort);
    });

    test('Geçerli şifre null döndürür', () {
      expect(validatePassword('secure123'), null);
    });
  });

  group('Register form validation', () {
    final s = AppL10n.of('tr');

    String? validateUsername(String? value) {
      if (value == null || value.isEmpty) return s.usernameRequired;
      if (value.length < 3) return 'En az 3 karakter';
      return null;
    }

    test('Boş kullanıcı adı hata mesajı döndürür', () {
      expect(validateUsername(''), s.usernameRequired);
    });

    test('Kısa kullanıcı adı hata mesajı döndürür', () {
      expect(validateUsername('ab'), 'En az 3 karakter');
    });

    test('Geçerli kullanıcı adı null döndürür', () {
      expect(validateUsername('alice'), null);
    });
  });
}

/// Test için sabit dil döndüren Notifier.
class _FixedLangNotifier extends StateNotifier<String> {
  _FixedLangNotifier(super.state);
}
