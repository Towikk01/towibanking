import 'package:flutter/cupertino.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text("Настройки"),
      ),
      child: ListView(
        children: [
          CupertinoListTile(
            title: const Text("Темная тема"),
            trailing: CupertinoSwitch(
              value:
                  false, // Это значение можно хранить в Riverpod или SharedPreferences
              onChanged: (value) {
                // Логика переключения темы
              },
            ),
          ),
          CupertinoListTile(
            title: const Text("Валюта"),
            trailing: CupertinoButton(
              child: const Text("UAH"),
              onPressed: () {
                // Открыть диалог для выбора валюты
              },
            ),
          ),
          CupertinoListTile(
            title: const Text(
              "Очистить все данные",
              style: TextStyle(color: CupertinoColors.destructiveRed),
            ),
            onTap: () {

            },
          ),
        ],
      ),
    );
  }
}
