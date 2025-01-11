import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Map<String, String> currencies = {
  'UAH': '₴',
  'USD': '\$',
  'EUR': '€',
  'RUB': '₽',
  'GBP': '£',
  'JPY': '¥',
  'CNY': '¥',
  'CHF': '₣',
  'CAD': '\$',
  'AUD': '\$',
  'SEK': 'kr',
};

final currencyProvider =
    StateNotifierProvider<CurrencyNotifier, Map<String, dynamic>>((ref) {
  var notifier = CurrencyNotifier(
      {"currencies": currencies, 'selectedCurrency': currencies['UAH']!});
  notifier.loadCurrency();
  return notifier;
});

class CurrencyNotifier extends StateNotifier<Map<String, dynamic>> {
  CurrencyNotifier(super.state);

  Future<void> loadCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCurrency = prefs.getString('currency') ?? 'UAH';
    state = {
      ...state,
      'selectedCurrency': currencies[savedCurrency]!,
    };
  }

  Future<void> saveCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    final currentCurrencyKey = currencies.keys.firstWhere(
      (key) => currencies[key] == state['selectedCurrency'],
      orElse: () => 'UAH',
    );
    await prefs.setString('currency', currentCurrencyKey);
  }

  void changeCurrency(String currency) {
    state = {
      ...state,
      'selectedCurrency': currencies[currency]!,
    };
    saveCurrency();
  }

  Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    // _selectedCurrency = 'UAH';
    // state = Map.from(currencies);
  }
}
