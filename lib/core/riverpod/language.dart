import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:towibanking/core/riverpod/transaction.dart';

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

  Future<void> changeLanguage(String language, WidgetRef ref) async {
    final transactionsNotifier = ref.watch(transactionProvider.notifier);
    transactionsNotifier.translateNamesByLocale(language);
    await saveLanguage(language);
  }
}
