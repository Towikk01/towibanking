import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:towibanking/core/models/category.dart';
import 'package:towibanking/core/models/transaction.dart';
import 'package:towibanking/core/riverpod/theme.dart';
import 'package:towibanking/core/theme/app_colors.dart';
import 'package:towibanking/core/widgets/slidable_transaction.dart';
import 'package:intl/intl.dart';

class ListTransactions extends ConsumerWidget {
  final List<Transaction> filteredTransactions;
  final List<Category> categories;

  const ListTransactions({
    super.key,
    required this.filteredTransactions,
    required this.categories,
  });

  List<Map<String, dynamic>> groupTransactionsByDay(
      List<Transaction> transactions) {
    DateTime now = DateTime.now();
    DateFormat dateFormat = DateFormat('yyyy-MM-dd', 'ru');

    String getDateLabel(DateTime date) {
      if (dateFormat.format(date) == dateFormat.format(now)) {
        return 'Сегодня';
      } else if (dateFormat.format(date) ==
          dateFormat.format(now.subtract(const Duration(days: 1)))) {
        return 'Вчера';
      } else {
        return DateFormat('dd MMMM, yyyy', 'ru').format(date);
      }
    }

    transactions.sort((a, b) => b.date.compareTo(a.date));

    final groupedTransactions = <Map<String, dynamic>>[];
    final dailyTotals = <String, Map<String, double>>{};

    String? lastDateLabel;
    for (var transaction in transactions) {
      String currentDateLabel = getDateLabel(transaction.date);

      dailyTotals.putIfAbsent(
          currentDateLabel, () => {'income': 0.0, 'expense': 0.0});
      if (transaction.type == 'income') {
        dailyTotals[currentDateLabel]!['income'] =
            (dailyTotals[currentDateLabel]!['income'] ?? 0.0) +
                transaction.amount;
      } else {
        dailyTotals[currentDateLabel]!['expense'] =
            (dailyTotals[currentDateLabel]!['expense'] ?? 0.0) +
                transaction.amount.abs();
      }

      if (currentDateLabel != lastDateLabel) {
        groupedTransactions.add({
          'isHeader': true,
          'label': currentDateLabel,
          'totals': dailyTotals[currentDateLabel]
        });
        lastDateLabel = currentDateLabel;
      }

      groupedTransactions.add({'isHeader': false, 'transaction': transaction});
    }

    return groupedTransactions;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupedTransactions = groupTransactionsByDay(filteredTransactions);
    final isDarkTheme = ref.watch(themeProvider).brightness == Brightness.dark;

    return SizedBox(
      height: 500,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: groupedTransactions.length,
          itemBuilder: (context, index) {
            final item = groupedTransactions[index];

            if (item['isHeader']) {
              final totals = item['totals'] as Map<String, double>;
              final income = totals['income'] ?? 0.0;
              final expense = totals['expense'] ?? 0.0;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item['label'] as String,
                      style: TextStyle(
                        color: isDarkTheme
                            ? AppColors.lightCream
                            : AppColors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '+${income.toStringAsFixed(income.toInt() == income ? 0 : 2)} / -${expense.toStringAsFixed(expense.toInt() == expense ? 0 : 2)}',
                      style: TextStyle(
                        color: isDarkTheme
                            ? AppColors.lightCream
                            : AppColors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              final transaction = item['transaction'] as Transaction;
              return TransactionWidget(
                  transaction: transaction, categories: categories);
            }
          },
        ),
      ),
    );
  }
}
