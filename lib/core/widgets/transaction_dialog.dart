import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:towibanking/core/models/transaction.dart';
import 'package:towibanking/core/riverpod/balance.dart';
import 'package:towibanking/core/riverpod/transaction.dart';

class TransactionDialogContent extends ConsumerStatefulWidget {
  const TransactionDialogContent({super.key});

  @override
  _TransactionDialogContentState createState() =>
      _TransactionDialogContentState();
}

class _TransactionDialogContentState
    extends ConsumerState<TransactionDialogContent> {
  String _transactionType = 'income';
  String _paymentMethod = 'cash';
  String _selectedCategory = 'Food';
  double _amount = 0.0;

  void _submitTransaction() {
    if (_amount <= 0) {
      // Optional: Show an error message or return
      return;
    }

    // Create a new transaction object
    final transaction = Transaction(
      amount: _amount,
      type: _transactionType,
      paymentMethod: _paymentMethod,
      category: _selectedCategory,
      date: DateTime.now(),
    );

    // Add the transaction to the transaction provider
    ref.read(transactionProvider.notifier).addTransaction(transaction);

    // Update the balance provider
    if (_transactionType == 'income') {
      ref.read(balanceProvider.notifier).addMoney(_amount, _paymentMethod);
    } else if (_transactionType == 'expense') {
      ref.read(balanceProvider.notifier).removeMoney(_amount, _paymentMethod);
    }

    // Close the dialog
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Transaction type selection (Income/Expense)
        CupertinoSegmentedControl<String>(
          children: const {
            'income': Text('Приход'),
            'expense': Text('Расход'),
          },
          onValueChanged: (value) {
            setState(() {
              _transactionType = value;
            });
          },
          groupValue: _transactionType,
        ),
        const SizedBox(height: 10),

        // Payment method selection (Cash/Card)
        CupertinoSegmentedControl<String>(
          children: const {
            'cash': Text('Наличные'),
            'card': Text('Карта'),
          },
          onValueChanged: (value) {
            setState(() {
              _paymentMethod = value;
            });
          },
          groupValue: _paymentMethod,
        ),
        const SizedBox(height: 10),

        // Category picker
        CupertinoPicker(
          itemExtent: 30,
          onSelectedItemChanged: (index) {
            setState(() {
              _selectedCategory = ['Food', 'Home', 'Transport'][index];
            });
          },
          children: ['Food', 'Home', 'Transport'].map((category) {
            return Text(category);
          }).toList(),
        ),
        const SizedBox(height: 10),

        // Amount input
        CupertinoTextField(
          keyboardType: TextInputType.number,
          placeholder: 'Введите сумму',
          onChanged: (value) {
            _amount = double.tryParse(value) ?? 0.0;
          },
        ),
        const SizedBox(height: 20),

        // Submit button
        CupertinoDialogAction(
          onPressed: _submitTransaction,
          child: const Text('Добавить'),
        ),
      ],
    );
  }
}
