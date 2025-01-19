import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:towibanking/core/theme/app_colors.dart';

// Define the provider
final themeProvider = StateNotifierProvider<ThemeNotifier, CupertinoThemeData>(
  (ref) => ThemeNotifier()..loadTheme(), // Load theme on initialization
);

// Define light and dark theme configurations
const lightTheme = CupertinoThemeData(
  brightness: Brightness.light,
  primaryColor: AppColors.mint,
  scaffoldBackgroundColor: CupertinoColors.white,
  textTheme: CupertinoTextThemeData(
    textStyle: TextStyle(color: AppColors.black, fontSize: 18),
    primaryColor: AppColors.secondary,
  ),
);

const darkTheme = CupertinoThemeData(
  brightness: Brightness.dark,
  primaryColor: CupertinoColors.systemOrange,
  scaffoldBackgroundColor: CupertinoColors.black,
  textTheme: CupertinoTextThemeData(
    textStyle: TextStyle(color: AppColors.orange, fontSize: 18),
    primaryColor: CupertinoColors.black,
  ),
);

class ThemeNotifier extends StateNotifier<CupertinoThemeData> {
  ThemeNotifier() : super(darkTheme); // Default to dark theme

  /// Load the theme from SharedPreferences
  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDark') ?? true; // Default to dark mode
    state = isDark ? darkTheme : lightTheme;
  }

  /// Save the current theme to SharedPreferences
  Future<void> saveTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = state == darkTheme;
    await prefs.setBool('isDark', isDark);
  }

  /// Toggle between light and dark themes
  void toggleTheme() {
    state = state == darkTheme ? lightTheme : darkTheme;
    saveTheme(); // Save the new theme to SharedPreferences
  }
}
