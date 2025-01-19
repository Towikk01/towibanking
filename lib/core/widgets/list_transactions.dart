import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:towibanking/core/models/category.dart';
import 'package:towibanking/core/models/transaction.dart';
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
        return DateFormat('MMMM dd, yyyy', 'ru').format(date);
      }
    }

    // Sort transactions by date in descending order
    transactions.sort((a, b) => b.date.compareTo(a.date));

    final groupedTransactions = <Map<String, dynamic>>[];

    String? lastDateLabel;
    for (var transaction in transactions) {
      String currentDateLabel = getDateLabel(transaction.date);

      // Add a new header if it's a new group
      if (currentDateLabel != lastDateLabel) {
        groupedTransactions.add({'isHeader': true, 'label': currentDateLabel});
        lastDateLabel = currentDateLabel;
      }

      // Add the transaction under the current group
      groupedTransactions.add({'isHeader': false, 'transaction': transaction});
    }

    return groupedTransactions;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupedTransactions = groupTransactionsByDay(filteredTransactions);

    return SizedBox(
      height: 500,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: groupedTransactions.length,
          itemBuilder: (context, index) {
            final item = groupedTransactions[index];

            // Render headers or transactions
            if (item['isHeader']) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  item['label'] as String,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
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
