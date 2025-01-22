import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:towibanking/core/models/category.dart';
import 'package:towibanking/core/riverpod/balance.dart';
import 'package:towibanking/core/riverpod/category.dart';
import 'package:towibanking/core/riverpod/currency.dart';
import 'package:towibanking/core/riverpod/language.dart';
import 'package:towibanking/core/riverpod/theme.dart';
import 'package:towibanking/core/widgets/add_category.dart';
import 'package:towibanking/core/widgets/remove_category.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final List<IconData> icons = [
    Icons.add,
    Icons.remove,
    Icons.food_bank,
    Icons.access_alarm,
    Icons.accessibility,
    Icons.account_balance_wallet,
    Icons.account_circle,
    Icons.account_tree,
    Icons.catching_pokemon,
    Icons.cake,
    Icons.calendar_today,
    Icons.camera,
    Icons.campaign,
    Icons.cancel,
    Icons.call,
  ];

  late Category form;

  @override
  void initState() {
    super.initState();
    form = Category(title: '', icon: icons.first, id: '', type: 'expense', localTitles: {});
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(unifiedCategoriesProvider.notifier);
    final balance = ref.watch(balanceProvider.notifier);
    final transactions = ref.watch(balanceProvider.notifier);
    var selectedCurrency = ref.watch(currencyProvider)['selectedCurrency'];
    final currencyNotifier = ref.watch(currencyProvider.notifier);
    var selectedKey = currencies.keys.toList()[0];
    final isDarkTheme = ref.watch(themeProvider).brightness == Brightness.dark;
    final language = ref.watch(languageNotifierProvider);
    final languageNotifier = ref.watch(languageNotifierProvider.notifier);

    void addCategory() {
      final newCategory = Category(
          localTitles: {},
          title: form.title,
          icon: form.icon,
          id: DateTime.now().toIso8601String(),
          type: form.type);
      categories.addCategory(newCategory);
    }

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(AppLocalizations.of(context)!.settings),
      ),
      child: ListView(
        children: [
          CupertinoListTile(
            title: Text(AppLocalizations.of(context)!.theme),
            trailing: CupertinoSwitch(
              value: isDarkTheme,
              onChanged: (value) {
                ref.read(themeProvider.notifier).toggleTheme();
              },
            ),
          ),
          CupertinoListTile(
            title: Text(AppLocalizations.of(context)!.language),
            trailing: CupertinoButton(
              child: Text(language),
              onPressed: () {
                int selectedIndex = AppLocalizations.supportedLocales
                    .indexWhere((locale) => locale.languageCode == language);

                showCupertinoDialog(
                  context: context,
                  builder: (_) {
                    return CupertinoAlertDialog(
                      title: Text(AppLocalizations.of(context)!.changeLanguage),
                      content: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 40, // Height for better picker visibility
                            child: CupertinoPicker(
                              itemExtent: 40, // Item height
                              scrollController: FixedExtentScrollController(
                                initialItem: selectedIndex,
                              ),
                              onSelectedItemChanged: (int index) {
                                selectedIndex = index;
                              },
                              children: AppLocalizations.supportedLocales
                                  .map((locale) {
                                return Center(
                                  child: Text(
                                    locale.languageCode,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        CupertinoDialogAction(
                          child: Text(AppLocalizations.of(context)!.cancel),
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true).pop();
                          },
                        ),
                        CupertinoDialogAction(
                          child: Text(AppLocalizations.of(context)!.change),
                          onPressed: () {
                            final selectedLocale = AppLocalizations
                                .supportedLocales[selectedIndex];
                            languageNotifier.changeLanguage(
                                selectedLocale.languageCode, ref);
                            Navigator.of(context, rootNavigator: true).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          CupertinoListTile(
            title: Text(AppLocalizations.of(context)!.currency),
            trailing: CupertinoButton(
              child: Text(selectedCurrency),
              onPressed: () {
                showCupertinoDialog(
                    context: context,
                    builder: (context) {
                      return CupertinoAlertDialog(
                          actions: [
                            CupertinoDialogAction(
                              child: Text(AppLocalizations.of(context)!.cancel),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            CupertinoDialogAction(
                              child: Text(AppLocalizations.of(context)!.select),
                              onPressed: () {
                                setState(() {
                                  selectedCurrency = currencies[selectedKey]!;
                                });
                                currencyNotifier.changeCurrency(selectedKey);
                                Navigator.pop(context);
                              },
                            ),
                          ],
                          title: Text(
                              AppLocalizations.of(context)!.changeCurrency),
                          content: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: 20,
                            children: [
                              const SizedBox(
                                height: 5,
                              ),
                              SizedBox(
                                height: 50,
                                child: CupertinoPicker(
                                  itemExtent: 50,
                                  scrollController: FixedExtentScrollController(
                                      initialItem: currencies.values
                                          .toList()
                                          .indexWhere(
                                            (val) => val == selectedCurrency,
                                          )),
                                  onSelectedItemChanged: (int index) {
                                    selectedKey =
                                        currencies.keys.toList()[index];
                                  },
                                  children: currencies.keys
                                      .map((key) => Center(
                                            child: Text(
                                              "$key (${currencies[key]})",
                                              textAlign: TextAlign.center,
                                              style:
                                                  const TextStyle(fontSize: 20),
                                            ),
                                          ))
                                      .toList(),
                                ),
                              ),
                            ],
                          ));
                    });
              },
            ),
          ),
          CupertinoListTile(
            title: Text(AppLocalizations.of(context)!.addCategory),
            trailing: CupertinoButton(
              child: const Text("+"),
              onPressed: () {
                showCupertinoDialog(
                  context: context,
                  builder: (_) {
                    return CategoriesDialog(
                      form: form,
                      icons: icons,
                      add: addCategory,
                    );
                  },
                );
              },
            ),
          ),
          CupertinoListTile(
            title: Text(AppLocalizations.of(context)!.removeCategory),
            trailing: CupertinoButton(
              child: const Text("-"),
              onPressed: () {
                showCupertinoDialog(
                  context: context,
                  builder: (_) {
                    return const RemoveCategory();
                  },
                );
              },
            ),
          ),
          CupertinoListTile(
            title: Text(
              AppLocalizations.of(context)!.reset,
              style: TextStyle(color: CupertinoColors.destructiveRed),
            ),
            onTap: () {
              showCupertinoDialog(
                context: context,
                builder: (_) {
                  return CupertinoAlertDialog(
                    title: Text(AppLocalizations.of(context)!.sure),
                    content: Text(AppLocalizations.of(context)!.wholeData),
                    actions: [
                      CupertinoDialogAction(
                        child: Text(AppLocalizations.of(context)!.cancel),
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true)
                              .pop(context);
                        },
                      ),
                      CupertinoDialogAction(
                        child: Text(AppLocalizations.of(context)!.reset),
                        isDestructiveAction: true,
                        onPressed: () {
                          balance.reset();
                          transactions.reset();
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
