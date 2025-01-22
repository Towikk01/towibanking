import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:towibanking/core/helpers/functions.dart';
import 'package:towibanking/core/models/category.dart';
import 'package:towibanking/core/models/transaction.dart';
import 'package:towibanking/core/riverpod/currency.dart';
import 'package:towibanking/core/riverpod/language.dart';
import 'package:towibanking/core/riverpod/theme.dart';
import 'package:towibanking/core/riverpod/transaction.dart';
import 'package:intl/intl.dart';
import 'package:towibanking/core/theme/app_colors.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TransactionWidget extends ConsumerWidget {
  final String locale;
  final Transaction transaction;
  final List<Category> categories;

  const TransactionWidget(
      {super.key,
      required this.transaction,
      required this.categories,
      this.locale = 'ru'});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkTheme = ref.watch(themeProvider).brightness == Brightness.dark;
    final currency = ref.watch(currencyProvider)['selectedCurrency'];
    final language = ref.watch(languageNotifierProvider);

    String formattedDate(DateTime date) {
      return DateFormat('d MMM yyyy', language).format(date);
    }

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
                    .removeTransaction(transaction, ref, context);
              },
              backgroundColor: AppColors.secondary,
              foregroundColor: CupertinoColors.white,
              icon: CupertinoIcons.delete,
              label: AppLocalizations.of(context)!.remove,
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
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${transaction.amount.toStringAsFixed(transaction.amount == transaction.amount.toInt() ? 0 : 2)} $currency',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 20,
                      color: isDarkTheme
                          ? AppColors.orange
                          : CupertinoColors.activeGreen,
                    ),
                  ),
                  Text(
                    transaction.category.localTitles?[language] ?? transaction.category.title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      color:
                          isDarkTheme ? AppColors.lightCream : AppColors.black,
                    ),
                  ),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      '${transaction.type == 'income' ? AppLocalizations.of(context)!.income : AppLocalizations.of(context)!.expense} - ${transaction.paymentMethod == 'cash' ? AppLocalizations.of(context)!.cash : AppLocalizations.of(context)!.card}',
                      style: TextStyle(
                          fontSize: 14,
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
