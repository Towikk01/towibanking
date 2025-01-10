import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:towibanking/core/models/category.dart';
import 'package:towibanking/core/riverpod/balance.dart';
import 'package:towibanking/core/riverpod/category.dart';
import 'package:towibanking/core/riverpod/currency.dart';
import 'package:towibanking/core/widgets/add_category.dart';
import 'package:towibanking/core/widgets/remove_category.dart';

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
    form = Category(title: '', icon: icons.first, id: '', type: 'expense');
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(unifiedCategoriesProvider.notifier);
    final balance = ref.watch(balanceProvider.notifier);
    final transactions = ref.watch(balanceProvider.notifier);
    var selectedCurrency =
        ref.watch(currencyProvider.notifier).selectedCurrency;
    final currencyNotifier = ref.watch(currencyProvider.notifier);
    var selectedKey = currencies.keys.toList()[0];

    void addCategory() {
      final newCategory = Category(
          title: form.title,
          icon: form.icon,
          id: DateTime.now().toIso8601String(),
          type: form.type);
      categories.addCategory(newCategory);
    }

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Настройки"),
      ),
      child: ListView(
        children: [
          CupertinoListTile(
            title: const Text("Темная тема"),
            trailing: CupertinoSwitch(
              value: false,
              onChanged: (value) {},
            ),
          ),
          CupertinoListTile(
            title: const Text("Валюта"),
            trailing: CupertinoButton(
              child: Text(selectedCurrency),
              onPressed: () {
                showCupertinoDialog(
                    context: context,
                    builder: (context) {
                      return CupertinoAlertDialog(
                          title: const Text('Выберите валюту'),
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
                              CupertinoButton(
                                sizeStyle: CupertinoButtonSize.small,
                                child: const Text('Выбрать'),
                                onPressed: () {
                                  setState(() {
                                    selectedCurrency = currencies[selectedKey]!;
                                  });
                                  currencyNotifier.changeCurrency(selectedKey);
                                  Navigator.pop(context);
                                  print(selectedCurrency);
                                },
                              ),
                            ],
                          ));
                    });
              },
            ),
          ),
          CupertinoListTile(
            title: const Text("Добавить категорию"),
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
            title: const Text("Удалить категорию"),
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
            title: const Text(
              "Очистить все данные",
              style: TextStyle(color: CupertinoColors.destructiveRed),
            ),
            onTap: () {
              balance.reset();
              transactions.reset();
              categories.reset();
              currencyNotifier.reset();
            },
          ),
        ],
      ),
    );
  }
}
