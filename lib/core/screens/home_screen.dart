import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:towibanking/core/models/transaction.dart';

import 'package:towibanking/core/riverpod/balance.dart';
import 'package:towibanking/core/riverpod/category.dart';
import 'package:towibanking/core/riverpod/theme.dart';

import 'package:towibanking/core/riverpod/transaction.dart';
import 'package:towibanking/core/theme/app_colors.dart';
import 'package:towibanking/core/widgets/button_add.dart';
import 'package:towibanking/core/widgets/date_filter_list.dart';
import 'package:towibanking/core/widgets/date_picker.dart';
import 'package:towibanking/core/widgets/list_transactions.dart';
import 'package:towibanking/core/widgets/reset_button.dart';
import 'package:towibanking/core/widgets/row_balance.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
        middle: RowBalance(isDarkTheme: isDarkTheme, balance: balance),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: transactions.isEmpty
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.start,
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
                        if (transactions.isNotEmpty)
                          Expanded(
                            child: Text(
                              'Последние транзакции',
                              style: TextStyle(
                                  fontSize: 26,
                                  color: isDarkTheme
                                      ? AppColors.orange
                                      : AppColors.black),
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
                    DateFilterList(
                      filterByDate: filterByDate,
                      filterForDate: filterForDate,
                      isDarkTheme: isDarkTheme,
                      onPressed: (String newFilter) {
                        setState(() {
                          filterByDate = newFilter;
                        });
                      },
                    ),
                  const SizedBox(height: 5),
                  if (transactions.isNotEmpty)
                    DatePicker(
                        customDate: customDate,
                        isDarkTheme: isDarkTheme,
                        onChanged: (DateTime newDate) {
                          setState(() {
                            customDate = newDate;
                            filterByDate = 'Выбранная дата';
                          });
                        }),
                  const SizedBox(
                    height: 10,
                  ),
                  filteredTransactions.isNotEmpty
                      ? ListTransactions(
                          filteredTransactions: filteredTransactions,
                          transactions: transactions,
                          categories: categories,
                        )
                      : transactions.isNotEmpty
                          ? Center(
                              heightFactor: 12,
                              child: Text('Нет транзакций по фильтру...',
                                  style: TextStyle(
                                      fontSize: 24,
                                      color: isDarkTheme
                                          ? AppColors.orange
                                          : AppColors.black)),
                            )
                          : Column(
                              mainAxisSize: MainAxisSize.max,
                              spacing: 10,
                              children: [
                                Text('Еще нет транзакций...',
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: isDarkTheme
                                            ? AppColors.orange
                                            : AppColors.black)),
                                Text('Можно добавить!',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: isDarkTheme
                                            ? AppColors.orange
                                            : AppColors.black,
                                        fontWeight: FontWeight.w300)),
                              ],
                            )
                ],
              ),
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (transactions.isEmpty)
                    SvgPicture.asset(
                      alignment: Alignment.topLeft,
                      'assets/add.svg',
                      width: 150,
                      height: 150,
                    ),
                  ButtonAdd(categories: categories),
                ],
              ),
            ),
            if (currentFilter != 'Все' ||
                filterByDate != 'Все' ||
                selectedCategory != 'Все')
              Positioned(
                bottom: 20,
                left: 20,
                child: ResetButton(reset: () {
                  setState(() {
                    currentFilter = 'Все';
                    filterByDate = 'Все';
                    customDate = DateTime.now();
                    selectedCategory = 'Все';
                  });
                }),
              ),
          ],
        ),
      ),
    );
  }
}
