import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:towibanking/core/models/transaction.dart';
import 'package:towibanking/core/riverpod/balance.dart';
import 'package:towibanking/core/riverpod/transaction.dart';

class TransactionWidget extends ConsumerWidget {
  final Transaction transaction;

  const TransactionWidget({super.key, required this.transaction});

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
            backgroundColor: CupertinoColors.destructiveRed,
            foregroundColor: CupertinoColors.white,
            icon: CupertinoIcons.delete,
            label: 'Удалить',
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          color: transaction.type == 'income'
              ? CupertinoColors.systemGreen
              : CupertinoColors.systemGrey6,
        ),
        child: CupertinoListTile(
          padding: const EdgeInsets.all(16),
          leading: Icon(
            color: transaction.type == 'income'
                ? CupertinoColors.systemBlue
                : CupertinoColors.systemRed,
            transaction.category.icon,
            size: 34,
          ),
          trailing: Icon(
            color: transaction.type == 'income'
                ? CupertinoColors.systemBlue
                : CupertinoColors.systemRed,
            transaction.type == 'income'
                ? CupertinoIcons.add_circled
                : CupertinoIcons.minus_circled,
            size: 44,
          ),
          title: Text(
              '${transaction.category.title} - ${transaction.amount.toStringAsFixed(2)} грн.'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  '${transaction.type == 'income' ? 'Приход' : 'Расход'} - ${transaction.paymentMethod}'),
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
