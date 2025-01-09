import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:towibanking/core/models/transaction.dart';

import 'package:towibanking/core/riverpod/balance.dart';
import 'package:towibanking/core/riverpod/category.dart';

import 'package:towibanking/core/riverpod/transaction.dart';
import 'package:towibanking/core/theme/app_colors.dart';

import 'package:towibanking/core/widgets/slidable_transaction.dart';
import 'package:towibanking/core/helpers/functions.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String currentFilter = 'Все';
  String filterByDate = 'Все';
  DateTime customDate = DateTime.parse('2024-12-30');

  @override
  Widget build(BuildContext context) {
    final balance = ref.watch(balanceProvider);
    final transactions = ref.watch(transactionProvider);
    final categories = ref.watch(unifiedCategoriesProvider);
    final filterForDate = {
      'Все': (List<Transaction> transactions) => transactions,
      'Выбранная дата': (List<Transaction> transactions) => transactions
          .where((el) =>
              el.date.day == customDate.day &&
              el.date.month == customDate.month &&
              el.date.year == customDate.year)
          .toList(),
      'Сегодня': (List<Transaction> transactions) => transactions
          .where((el) =>
              el.date.day == DateTime.now().day &&
              el.date.month == DateTime.now().month &&
              el.date.year == DateTime.now().year)
          .toList(),
      'Последние 7 дней': (List<Transaction> transactions) => transactions
          .where((el) =>
              el.date.isAfter(DateTime.now().subtract(const Duration(days: 7))))
          .toList(),
      'Последний месяц': (List<Transaction> transactions) => transactions
          .where((el) => el.date
              .isAfter(DateTime.now().subtract(const Duration(days: 30))))
          .toList(),
      'Последние полгода': (List<Transaction> transactions) => transactions
          .where((el) => el.date
              .isAfter(DateTime.now().subtract(const Duration(days: 180))))
          .toList(),
      'Последний год': (List<Transaction> transactions) => transactions
          .where((el) => el.date
              .isAfter(DateTime.now().subtract(const Duration(days: 365))))
          .toList(),
    };
    final filterActions = {
      'Только доходы': (List<Transaction> transactions) =>
          transactions.where((el) => el.type == 'income').toList(),
      'Только расходы': (List<Transaction> transactions) =>
          transactions.where((el) => el.type == 'expense').toList(),
      'Все': (List<Transaction> transactions) => transactions,
    };

    var filteredTransactions = filterActions[currentFilter]!(transactions);
    filteredTransactions = filterForDate[filterByDate]!(filteredTransactions);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        border: const Border(
            bottom: BorderSide(color: CupertinoColors.separator, width: 1)),
        middle:
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Наличные:',
                style: TextStyle(fontSize: 16, color: AppColors.lightCream),
                textAlign: TextAlign.center,
              ),
              Text(
                '${balance.cash}',
                style: const TextStyle(fontSize: 16, color: AppColors.orange),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Карта:',
                style: TextStyle(fontSize: 16, color: AppColors.lightCream),
                textAlign: TextAlign.center,
              ),
              Text(
                '${balance.card}',
                style: const TextStyle(fontSize: 16, color: AppColors.orange),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Общий:',
                style: TextStyle(fontSize: 16, color: AppColors.lightCream),
                textAlign: TextAlign.center,
              ),
              Text(
                '${balance.cash + balance.card}',
                style: const TextStyle(fontSize: 16, color: AppColors.orange),
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
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Text(
                          'Последние транзакции',
                          style: TextStyle(fontSize: 26),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      if (transactions.isNotEmpty)
                        CupertinoButton(
                          alignment: Alignment.bottomLeft,
                          sizeStyle: CupertinoButtonSize.medium,
                          borderRadius: BorderRadius.zero,
                          child: const Icon(CupertinoIcons.list_bullet_indent),
                          onPressed: () => showFilterOptions(
                              context, ref, filterActions, (String newFilter) {
                            setState(() {
                              currentFilter = newFilter;
                            });
                          }),
                        ),
                    ],
                  ),
                ),
                if (transactions.isNotEmpty)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      spacing: 0,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: filterForDate.entries.map((entry) {
                        return CupertinoButton(
                          sizeStyle: CupertinoButtonSize.medium,
                          child: Text(entry.key,
                              style: TextStyle(
                                  color: filterByDate == entry.key
                                      ? AppColors.lightCream
                                      : AppColors.secondary)),
                          onPressed: () {
                            setState(() {
                              filterByDate = entry.key;
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                const SizedBox(height: 5),
                if (transactions.isNotEmpty)
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.orange),
                    height: 50,
                    width: 300,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CupertinoDatePicker(
                        itemExtent: 50,
                        backgroundColor: AppColors.orange,
                        mode: CupertinoDatePickerMode.date,
                        initialDateTime: DateTime.now(),
                        onDateTimeChanged: (DateTime newDate) {
                          customDate = newDate;
                        },
                      ),
                    ),
                  ),
                const SizedBox(
                  height: 10,
                ),
                filteredTransactions.isNotEmpty
                    ? Expanded(
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
                                  transaction: transaction);
                            },
                          ),
                        ),
                      )
                    : transactions.isNotEmpty
                        ? const Text('Нет транзакций по фильтру...',
                            style: TextStyle(
                                fontSize: 24, color: AppColors.orange))
                        : const Text('Еще нет транзакций...',
                            style: TextStyle(
                                fontSize: 24, color: AppColors.orange))
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: CupertinoButton.filled(
              borderRadius: BorderRadius.circular(30),
              padding: const EdgeInsets.all(16),
              child: const Icon(
                CupertinoIcons.add,
                color: AppColors.lightCream,
              ),
              onPressed: () {
                showTransactionDialog(context, ref, categories);
              },
            ),
          ),
        ],
      ),
    );
  }
}
