import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:towibanking/core/models/transaction_form.dart';
import 'package:towibanking/core/riverpod/balance.dart';
import 'package:towibanking/core/riverpod/category.dart';
import 'package:towibanking/core/riverpod/transaction.dart';
import 'package:towibanking/core/widgets/add_transaction.dart';

void showTransactionDialog(BuildContext context, WidgetRef ref) {
  final TransactionForm transactionForm = TransactionForm(
      transactionType: 'income',
      paymentMethod: 'Наличные',
      selectedCategory: defaultCategories.first,
      date: DateTime.now(),
      amount: 0);

  showCupertinoDialog(
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: const Text('Добавить транзакцию'),
        content: TransactionDialogContent(transactionForm: transactionForm),
        actions: [
          CupertinoDialogAction(
            child: const Text('Отмена'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          CupertinoDialogAction(
            child: const Text('Добавить'),
            onPressed: () {
              if (transactionForm.amount <= 0) return;
              ref
                  .read(transactionProvider.notifier)
                  .addTransaction(transactionForm.toTransaction());
              if (transactionForm.transactionType == 'income') {
                ref.read(balanceProvider.notifier).addMoney(
                    transactionForm.amount, transactionForm.paymentMethod);
              } else if (transactionForm.transactionType == 'expense') {
                ref.read(balanceProvider.notifier).removeMoney(
                    transactionForm.amount, transactionForm.paymentMethod);
              }
              Navigator.of(context).pop();
            },
          )
        ],
      );
    },
  );
}

void showFilterOptions(
  BuildContext context,
  WidgetRef ref,
  Map<String, dynamic> filterActions,
  Function(String) updateFilter,
) {
  showCupertinoModalPopup(
    context: context,
    builder: (_) => CupertinoActionSheet(
      title: const Text('Фильтровать по:'),
      actions: filterActions.entries
          .map((entry) => CupertinoActionSheetAction(
                onPressed: () {
                  updateFilter(entry.key); // Update filter outside of setState
                  Navigator.of(context, rootNavigator: true).pop();
                },
                child: Text(entry.key),
              ))
          .toList(),
      cancelButton: CupertinoActionSheetAction(
        onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
        child: const Text('Отмена'),
      ),
    ),
  );
}
