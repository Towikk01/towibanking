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
    StateNotifierProvider<CurrencyNotifier, Map<String, String>>((ref) {
  var notifier = CurrencyNotifier(currencies);
  notifier.loadCurrency();
  return notifier;
});

class CurrencyNotifier extends StateNotifier<Map<String, String>> {
  CurrencyNotifier(super.state);
  var _selectedCurrency = currencies['UAH'];
  String get selectedCurrency => _selectedCurrency!;

  Future<void> loadCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedCurrency = prefs.getString('currency') ?? 'UAH';
    state = Map.from(state);
  }

  Future<void> saveCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('currency', _selectedCurrency!);
  }

  void changeCurrency(String currency) {
    if (state.containsKey(currency)) {
      _selectedCurrency = currencies[currency]!;
      print(_selectedCurrency);
      saveCurrency();
      state = {...state, 'selectedCurrency': _selectedCurrency!};
    }
  }

  Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _selectedCurrency = 'UAH';
    state = Map.from(currencies);
  }
}
