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

  void addTransaction(Transaction transaction, WidgetRef ref) {
    state = [
      transaction,
      ...state,
    ];
    if (transaction.type == 'income') {
      ref
          .watch(balanceProvider.notifier)
          .addMoney(transaction.amount, transaction.paymentMethod);
    } else {
      ref
          .watch(balanceProvider.notifier)
          .removeMoney(transaction.amount, transaction.paymentMethod);
    }
    ref.watch(balanceProvider.notifier).saveBalance();
    saveTransactions();
  }

  void removeTransaction(Transaction transaction, WidgetRef ref) {
    state = state.where((trans) => trans.date != transaction.date).toList();
    if (transaction.type == 'income') {
      ref
          .watch(balanceProvider.notifier)
          .removeMoney(transaction.amount, transaction.paymentMethod);
    } else {
      ref
          .watch(balanceProvider.notifier)
          .addMoney(transaction.amount, transaction.paymentMethod);
    }
    ref.watch(balanceProvider.notifier).saveBalance();
    saveTransactions();
  }

  void changeTransaction(
      Transaction oldTransaction, Transaction newTransaction, WidgetRef ref) {
    // Revert the old transaction
    if (oldTransaction.type == 'income') {
      ref
          .watch(balanceProvider.notifier)
          .removeMoney(oldTransaction.amount, oldTransaction.paymentMethod);
    } else if (oldTransaction.type == 'expense') {
      ref
          .watch(balanceProvider.notifier)
          .addMoney(oldTransaction.amount, oldTransaction.paymentMethod);
    }

    // Apply the new transaction
    if (newTransaction.type == 'income') {
      ref
          .watch(balanceProvider.notifier)
          .addMoney(newTransaction.amount, newTransaction.paymentMethod);
    } else if (newTransaction.type == 'expense') {
      ref
          .watch(balanceProvider.notifier)
          .removeMoney(newTransaction.amount, newTransaction.paymentMethod);
    }
    ref.watch(balanceProvider.notifier).saveBalance();

    // Update the transaction in the state
    state =
        state.map((el) => el == oldTransaction ? newTransaction : el).toList();
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

    addTransaction(transaction, ref);

    if (transactionType == 'income') {
      ref.watch(balanceProvider.notifier).addMoney(amount, paymentMethod);
    } else if (transactionType == 'expense') {
      ref.watch(balanceProvider.notifier).removeMoney(amount, paymentMethod);
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
