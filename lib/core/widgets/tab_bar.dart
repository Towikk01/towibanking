import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:towibanking/core/screens/home_screen.dart';
import 'package:towibanking/core/screens/profile_screen.dart';
import 'package:towibanking/core/screens/settings_screen.dart';

class TabBar extends ConsumerStatefulWidget {
  const TabBar({super.key});

  @override
  ConsumerState<TabBar> createState() => _TabBarState();
}

class _TabBarState extends ConsumerState<TabBar> {
  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        height: 60,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.profile_circled),
            label: 'Профиль',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.settings),
            label: 'Настройки',
          ),
        ],
        currentIndex: _selectedIndex, // Reflect the selected index
        onTap: (index) {
          setState(() {
            _selectedIndex = index; // Update the selected index on tap
          });
        },
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 1:
            return CupertinoTabView(
              builder: (context) => const HomeScreen(),
            );
          case 0:
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
