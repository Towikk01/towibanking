import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:towibanking/core/models/balance.dart';

final isFirstLaunchProvider = FutureProvider.autoDispose<bool>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return !(prefs.getBool('isInitialBalanceSet') ?? false);
});

final balanceProvider = StateNotifierProvider<BalanceNotifier, Balance>((ref) {
  return BalanceNotifier()..loadBalance();
});

class BalanceNotifier extends StateNotifier<Balance> {
  BalanceNotifier() : super(Balance());

  Future<void> loadBalance() async {
    final prefs = await SharedPreferences.getInstance();
    final cash = prefs.getDouble('cash') ?? 0.0;
    final card = prefs.getDouble('card') ?? 0.0;
    state = Balance(cash: cash, card: card);
  }

  void updateBalance(double cash, double card) {
    state = state.copyWith(cash: cash, card: card);
    saveBalance();
  }

  Future<void> saveBalance() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('cash', state.cash);
    prefs.setDouble('card', state.card);
  }

  void addMoney(double amount, String type) {
    if (type == 'Наличные') {
      state = state.copyWith(cash: state.cash + amount);
    } else if (type == 'Карта') {
      state = state.copyWith(card: state.card + amount);
    }
    saveBalance();
  }

  void removeMoney(double amount, String type) {
    if (type == 'Наличные') {
      state = state.copyWith(cash: state.cash - amount);
    } else if (type == 'Карта') {
      state = state.copyWith(card: state.card - amount);
    }
    saveBalance();
  }

  void reset() async {
    state = state.copyWith(cash: 0.0, card: 0.0);
    var prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    saveBalance();
  }
}
