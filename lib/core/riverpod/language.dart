import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final languageNotifierProvider =
    StateNotifierProvider<LanguageNotifier, String>((ref) {
  return LanguageNotifier()..loadLanguage();
});


class LanguageNotifier extends StateNotifier<String> {
  LanguageNotifier() : super('en');

  Future<void> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguage = prefs.getString('language') ?? 'en';
    state = savedLanguage;
  }

  Future<void> saveLanguage(String language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', language);
    state = language;
  }

  void changeLanguage(String language) {
    saveLanguage(language);
  }
}