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
    final currency = ref.watch(currencyProvider.notifier);
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
              child: const Text("UAH"),
              onPressed: () {},
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
              currency.reset();
            },
          ),
        ],
      ),
    );
  }
}
