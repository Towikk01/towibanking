import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:towibanking/core/theme/app_colors.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier, CupertinoThemeData>(
  (ref) => ThemeNotifier(),
);

class ThemeNotifier extends StateNotifier<CupertinoThemeData> {
  ThemeNotifier()
      : super(const CupertinoThemeData(
          brightness: Brightness.dark,
          primaryColor: CupertinoColors.systemOrange,
          scaffoldBackgroundColor: CupertinoColors.black,
        ));

  void toggleTheme() {
    state = state.brightness == Brightness.dark
        ? const CupertinoThemeData(
            brightness: Brightness.light,
            primaryColor: AppColors.mint,
            scaffoldBackgroundColor: CupertinoColors.white,
            textTheme: CupertinoTextThemeData(
              textStyle: TextStyle(color: AppColors.black, fontSize: 18),
              primaryColor: AppColors.secondary,
            ))
        : const CupertinoThemeData(
            brightness: Brightness.dark,
            primaryColor: AppColors.orange,
            barBackgroundColor: AppColors.black,
            scaffoldBackgroundColor: AppColors.black,
            textTheme: CupertinoTextThemeData(
              textStyle: TextStyle(color: AppColors.orange, fontSize: 18),
              primaryColor: CupertinoColors.black,
            ));
  }
}
