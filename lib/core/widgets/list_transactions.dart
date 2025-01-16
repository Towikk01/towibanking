import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:towibanking/core/models/category.dart';
import 'package:towibanking/core/models/transaction.dart';
import 'package:towibanking/core/widgets/slidable_transaction.dart';

class ListTransactions extends ConsumerWidget {
  final List<Transaction> filteredTransactions;
  final List<Transaction> transactions;
  final List<Category> categories;
  const ListTransactions(
      {super.key,
      required this.categories,
      required this.filteredTransactions,
      required this.transactions});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 500,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.separated(
          separatorBuilder: (context, index) => Container(
            height: 8,
            color: CupertinoColors.transparent,
          ),
          itemCount: filteredTransactions.length,
          itemBuilder: (context, index) {
            final transaction = filteredTransactions[index];
            return TransactionWidget(
                transaction: transaction, categories: categories);
          },
        ),
      ),
    );
  }
}
