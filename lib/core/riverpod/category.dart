import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:towibanking/core/models/category.dart';

import 'package:towibanking/core/riverpod/language.dart';

final defaultCategories = [
  Category(
    title: 'Питание',
    icon: Icons.fastfood,
    id: 'food',
    type: 'expense',
    localTitles: {'en': 'Food', 'ru': 'Питание', 'uk': 'Їжа'},
  ),
  Category(
    title: 'Дом',
    icon: Icons.home,
    id: 'home',
    type: 'expense',
    localTitles: {'en': 'Home', 'ru': 'Дом', 'uk': 'Дім'},
  ),
  Category(
    title: 'Спорт',
    icon: Icons.sports_baseball,
    id: 'sports',
    type: 'expense',
    localTitles: {'en': 'Sports', 'ru': 'Спорт', 'uk': 'Спорт'},
  ),
  Category(
    title: 'Транспорт',
    icon: Icons.directions_car,
    id: 'transport',
    type: 'expense',
    localTitles: {'en': 'Transport', 'ru': 'Транспорт', 'uk': 'Транспорт'},
  ),
  Category(
    title: 'Здоровье',
    icon: Icons.local_hospital,
    id: 'health',
    type: 'expense',
    localTitles: {'en': 'Health', 'ru': 'Здоровье', 'uk': 'Здоров’я'},
  ),
  Category(
    title: 'Одежда',
    icon: Icons.shopping_bag,
    id: 'clothes',
    type: 'expense',
    localTitles: {'en': 'Clothes', 'ru': 'Одежда', 'uk': 'Одяг'},
  ),
  Category(
    title: 'Развлечения',
    icon: Icons.movie,
    id: 'entertainment',
    type: 'expense',
    localTitles: {'en': 'Entertainment', 'ru': 'Развлечения', 'uk': 'Розваги'},
  ),
  Category(
    title: 'Подарки',
    icon: Icons.card_giftcard_sharp,
    id: 'gift',
    type: 'expense',
    localTitles: {'en': 'Gifts', 'ru': 'Подарки', 'uk': 'Подарунки'},
  ),
  Category(
    title: 'Другое',
    icon: Icons.attach_money,
    id: 'other',
    type: 'expense',
    localTitles: {'en': 'Other', 'ru': 'Другое', 'uk': 'Інше'},
  ),
  Category(
    title: 'Подписки',
    icon: Icons.event_repeat_sharp,
    id: 'subs',
    type: 'expense',
    localTitles: {'en': 'Subscriptions', 'ru': 'Подписки', 'uk': 'Підписки'},
  ),
  Category(
    title: 'Кафе',
    icon: Icons.local_cafe,
    id: 'cafe',
    type: 'expense',
    localTitles: {'en': 'Cafe', 'ru': 'Кафе', 'uk': 'Кафе'},
  ),
  Category(
    title: 'Образование',
    icon: Icons.school,
    id: 'education',
    type: 'expense',
    localTitles: {'en': 'Education', 'ru': 'Образование', 'uk': 'Освіта'},
  ),
  Category(
    title: 'Коммунальные услуги',
    icon: Icons.lightbulb,
    id: 'utilities',
    type: 'expense',
    localTitles: {
      'en': 'Utilities',
      'ru': 'Коммунальные услуги',
      'uk': 'Комунальні послуги',
    },
  ),
  Category(
    title: 'Путешествия',
    icon: Icons.airplanemode_active,
    id: 'travel',
    type: 'expense',
    localTitles: {'en': 'Travel', 'ru': 'Путешествия', 'uk': 'Подорожі'},
  ),
  Category(
    title: 'Медицина',
    icon: Icons.medical_services,
    id: 'medicine',
    type: 'expense',
    localTitles: {'en': 'Medicine', 'ru': 'Медицина', 'uk': 'Медицина'},
  ),
  Category(
    title: 'Косметика',
    icon: Icons.brush,
    id: 'cosmetics',
    type: 'expense',
    localTitles: {'en': 'Cosmetics', 'ru': 'Косметика', 'uk': 'Косметика'},
  ),
  Category(
    title: 'Игры',
    icon: Icons.videogame_asset,
    id: 'games',
    type: 'expense',
    localTitles: {'en': 'Games', 'ru': 'Игры', 'uk': 'Ігри'},
  ),
  Category(
    title: "Зарплата",
    icon: Icons.money,
    id: 'salary',
    type: 'income',
    localTitles: {'en': 'Salary', 'ru': 'Зарплата', 'uk': 'Зарплата'},
  ),
  Category(
    title: "Чаевые",
    icon: Icons.money_off,
    id: 'tips',
    type: 'income',
    localTitles: {'en': 'Tips', 'ru': 'Чаевые', 'uk': 'Чайові'},
  ),
  Category(
    title: "Долг",
    icon: Icons.account_balance_wallet,
    id: 'debt',
    type: 'income',
    localTitles: {'en': 'Debt', 'ru': 'Долг', 'uk': 'Борг'},
  ),
];

final translatedCategoriesProvider = Provider<List<Category>>((ref) {
  final categories = ref.watch(unifiedCategoriesProvider);
  final currentLanguage = ref.watch(languageNotifierProvider);

  return categories.map((category) {
    final localizedTitle =
        category.localTitles?[currentLanguage] ?? category.title;
    return category.copyWith(title: localizedTitle);
  }).toList();
});

final unifiedCategoriesProvider =
    StateNotifierProvider<UnifiedCategoryNotifier, List<Category>>((ref) {
  final notifier = UnifiedCategoryNotifier(defaultCategories);
  notifier.loadCategories();
  return notifier;
});

class UnifiedCategoryNotifier extends StateNotifier<List<Category>> {
  UnifiedCategoryNotifier(super.state);

  Future<void> loadCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final categoriesString = prefs.getString('categories');
    if (categoriesString != null) {
      final categoriesList = json.decode(categoriesString) as List;
      state = categoriesList
          .map((categoryJson) => Category.fromJson(categoryJson))
          .toList();
    } else {
      state = [...defaultCategories];
    }
  }

  Future<void> saveCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final categoriesJson = state.map((cat) => cat.toJson()).toList();
    await prefs.setString('categories', json.encode(categoriesJson));
  }

  void addCategory(Category category) async {
    state = [
      category,
      ...state,
    ];
    await saveCategories();
  }



  void removeCategory(Category category) async {
    state = state
        .where((cat) =>
            !(cat.title == category.title && cat.type == category.type))
        .toList();
    await saveCategories();
  }

  void reset() async {
    state = [...defaultCategories];
    var prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await saveCategories();
  }
}
