import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:towibanking/core/models/category.dart';
import 'package:towibanking/core/models/transaction.dart';
import 'package:towibanking/core/riverpod/balance.dart';

// transaction_provider.dart
final transactionProvider =
    StateNotifierProvider<TransactionNotifier, List<Transaction>>((ref) {
  return TransactionNotifier()..loadTransactions();
});

class TransactionNotifier extends StateNotifier<List<Transaction>> {
  TransactionNotifier() : super([]);

  Future<void> loadTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final transactionsString = prefs.getString('transactions') ?? '[]';
    final transactionsList = json.decode(transactionsString) as List;
    state = transactionsList
        .map((transactionJson) => Transaction.fromJson(transactionJson))
        .toList();
  }

  Future<void> saveTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final transactionsJson =
        state.map((transaction) => transaction.toJson()).toList();
    prefs.setString('transactions', json.encode(transactionsJson));
  }

  void addTransaction(Transaction transaction) {
    state = [
      transaction,
      ...state,
    ];
    saveTransactions();
  }

  void removeTransaction(Transaction transaction) {
    state = state.where((trans) => trans.date != transaction.date).toList();
    saveTransactions();
  }

  void submitTransaction(String transactionType, String paymentMethod,
      Category selectedCategory, double amount, String comment, WidgetRef ref) {
    if (amount <= 0) return;

    final transaction = Transaction(
      amount: amount,
      type: transactionType,
      paymentMethod: paymentMethod,
      category: selectedCategory,
      date: DateTime.now(),
      comment: comment.isEmpty ? null : comment,
    );

    addTransaction(transaction);

    if (transactionType == 'income') {
      ref.read(balanceProvider.notifier).addMoney(amount, paymentMethod);
    } else if (transactionType == 'expense') {
      ref.read(balanceProvider.notifier).removeMoney(amount, paymentMethod);
    }
    saveTransactions();
  }

  void reset() async {
    state = [];
    var prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await saveTransactions();
  }
}
