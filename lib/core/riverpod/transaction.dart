import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:towibanking/core/models/transaction.dart';

final transactionProvider =
    StateNotifierProvider<TransactionNotifier, List<Transaction>>((ref) {
  return TransactionNotifier();
});

class TransactionNotifier extends StateNotifier<List<Transaction>> {
  TransactionNotifier() : super([]);

  void addTransaction(Transaction transaction) {
    state = [
      transaction,
      ...state,
    ];
  }

  //create function of remove transaction
  void removeTransaction(Transaction transaction) {
    state = state.where((trans) => trans.date != transaction.date).toList();
  }
}
