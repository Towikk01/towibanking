import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:towibanking/core/models/transaction.dart';
import 'package:towibanking/core/models/transaction_form.dart';
import 'package:towibanking/core/riverpod/balance.dart';
import 'package:towibanking/core/riverpod/category.dart';
import 'package:towibanking/core/riverpod/transaction.dart';
import 'package:towibanking/core/widgets/transaction_dialog.dart';
import 'package:towibanking/core/widgets/transaction_widget.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String currentFilter = 'Все';

  void _showFilterOptions(
    BuildContext context,
    WidgetRef ref,
    Map<String, Function> filterActions,
  ) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => CupertinoActionSheet(
        title: const Text('Фильтровать по:'),
        actions: filterActions.entries
            .map((entry) => CupertinoActionSheetAction(
                  onPressed: () {
                    setState(() {
                      currentFilter = entry.key;
                    });
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  child: Text(entry.key),
                ))
            .toList(),
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          child: const Text('Отмена'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final balance = ref.watch(balanceProvider);
    final transactions = ref.watch(transactionProvider);
    final filterActions = {
      'Только доходы': (List<Transaction> transactions) =>
          transactions.where((el) => el.type == 'income').toList(),
      'Только расходы': (List<Transaction> transactions) =>
          transactions.where((el) => el.type == 'expense').toList(),
      'По дате': (List<Transaction> transactions) {
        transactions.sort((a, b) => a.date.compareTo(b.date));
        return transactions;
      },
      'По категории': (List<Transaction> transactions) =>
          transactions.where((el) => el.category == 'category').toList(),
      'Все': (List<Transaction> transactions) => transactions,
    };

    var filteredTransactions = filterActions[currentFilter]!(transactions);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle:
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Наличные',
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              Text(
                '${balance.cash}',
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Карта:',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              Text(
                '${balance.card}',
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Общий:',
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              Text(
                '${balance.cash + balance.card}',
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ]),
      ),
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Text(
                          'Последние транзакции',
                          style: TextStyle(fontSize: 22),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      if (transactions.isNotEmpty)
                        CupertinoButton(
                          borderRadius: BorderRadius.zero,
                          child: const Icon(CupertinoIcons.list_bullet_indent),
                          onPressed: () => _showFilterOptions(
                            context,
                            ref,
                            filterActions,
                          ),
                        ),
                    ],
                  ),
                ),
                transactions.isNotEmpty
                    ? Expanded(
                        child: ListView.separated(
                          separatorBuilder: (context, index) => Container(
                              height: 1, color: CupertinoColors.black),
                          itemCount: filteredTransactions.length,
                          itemBuilder: (context, index) {
                            final transaction = filteredTransactions[index];
                            return TransactionWidget(transaction: transaction);
                          },
                        ),
                      )
                    : const Text('Еще нет транзакций...',
                        style: TextStyle(fontSize: 16))
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: CupertinoButton.filled(
              borderRadius: BorderRadius.circular(30),
              padding: const EdgeInsets.all(16),
              child: const Icon(CupertinoIcons.add),
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
    final TransactionForm transactionForm = TransactionForm(
        transactionType: 'income',
        paymentMethod: 'Наличные',
        selectedCategory: defaultIncCategories.first,
        date: DateTime.now(),
        amount: 0);

    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Добавить транзакцию'),
          content: TransactionDialogContent(transactionForm: transactionForm),
          actions: [
            CupertinoDialogAction(
              child: const Text('Отмена'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: const Text('Добавить'),
              onPressed: () {
                ref
                    .read(transactionProvider.notifier)
                    .addTransaction(transactionForm.toTransaction());
                if (transactionForm.transactionType == 'income') {
                  ref.read(balanceProvider.notifier).addMoney(
                      transactionForm.amount, transactionForm.paymentMethod);
                } else if (transactionForm.transactionType == 'expense') {
                  ref.read(balanceProvider.notifier).removeMoney(
                      transactionForm.amount, transactionForm.paymentMethod);
                }
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
}
