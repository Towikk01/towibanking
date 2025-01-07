// transaction_dialog.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:towibanking/core/models/transaction_form.dart';
import 'package:towibanking/core/riverpod/category.dart';

class TransactionDialogContent extends ConsumerStatefulWidget {
  final TransactionForm transactionForm;
  const TransactionDialogContent({super.key, required this.transactionForm});

  @override
  TransactionDialogContentState createState() =>
      TransactionDialogContentState();
}

class TransactionDialogContentState
    extends ConsumerState<TransactionDialogContent> {
  final TextEditingController _transactionComment = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final form = widget.transactionForm;
    final categories = ref.watch(unifiedCategoriesProvider);
    final currentCategories = widget.transactionForm.transactionType == 'income'
        ? categories.where((el) => el.type == 'income').toList()
        : categories.where((el) => el.type == 'expense').toList();
    print(categories.where((el) => el.type == 'income').toList());

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
              form.transactionType = value;
              form.selectedCategory = form.transactionType == 'income'
                  ? defaultCategories.where((el) => el.type == 'income').first
                  : defaultCategories.where((el) => el.type == 'expense').first;
            });
          },
          groupValue: form.transactionType,
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
              form.paymentMethod = value;
            });
          },
          groupValue: form.paymentMethod,
        ),
        const SizedBox(height: 10),
        CupertinoButton(
          child: Text(
            '${form.date!.month}-${form.date!.day}-${form.date!.year}',
            style: const TextStyle(
              fontSize: 20.0,
            ),
          ),
          onPressed: () async {
            final DateTime? selectedDate =
                await showCupertinoModalPopup<DateTime>(
              context: context,
              builder: (BuildContext context) {
                DateTime tempPickedDate = form.date!;
                return Container(
                  height: 250,
                  color: CupertinoColors.white,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 190,
                        child: CupertinoDatePicker(
                          mode: CupertinoDatePickerMode.date,
                          initialDateTime: form.date,
                          onDateTimeChanged: (DateTime newDate) {
                            tempPickedDate = newDate;
                          },
                        ),
                      ),
                      CupertinoButton(
                        child: const Text('Выбрать'),
                        onPressed: () {
                          Navigator.pop(context, tempPickedDate);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
            if (selectedDate != null) {
              setState(() {
                form.date = selectedDate;
              });
            }
          },
        ),
        const SizedBox(height: 10),
        CupertinoPicker(
          itemExtent: 50,
          onSelectedItemChanged: (index) {
            setState(() {
              form.selectedCategory = currentCategories[index];
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
          placeholder: 'Хау мач',
          onChanged: (value) {
            form.amount = double.tryParse(value) ?? 0;
          },
        ),
        const SizedBox(height: 20),
        CupertinoTextField(
          padding: const EdgeInsets.all(20),
          keyboardType: TextInputType.text,
          placeholder: 'Можно комментик',
          controller: _transactionComment,
          onChanged: (value) {
            form.comment = value;
          },
        ),
      ],
    );
  }
}