import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/language.dart';

final selectedLanguageProvider = StateProvider<Language?>((ref) => supportedLanguages.first);
final selectedLevelProvider = StateProvider<LanguageLevel>((ref) => LanguageLevel.A1);
final communicationLanguageProvider = StateProvider<Language?>((ref) => supportedLanguages.first);
