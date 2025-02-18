import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:towibanking/core/models/transaction.dart';

import 'package:towibanking/core/riverpod/balance.dart';
import 'package:towibanking/core/riverpod/category.dart';
import 'package:towibanking/core/riverpod/language.dart';
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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:towibanking/core/helpers/functions.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String currentFilter = '';
  String filterByDate = '';
  DateTime customDate = DateTime.now();
  String selectedCategory = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    currentFilter = AppLocalizations.of(context)!.all;
    filterByDate = AppLocalizations.of(context)!.all;
    selectedCategory = AppLocalizations.of(context)!.all;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final categoryNotifier = ref.read(unifiedCategoriesProvider.notifier);
      // categoryNotifier.updateCategoriesTitles(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageNotifierProvider);
    final balance = ref.watch(balanceProvider);
    final transactions = ref.watch(transactionProvider);
    final categories = ref.watch(translatedCategoriesProvider);
    final categoriesNotifier = ref.watch(unifiedCategoriesProvider.notifier);
    final isDarkTheme = ref.watch(themeProvider).brightness == Brightness.dark;

    final filterForDate = {
      AppLocalizations.of(context)!.all: (List<Transaction> transactions) =>
          transactions,
      AppLocalizations.of(context)!.curDate: (List<Transaction> transactions) =>
          transactions
              .where((el) =>
                  el.date.day == customDate.day &&
                  el.date.month == customDate.month &&
                  el.date.year == customDate.year)
              .toList(),
      AppLocalizations.of(context)!.today: (List<Transaction> transactions) =>
          transactions
              .where((el) =>
                  el.date.day == DateTime.now().day &&
                  el.date.month == DateTime.now().month &&
                  el.date.year == DateTime.now().year)
              .toList(),
      AppLocalizations.of(context)!.lastWeek:
          (List<Transaction> transactions) => transactions
              .where((el) => el.date
                  .isAfter(DateTime.now().subtract(const Duration(days: 7))))
              .toList(),
      AppLocalizations.of(context)!.lastMonth:
          (List<Transaction> transactions) => transactions
              .where((el) => el.date
                  .isAfter(DateTime.now().subtract(const Duration(days: 30))))
              .toList(),
      AppLocalizations.of(context)!.lastSixMonth:
          (List<Transaction> transactions) => transactions
              .where((el) => el.date
                  .isAfter(DateTime.now().subtract(const Duration(days: 180))))
              .toList(),
      AppLocalizations.of(context)!.lastYear:
          (List<Transaction> transactions) => transactions
              .where((el) => el.date
                  .isAfter(DateTime.now().subtract(const Duration(days: 365))))
              .toList(),
    };
    final filterActions = {
      AppLocalizations.of(context)!.onlyInc: (List<Transaction> transactions) =>
          transactions.where((el) => el.type == 'income').toList(),
      AppLocalizations.of(context)!.onlyExp: (List<Transaction> transactions) =>
          transactions.where((el) => el.type == 'expense').toList(),
      AppLocalizations.of(context)!.all: (List<Transaction> transactions) =>
          transactions,
    };

    var filteredTransactions = filterActions[currentFilter]!(transactions);
    filteredTransactions = filterForDate[filterByDate]!(filteredTransactions);

    if (selectedCategory != AppLocalizations.of(context)!.all) {
      filteredTransactions = filteredTransactions
          .where(
              (transaction) => transaction.category.title == selectedCategory)
          .toList();
    }

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: isDarkTheme ? AppColors.black : AppColors.lightCream,
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
                              AppLocalizations.of(context)!.lastTransactions,
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
                            filterByDate =
                                AppLocalizations.of(context)!.curDate;
                          });
                        }),
                  filteredTransactions.isNotEmpty
                      ? ListTransactions(
                          filteredTransactions: filteredTransactions,
                          // transactions: transactions,
                          categories: categories,
                        )
                      : transactions.isNotEmpty
                          ? Center(
                              heightFactor: language == 'uk' ? 6 : 12,
                              child: Text(
                                  AppLocalizations.of(context)!
                                      .noFilterTransactions,
                                  textAlign: TextAlign.center,
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
                                Text(
                                    AppLocalizations.of(context)!
                                        .noTransactions,
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: isDarkTheme
                                            ? AppColors.orange
                                            : AppColors.black)),
                                Text(AppLocalizations.of(context)!.canAdd,
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
            if (currentFilter != AppLocalizations.of(context)!.all ||
                selectedCategory != AppLocalizations.of(context)!.all ||
                (filterByDate == AppLocalizations.of(context)!.curDate &&
                    (customDate.day != DateTime.now().day ||
                        customDate.month != DateTime.now().month ||
                        customDate.year != DateTime.now().year)))
              Positioned(
                bottom: 20,
                left: 20,
                child: ResetButton(reset: () {
                  setState(() {
                    currentFilter = AppLocalizations.of(context)!.all;
                    filterByDate = AppLocalizations.of(context)!.all;
                    customDate = DateTime.now();
                    selectedCategory = AppLocalizations.of(context)!.all;
                  });
                }),
              ),
          ],
        ),
      ),
    );
  }
}
