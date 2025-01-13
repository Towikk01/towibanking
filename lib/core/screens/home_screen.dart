import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:towibanking/core/models/transaction.dart';

import 'package:towibanking/core/riverpod/balance.dart';
import 'package:towibanking/core/riverpod/category.dart';
import 'package:towibanking/core/riverpod/theme.dart';

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
  DateTime customDate = DateTime.now();
  String selectedCategory = 'Все';

  @override
  Widget build(BuildContext context) {
    final balance = ref.watch(balanceProvider);
    final transactions = ref.watch(transactionProvider);
    final categories = ref.watch(unifiedCategoriesProvider);
    final isDarkTheme = ref.watch(themeProvider).brightness == Brightness.dark;

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

    if (selectedCategory != 'Все') {
      filteredTransactions = filteredTransactions
          .where(
              (transaction) => transaction.category.title == selectedCategory)
          .toList();
    }

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        border: const Border(
            bottom: BorderSide(color: CupertinoColors.separator, width: 1)),
        middle:
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Наличные:',
                style: TextStyle(
                    fontSize: 16,
                    color:
                        isDarkTheme ? AppColors.lightCream : AppColors.black),
                textAlign: TextAlign.center,
              ),
              Text(
                '${balance.cash}',
                style: TextStyle(
                    fontSize: 16,
                    color: isDarkTheme ? AppColors.orange : AppColors.mint),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Карта:',
                style: TextStyle(
                    fontSize: 16,
                    color:
                        isDarkTheme ? AppColors.lightCream : AppColors.black),
                textAlign: TextAlign.center,
              ),
              Text(
                '${balance.card}',
                style: TextStyle(
                    fontSize: 16,
                    color: isDarkTheme ? AppColors.orange : AppColors.mint),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Общий:',
                style: TextStyle(
                    fontSize: 16,
                    color:
                        isDarkTheme ? AppColors.lightCream : AppColors.black),
                textAlign: TextAlign.center,
              ),
              Text(
                '${balance.cash + balance.card}',
                style: TextStyle(
                    fontSize: 16,
                    color: isDarkTheme ? AppColors.orange : AppColors.mint),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ]),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (transactions.isNotEmpty)
                          CupertinoButton(
                            alignment: Alignment.bottomLeft,
                            sizeStyle: CupertinoButtonSize.medium,
                            borderRadius: BorderRadius.zero,
                            child: const Icon(Icons.category_rounded),
                            onPressed: () {
                              showCategoriesDialog(
                                context,
                                ref,
                                categories,
                                selectedCategory, // Pass the current value
                                (String newCategory) {
                                  // Callback to handle selection
                                  setState(() {
                                    selectedCategory =
                                        newCategory; // Update state here
                                  });
                                },
                              );
                            },
                          ),
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
                            child:
                                const Icon(CupertinoIcons.list_bullet_indent),
                            onPressed: () =>
                                showFilterOptions(context, ref, filterActions,
                                    (String newFilter) {
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
                                        ? (isDarkTheme
                                            ? AppColors.lightCream
                                            : AppColors.black)
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
                          color: isDarkTheme
                              ? AppColors.orange
                              : AppColors.lightCream),
                      height: 50,
                      width: 300,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CupertinoDatePicker(
                          itemExtent: 50,
                          backgroundColor: isDarkTheme
                              ? AppColors.orange
                              : AppColors.lightCream,
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
                      ? Container(
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
                                final transaction = transactions[index];
                                return TransactionWidget(
                                    transaction: transaction,
                                    categories: categories);
                              },
                            ),
                          ),
                        )
                      : transactions.isNotEmpty
                          ? Text('Нет транзакций по фильтру...',
                              style: TextStyle(
                                  fontSize: 24,
                                  color: isDarkTheme
                                      ? AppColors.orange
                                      : AppColors.black))
                          : Text('Еще нет транзакций...',
                              style: TextStyle(
                                  fontSize: 24,
                                  color: isDarkTheme
                                      ? AppColors.orange
                                      : AppColors.black))
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
                  showTransactionDialog(context, ref, categories, null);
                },
              ),
            ),
            if (currentFilter != 'Все' ||
                filterByDate != 'Все' ||
                selectedCategory != 'Все')
              Positioned(
                bottom: 20,
                left: 20,
                child: CupertinoButton.filled(
                  borderRadius: BorderRadius.circular(30),
                  padding: const EdgeInsets.all(16),
                  child: const Icon(
                    CupertinoIcons.refresh,
                    color: AppColors.lightCream,
                  ),
                  onPressed: () {
                    setState(() {
                      currentFilter = 'Все';
                      filterByDate = 'Все';
                      customDate = DateTime.now();
                      selectedCategory = 'Все';
                    });
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
