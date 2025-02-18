import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:towibanking/core/screens/home_screen.dart';
import 'package:towibanking/core/screens/profile_screen.dart';
import 'package:towibanking/core/screens/settings_screen.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:towibanking/core/widgets/shareable_transaction_cart.dart';

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
        items: [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.profile_circled),
            label: AppLocalizations.of(context)!.profile,
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: AppLocalizations.of(context)!.homeScreen,
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.settings),
            label: AppLocalizations.of(context)!.settings,
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
