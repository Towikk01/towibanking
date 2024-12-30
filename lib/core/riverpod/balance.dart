import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Balance {
  double cash;
  double card;

  Balance({this.cash = 0.0, this.card = 0.0});

  Balance copyWith({double? cash, double? card}) {
    return Balance(
      cash: cash ?? this.cash,
      card: card ?? this.card,
    );
  }

  Map<String, dynamic> toJson() => {
        'cash': cash,
        'card': card,
      };

  factory Balance.fromJson(Map<String, dynamic> json) {
    return Balance(
      cash: json['cash'] ?? 0.0,
      card: json['card'] ?? 0.0,
    );
  }
}

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
}
