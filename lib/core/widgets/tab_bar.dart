import 'package:flutter/cupertino.dart';
import 'package:towibanking/core/screens/home_screen.dart';
import 'package:towibanking/core/screens/profile_screen.dart';
import 'package:towibanking/core/screens/settings_screen.dart';

class TabBar extends StatelessWidget {
  const TabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        height: 60,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.profile_circled),
            label: 'Профиль',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.settings),
            label: 'Настройки',
          ),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return CupertinoTabView(
              builder: (context) => HomeScreen(),
            );
          case 1:
            return CupertinoTabView(
              builder: (context) => const ProfileScreen(),
            );
          case 2:
            return CupertinoTabView(
              builder: (context) => const SettingsScreen(),
            );
          default:
            return CupertinoTabView(
              builder: (context) => const Center(
                child: Text('Ошибка! Вкладка не найдена.'),
              ),
            );
        }
      },
    );
  }
}
