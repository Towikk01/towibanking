import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:towibanking/core/models/category.dart';
import 'package:towibanking/core/models/transaction.dart';
import 'package:towibanking/core/riverpod/balance.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  void addTransaction(
      Transaction transaction, WidgetRef ref, BuildContext context) {
    state = [
      transaction,
      ...state,
    ];
    if (transaction.type == 'income') {
      ref
          .watch(balanceProvider.notifier)
          .addMoney(transaction.amount, transaction.paymentMethod, context);
    } else {
      ref
          .watch(balanceProvider.notifier)
          .removeMoney(transaction.amount, transaction.paymentMethod, context);
    }
    ref.watch(balanceProvider.notifier).saveBalance();
    saveTransactions();
  }

  void removeTransaction(
      Transaction transaction, WidgetRef ref, BuildContext context) {
    state = state.where((trans) => trans.date != transaction.date).toList();
    if (transaction.type == 'income') {
      ref
          .watch(balanceProvider.notifier)
          .removeMoney(transaction.amount, transaction.paymentMethod, context);
    } else {
      ref
          .watch(balanceProvider.notifier)
          .addMoney(transaction.amount, transaction.paymentMethod, context);
    }
    ref.watch(balanceProvider.notifier).saveBalance();
    saveTransactions();
  }

  void changeTransaction(Transaction oldTransaction, Transaction newTransaction,
      WidgetRef ref, BuildContext context) {
    if (oldTransaction.type == 'income') {
      ref.watch(balanceProvider.notifier).removeMoney(
          oldTransaction.amount, oldTransaction.paymentMethod, context);
    } else if (oldTransaction.type == 'expense') {
      ref.watch(balanceProvider.notifier).addMoney(
          oldTransaction.amount, oldTransaction.paymentMethod, context);
    }

    if (newTransaction.type == 'income') {
      ref.watch(balanceProvider.notifier).addMoney(
          newTransaction.amount, newTransaction.paymentMethod, context);
    } else if (newTransaction.type == 'expense') {
      ref.watch(balanceProvider.notifier).removeMoney(
          newTransaction.amount, newTransaction.paymentMethod, context);
    }
    ref.watch(balanceProvider.notifier).saveBalance();

    state =
        state.map((el) => el == oldTransaction ? newTransaction : el).toList();
    saveTransactions();
  }

  void submitTransaction(
      String transactionType,
      String paymentMethod,
      Category selectedCategory,
      double amount,
      String comment,
      WidgetRef ref,
      BuildContext context) {
    if (amount <= 0) return;

    final transaction = Transaction(
      amount: amount,
      type: transactionType,
      paymentMethod: paymentMethod,
      category: selectedCategory,
      date: DateTime.now(),
      comment: comment.isEmpty ? null : comment,
    );

    addTransaction(transaction, ref, context);

    if (transactionType == 'income') {
      ref
          .watch(balanceProvider.notifier)
          .addMoney(amount, paymentMethod, context);
    } else if (transactionType == 'expense') {
      ref
          .watch(balanceProvider.notifier)
          .removeMoney(amount, paymentMethod, context);
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
