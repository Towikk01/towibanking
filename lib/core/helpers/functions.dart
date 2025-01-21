import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:towibanking/core/models/balance.dart';
import 'package:towibanking/core/models/category.dart';
import 'package:towibanking/core/models/transaction.dart';
import 'package:towibanking/core/models/transaction_form.dart';
import 'package:towibanking/core/riverpod/balance.dart';
import 'package:towibanking/core/riverpod/transaction.dart';
import 'package:towibanking/core/widgets/add_transaction.dart';
import 'package:towibanking/core/widgets/balance_modal.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void showCategoriesDialog(
  BuildContext context,
  WidgetRef ref,
  List<Category> categories,
  String selectedCategory, // Current category
  void Function(String) onCategorySelected, // Callback to update
) {
  showCupertinoDialog(
    context: context,
    builder: (BuildContext context) {
      String localSelectedCategory = selectedCategory;
      return StatefulBuilder(
        builder: (context, setState) {
          return CupertinoAlertDialog(
            title: Text(AppLocalizations.of(context)!.categories),
            content: SizedBox(
              height: 200,
              child: CupertinoPicker(
                itemExtent: 50,
                scrollController: FixedExtentScrollController(
                  initialItem: categories.indexWhere(
                    (category) => category.title == localSelectedCategory,
                  ),
                ),
                onSelectedItemChanged: (index) {
                  setState(() {
                    localSelectedCategory = categories[index].title;
                  });
                },
                children: categories.map((category) {
                  return Center(child: Text(category.title));
                }).toList(),
              ),
            ),
            actions: [
              CupertinoDialogAction(
                child: Text(AppLocalizations.of(context)!.cancel),
                onPressed: () {
                  onCategorySelected(AppLocalizations.of(context)!.all);
                  Navigator.of(context).pop();
                },
              ),
              CupertinoDialogAction(
                child: Text(AppLocalizations.of(context)!.change),
                onPressed: () {
                  onCategorySelected(
                      localSelectedCategory); // Update the parent
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    },
  );
}

void showTransactionDialog(BuildContext context, WidgetRef ref,
    List<Category>? categories, Transaction? transaction) {
  final currentCategories =
      categories!.where((el) => el.type == 'expense').toList();

  final TransactionForm transactionForm = transaction != null
      ? transaction.toTransactionForm()
      : TransactionForm(
          amount: 0,
          date: DateTime.now(),
          selectedCategory: currentCategories[0],
          transactionType: 'expense',
          paymentMethod: 'cash',
        );

  showCupertinoDialog(
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: Text(AppLocalizations.of(context)!.addTransaction),
        content: TransactionDialogContent(
          transactionForm: transactionForm,
          categories: categories,
        ),
        actions: [
          CupertinoDialogAction(
            child: Text(AppLocalizations.of(context)!.cancel),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          if (transaction == null)
            CupertinoDialogAction(
              child: Text(AppLocalizations.of(context)!.add),
              onPressed: () {
                if (transactionForm.amount <= 0) return;
                ref.watch(transactionProvider.notifier).addTransaction(
                    transactionForm.toTransaction(), ref, context);

                Navigator.of(context).pop();
              },
            ),
          if (transaction != null)
            CupertinoDialogAction(
              child: Text(AppLocalizations.of(context)!.change),
              onPressed: () {
                if (transactionForm.amount <= 0) return;
                ref.watch(transactionProvider.notifier).changeTransaction(
                    transaction, transactionForm.toTransaction(), ref, context);
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
      title: Text(AppLocalizations.of(context)!.filter),
      actions: filterActions.entries
          .map((entry) => CupertinoActionSheetAction(
                onPressed: () {
                  updateFilter(entry.key);
                  Navigator.of(context, rootNavigator: true).pop();
                },
                child: Text(entry.key),
              ))
          .toList(),
      cancelButton: CupertinoActionSheetAction(
        onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
        child: Text(AppLocalizations.of(context)!.cancel),
      ),
    ),
  );
}

void showBalanceDialog(BuildContext context, Balance balance, WidgetRef ref) {
  final balanceNotifier = ref.watch(balanceProvider.notifier);
  showCupertinoDialog(
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: Text(AppLocalizations.of(context)!.balance,
            style: const TextStyle(fontSize: 22)),
        content: BalanceModal(balance: balance),
        actions: [
          CupertinoDialogAction(
            child: Text(AppLocalizations.of(context)!.cancel),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          CupertinoDialogAction(
            child: Text(AppLocalizations.of(context)!.change),
            onPressed: () {
              balanceNotifier.updateBalance(balance.cash, balance.card);
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
