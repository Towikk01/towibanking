import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:towibanking/core/models/transaction.dart';
import 'package:towibanking/core/riverpod/balance.dart';
import 'package:towibanking/core/riverpod/transaction.dart';
import 'package:intl/intl.dart';

class TransactionWidget extends ConsumerWidget {
  final Transaction transaction;

  const TransactionWidget({super.key, required this.transaction});

  String formattedDate(DateTime date) {
    return DateFormat('dd-MM-yy').format(date);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void removeTransaction() {
      ref.read(transactionProvider.notifier).removeTransaction(transaction);
      if (transaction.type == 'income') {
        ref
            .read(balanceProvider.notifier)
            .removeMoney(transaction.amount, transaction.paymentMethod);
      } else if (transaction.type == 'expense') {
        ref
            .read(balanceProvider.notifier)
            .addMoney(transaction.amount, transaction.paymentMethod);
      }
    }

    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => removeTransaction(),
            backgroundColor: const Color.fromARGB(255, 205, 50, 42),
            foregroundColor: CupertinoColors.white,
            icon: CupertinoIcons.delete,
            label: 'Удалить',
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          color: transaction.type == 'income'
              ? Color.fromARGB(170, 137, 236, 209)
              : CupertinoColors.systemGrey6,
        ),
        child: CupertinoListTile(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          leading: Icon(
            color: transaction.type == 'income'
                ? CupertinoColors.systemBlue
                : CupertinoColors.systemRed,
            transaction.category.icon,
            size: 34,
          ),
          trailing: Column(
            children: [
              Icon(
                color: transaction.type == 'income'
                    ? CupertinoColors.systemBlue
                    : CupertinoColors.systemRed,
                transaction.type == 'income'
                    ? CupertinoIcons.add_circled
                    : CupertinoIcons.minus_circled,
                size: 44,
              ),
              Text(formattedDate(transaction.date))
            ],
          ),
          title: Text(
              '${transaction.category.title} - ${transaction.amount.toStringAsFixed(2)} грн.',
              style: const TextStyle(fontSize: 18)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  '${transaction.type == 'income' ? 'Приход' : 'Расход'} - ${transaction.paymentMethod}',
                  style: const TextStyle(fontSize: 16)),
              if (transaction.comment != null)
                Text(
                  transaction.comment!,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
