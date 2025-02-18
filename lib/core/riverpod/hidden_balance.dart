import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:towibanking/core/models/hiddden_balance.dart';

final hiddenBalanceNotifier =
    StateNotifierProvider<HiddenBalanceNotifier, HiddenBalance>((ref) {
  return HiddenBalanceNotifier()..loadHiddenBalance();
});

class HiddenBalanceNotifier extends StateNotifier<HiddenBalance> {
  HiddenBalanceNotifier() : super(HiddenBalance());

  get hiddenBalance => state.hiddenBalance;
  Future<void> loadHiddenBalance() async {
    final prefs = await SharedPreferences.getInstance();
    final hiddenBalance = prefs.getDouble('hiddenBalance') ?? 0.0;
    state = HiddenBalance(hiddenBalance: hiddenBalance);
  }

  Future<void> saveHiddenBalance() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('hiddenBalance', state.hiddenBalance);
  }

  Future<void> updateHiddenBalance(double hiddenBalance) async {
    state = state.copyWith(hiddenBalance: hiddenBalance);
    await saveHiddenBalance();
  }


  Future<void> reset() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.remove('hiddenBalance');
    state = state.copyWith(
      hiddenBalance: 0.0,
    );
    saveHiddenBalance();
  }
}
