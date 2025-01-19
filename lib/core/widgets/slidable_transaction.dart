import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:towibanking/core/helpers/functions.dart';
import 'package:towibanking/core/models/category.dart';
import 'package:towibanking/core/models/transaction.dart';
import 'package:towibanking/core/riverpod/currency.dart';
import 'package:towibanking/core/riverpod/theme.dart';
import 'package:towibanking/core/riverpod/transaction.dart';
import 'package:intl/intl.dart';
import 'package:towibanking/core/theme/app_colors.dart';

class TransactionWidget extends ConsumerWidget {
  final Transaction transaction;
  final List<Category> categories;

  const TransactionWidget(
      {super.key, required this.transaction, required this.categories});

  String formattedDate(DateTime date) {
    return DateFormat('d MMM yyyy', 'ru').format(date);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkTheme = ref.watch(themeProvider).brightness == Brightness.dark;
    final currency = ref.watch(currencyProvider)['selectedCurrency'];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              spacing: 2,
              borderRadius: BorderRadius.circular(16),
              onPressed: (context) {
                ref
                    .watch(transactionProvider.notifier)
                    .removeTransaction(transaction, ref);
              },
              backgroundColor: AppColors.secondary,
              foregroundColor: CupertinoColors.white,
              icon: CupertinoIcons.delete,
              label: 'Удалить',
            ),
          ],
        ),
        child: GestureDetector(
          onTap: () {
            showTransactionDialog(context, ref, categories, transaction);
          },
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: AppColors.secondary, width: 1),
                borderRadius: BorderRadius.circular(16),
                color: isDarkTheme
                    ? AppColors.black
                    : CupertinoColors.systemGrey6),
            child: CupertinoListTile(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              leading: Icon(
                color: transaction.type == 'income'
                    ? CupertinoColors.systemGreen
                    : CupertinoColors.systemRed,
                transaction.category.icon,
                size: 34,
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Icon(
                    color: transaction.type == 'income'
                        ? CupertinoColors.systemGreen
                        : CupertinoColors.systemRed,
                    transaction.type == 'income'
                        ? CupertinoIcons.add_circled
                        : CupertinoIcons.minus_circled,
                    size: 32,
                  ),
                  Text(
                    formattedDate(transaction.date),
                    style: TextStyle(
                        color: isDarkTheme
                            ? AppColors.lightCream
                            : CupertinoColors.activeGreen,
                        fontSize: 16),
                  )
                ],
              ),
              title: Row(
                children: [
                  Text('${transaction.category.title} - ',
                      style: TextStyle(
                          fontSize: 18,
                          color: isDarkTheme
                              ? AppColors.lightCream
                              : AppColors.black)),
                  Text('${transaction.amount.toStringAsFixed(2)} $currency.',
                      style: TextStyle(
                          fontSize: 18,
                          color: isDarkTheme
                              ? AppColors.orange
                              : CupertinoColors.activeGreen)),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      '${transaction.type == 'income' ? 'Приход' : 'Расход'} - ${transaction.paymentMethod}',
                      style: TextStyle(
                          fontSize: 16,
                          color: isDarkTheme
                              ? AppColors.lightCream
                              : AppColors.black)),
                  if (transaction.comment != null)
                    Text(
                      transaction.comment!,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.secondary),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
