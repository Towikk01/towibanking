// transaction_dialog.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:towibanking/core/models/category.dart';
import 'package:towibanking/core/models/transaction_form.dart';
import 'package:towibanking/core/riverpod/category.dart';

class TransactionDialogContent extends ConsumerStatefulWidget {
  final TransactionForm transactionForm;
  final List<Category> categories;
  const TransactionDialogContent(
      {super.key, required this.transactionForm, required this.categories});

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
    final currentCategories =
        categories.where((el) => el.type == form.transactionType).toList();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CupertinoSegmentedControl<String>(
            padding: const EdgeInsets.all(10),
            children: {
              'expense': Container(
                  padding: const EdgeInsets.all(10),
                  child: const Text('Расход', style: TextStyle(fontSize: 22))),
              'income': Container(
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'Приход',
                    style: TextStyle(fontSize: 22),
                  )),
            },
            onValueChanged: (value) {
              setState(() {
                form.transactionType = value;
                form.selectedCategory = categories
                    .where((el) =>
                        el.type == widget.transactionForm.transactionType)
                    .first;
              });
            },
            groupValue: form.transactionType),
        const SizedBox(height: 5),
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
                  color: CupertinoColors.black,
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
          scrollController: FixedExtentScrollController(
            initialItem: currentCategories.indexWhere(
              (category) => category.title == form.selectedCategory.title,
            ),
          ),
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
          placeholder:
              form.amount == 0.0 ? 'Введите сумму' : form.amount.toString(),
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
