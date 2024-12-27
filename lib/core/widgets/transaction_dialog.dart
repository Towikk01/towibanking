import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:towibanking/core/models/category.dart';
import 'package:towibanking/core/models/transaction.dart';
import 'package:towibanking/core/riverpod/balance.dart';
import 'package:towibanking/core/riverpod/category.dart';
import 'package:towibanking/core/riverpod/transaction.dart';

class TransactionDialogContent extends ConsumerStatefulWidget {
  const TransactionDialogContent({super.key});

  @override
  TransactionDialogContentState createState() =>
      TransactionDialogContentState();
}

class TransactionDialogContentState
    extends ConsumerState<TransactionDialogContent> {
  String _transactionType = 'income';
  String _paymentMethod = 'Наличные';
  Category _selectedCategory = defaultSpendCategories.first;
  double _amount = 0.0;
  final TextEditingController _transactionComment = TextEditingController();

  void submitTransaction() {
    if (_amount <= 0) {
      return;
    }

    final transaction = Transaction(
      amount: _amount,
      type: _transactionType,
      paymentMethod: _paymentMethod,
      category: _selectedCategory,
      date: DateTime.now(),
      comment: _transactionComment.text == '' ? null : _transactionComment.text,
    );

    ref.read(transactionProvider.notifier).addTransaction(transaction);

    if (_transactionType == 'income') {
      ref.read(balanceProvider.notifier).addMoney(_amount, _paymentMethod);
    } else if (_transactionType == 'expense') {
      ref.read(balanceProvider.notifier).removeMoney(_amount, _paymentMethod);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesProvider);
    final currentCategories = _transactionType == 'income'
        ? categories['inc']!
        : categories['spend']!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CupertinoSegmentedControl<String>(
          padding: const EdgeInsets.all(10),
          children: {
            'expense': Container(
                padding: const EdgeInsets.all(10),
                child: const Text('Расход', style: TextStyle(fontSize: 20))),
            'income': Container(
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Приход',
                  style: TextStyle(fontSize: 20),
                )),
          },
          onValueChanged: (value) {
            setState(() {
              _transactionType = value;
              _selectedCategory = _transactionType == 'income'
                  ? defaultIncCategories.first
                  : defaultSpendCategories.first;
            });
          },
          groupValue: _transactionType,
        ),
        const SizedBox(height: 10),
        CupertinoSegmentedControl<String>(
          children: {
            'Наличные': Container(
                padding: const EdgeInsets.all(10),
                child: const Text('Наличные', style: TextStyle(fontSize: 16))),
            'Карта': Container(
                padding: const EdgeInsets.all(10),
                child: const Text('Карта', style: TextStyle(fontSize: 16))),
          },
          onValueChanged: (value) {
            setState(() {
              _paymentMethod = value;
            });
          },
          groupValue: _paymentMethod,
        ),
        const SizedBox(height: 20),
        CupertinoPicker(
          itemExtent: 50,
          onSelectedItemChanged: (index) {
            setState(() {
              _selectedCategory = currentCategories[index];
            });
          },
          children: currentCategories.map((category) {
            return Center(child: Text(category.title));
          }).toList(),
        ),
        const SizedBox(height: 20),
        CupertinoTextField(
          padding: const EdgeInsets.all(20),
          keyboardType: TextInputType.number,
          placeholder: 'Введите сумму',
          onChanged: (value) {
            _amount = double.tryParse(value) ?? 0.0;
          },
        ),
        const SizedBox(height: 20),
        CupertinoTextField(
          padding: const EdgeInsets.all(20),
          keyboardType: TextInputType.text,
          placeholder: 'Введите комментарий',
          controller: _transactionComment,
        ),
        const SizedBox(
          height: 20,
        ),
        CupertinoDialogAction(
          onPressed: submitTransaction,
          child: Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
              decoration: BoxDecoration(
                color: CupertinoColors.activeBlue,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'Добавить',
                style: TextStyle(color: CupertinoColors.white),
              )),
        ),
      ],
    );
  }
}
