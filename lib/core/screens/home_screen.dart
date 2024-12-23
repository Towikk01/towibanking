import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:towibanking/core/riverpod/balance.dart';
import 'package:towibanking/core/riverpod/transaction.dart';
import 'package:towibanking/core/widgets/transaction_dialog.dart';

class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balance = ref.watch(balanceProvider);
    final transactions = ref.watch(transactionProvider);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle:
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Text('Наличные: ${balance.cash}', style: TextStyle(fontSize: 16)),
          Text('Общий: ${balance.cash + balance.card}',
              style: TextStyle(fontSize: 16)),
          Text('Карта: ${balance.card}', style: TextStyle(fontSize: 16))
        ]),
      ),
      child: Stack(
        children: [
          Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              const Text('Последние транзакции',
                  style: TextStyle(fontSize: 24)),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) =>
                      Container(height: 1, color: CupertinoColors.systemGrey4),
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = transactions[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: transaction.type == 'income'
                            ? CupertinoColors.systemGreen
                            : CupertinoColors.systemGrey6,
                      ),
                      child: CupertinoListTile(
                        padding: const EdgeInsets.all(16),
                        leading: Icon(transaction.type == 'income'
                            ? CupertinoIcons.plus
                            : CupertinoIcons.minus),
                        title: Text(
                            '${transaction.type == 'income' ? 'Приход' : 'Расход'} - \$${transaction.amount.toStringAsFixed(2)}'),
                        subtitle: Text(
                            '${transaction.category} - ${transaction.paymentMethod}'),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: CupertinoButton.filled(
              padding: EdgeInsets.all(16),
              child: Icon(CupertinoIcons.add),
              onPressed: () {
                _showTransactionDialog(context, ref);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showTransactionDialog(BuildContext context, WidgetRef ref) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Добавить транзакцию'),
          content: TransactionDialogContent(),
        );
      },
    );
  }
}
