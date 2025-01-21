// transaction_dialog.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:towibanking/core/models/category.dart';
import 'package:towibanking/core/models/transaction_form.dart';
import 'package:towibanking/core/riverpod/category.dart';
import 'package:towibanking/core/riverpod/theme.dart';
import 'package:towibanking/core/theme/app_colors.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  @override
  Widget build(BuildContext context) {
    final isDarkTheme = ref.watch(themeProvider).brightness == Brightness.dark;

    final form = widget.transactionForm;
    final categories = ref.watch(unifiedCategoriesProvider);
    final currentCategories =
        categories.where((el) => el.type == form.transactionType).toList();
    final TextEditingController transactionComment =
        TextEditingController(text: form.comment);
    final TextEditingController transactionAmount = TextEditingController(
        text: form.amount == 0
            ? null
            : form.amount
                .toStringAsFixed(form.amount.toInt() == form.amount ? 0 : 2));

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          width: double.infinity,
          child: CupertinoSegmentedControl<String>(
              children: {
                'expense': Container(
                    padding: const EdgeInsets.all(10),
                    child: Text(AppLocalizations.of(context)!.expense,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 16))),
                'income': Container(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      AppLocalizations.of(context)!.income,
                      style: const TextStyle(fontSize: 16),
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
                print(form.transactionType);
              },
              groupValue: form.transactionType),
        ),
        const SizedBox(height: 15),
        SizedBox(
          width: double.infinity,
          child: CupertinoSegmentedControl<String>(
            children: {
              'cash': Container(
                  padding: const EdgeInsets.all(10),
                  child: Text(AppLocalizations.of(context)!.cash,
                      style: const TextStyle(fontSize: 16))),
              'card': Container(
                  padding: const EdgeInsets.all(10),
                  child: Text(AppLocalizations.of(context)!.card,
                      style: const TextStyle(fontSize: 16))),
            },
            onValueChanged: (value) {
              setState(() {
                form.paymentMethod = value;
              });
            },
            groupValue: form.paymentMethod,
          ),
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
                  color: isDarkTheme
                      ? CupertinoColors.black
                      : AppColors.lightCream,
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
                        child: Text(AppLocalizations.of(context)!.ok),
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
          placeholder: AppLocalizations.of(context)!.enterAmount,
          controller: transactionAmount,
          onChanged: (value) {
            form.amount = double.tryParse(value) ?? 0;
          },
        ),
        const SizedBox(height: 20),
        CupertinoTextField(
          padding: const EdgeInsets.all(20),
          keyboardType: TextInputType.text,
          placeholder: AppLocalizations.of(context)!.comment,
          controller: transactionComment,
          onChanged: (value) {
            form.comment = value;
          },
        ),
      ],
    );
  }
}
