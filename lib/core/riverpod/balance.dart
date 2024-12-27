import 'package:flutter_riverpod/flutter_riverpod.dart';

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
}

final balanceProvider = StateNotifierProvider<BalanceNotifier, Balance>((ref) {
  return BalanceNotifier();
});

class BalanceNotifier extends StateNotifier<Balance> {
  BalanceNotifier() : super(Balance());

  void addMoney(double amount, String type) {
    if (type == 'Наличные') {
      state = state.copyWith(cash: state.cash + amount);
    } else if (type == 'Карта') {
      state = state.copyWith(card: state.card + amount);
    }
  }

  void removeMoney(double amount, String type) {
    if (type == 'Наличные') {
      state = state.copyWith(cash: state.cash - amount);
    } else if (type == 'Карта') {
      state = state.copyWith(card: state.card - amount);
    }
  }
}
