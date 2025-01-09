import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final currencyProvider = StateNotifierProvider<CurrencyNotifier, String>((ref) {
  return CurrencyNotifier()..loadCurrency();
});

class CurrencyNotifier extends StateNotifier<String> {
  CurrencyNotifier() : super('UAN');

  Future<void> loadCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    final currency = prefs.getString('currency') ?? 'UAN';
    state = currency;
  }

  Future<void> saveCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('currency', state);
  }

  void changeCurrency(String currency) {
    state = currency;
    saveCurrency();
  }

  void reset() async {
    state = 'UAN';
    var prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await saveCurrency();
  }
}
