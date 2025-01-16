import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:towibanking/core/models/category.dart';
import 'package:towibanking/core/models/transaction.dart';
import 'package:towibanking/core/models/transaction_form.dart';
import 'package:towibanking/core/riverpod/transaction.dart';
import 'package:towibanking/core/widgets/add_transaction.dart';

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
            title: const Text('Категории'),
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
                  print(localSelectedCategory);
                },
                children: categories.map((category) {
                  return Center(child: Text(category.title));
                }).toList(),
              ),
            ),
            actions: [
              CupertinoDialogAction(
                child: const Text('Закрыть'),
                onPressed: () {
                  onCategorySelected('Все');
                  Navigator.of(context).pop();
                },
              ),
              CupertinoDialogAction(
                child: const Text('Применить'),
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
          paymentMethod: 'Карта',
        );

  showCupertinoDialog(
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: const Text('Добавить транзакцию'),
        content: TransactionDialogContent(
          transactionForm: transactionForm,
          categories: categories,
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text('Отмена'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          if (transaction == null)
            CupertinoDialogAction(
              child: const Text('Добавить'),
              onPressed: () {
                if (transactionForm.amount <= 0) return;
                ref
                    .watch(transactionProvider.notifier)
                    .addTransaction(transactionForm.toTransaction(), ref);

                Navigator.of(context).pop();
              },
            ),
          if (transaction != null)
            CupertinoDialogAction(
              child: const Text('Изменить'),
              onPressed: () {
                if (transactionForm.amount <= 0) return;
                ref.watch(transactionProvider.notifier).changeTransaction(
                    transaction, transactionForm.toTransaction(), ref);
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
                  updateFilter(entry.key);
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
