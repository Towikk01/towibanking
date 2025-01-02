import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:towibanking/core/models/category.dart';

// Define default categories
final defaultCategories = [
  Category(title: 'Питание', icon: Icons.fastfood, id: 'food', type: 'expense'),
  Category(title: 'Дом', icon: Icons.home, id: 'home', type: 'expense'),
  Category(
      title: 'Спорт',
      icon: Icons.sports_baseball,
      id: 'sports',
      type: 'expense'),
  Category(
      title: 'Транспорт',
      icon: Icons.directions_car,
      id: 'transport',
      type: 'expense'),
  Category(
      title: 'Здоровье',
      icon: Icons.local_hospital,
      id: 'health',
      type: 'expense'),
  Category(
      title: 'Одежда',
      icon: Icons.shopping_bag,
      id: 'clothes',
      type: 'expense'),
  Category(
      title: 'Развлечения',
      icon: Icons.movie,
      id: 'entertainment',
      type: 'expense'),
  Category(
      title: 'Подарки',
      icon: Icons.card_giftcard_sharp,
      id: 'gift',
      type: 'expense'),
  Category(
      title: 'Другое', icon: Icons.attach_money, id: 'other', type: 'expense'),
  Category(
      title: 'Подписки',
      icon: Icons.event_repeat_sharp,
      id: 'subs',
      type: 'expense'),
  Category(title: 'Кафе', icon: Icons.local_cafe, id: 'cafe', type: 'expense'),
  Category(title: "Зарплата", icon: Icons.money, id: 'salary', type: 'income'),
  Category(
      title: "Другое", icon: Icons.attach_money, id: 'other', type: 'income'),
  Category(
      title: "Подарки",
      icon: Icons.card_giftcard_sharp,
      id: 'gift',
      type: 'expense'),
  Category(
      title: "Долг",
      icon: Icons.account_balance_wallet,
      id: 'debt',
      type: 'income'),
  Category(title: "Чаевые", icon: Icons.money_off, id: 'tips', type: 'income'),
  Category(
      title: 'Образование',
      icon: Icons.school,
      id: 'education',
      type: 'expense'),
  Category(
      title: 'Коммунальные услуги',
      icon: Icons.lightbulb,
      id: 'utilities',
      type: 'expense'),
  Category(
      title: 'Путешествия',
      icon: Icons.airplanemode_active,
      id: 'travel',
      type: 'expense'),
  Category(
      title: 'Медицина',
      icon: Icons.medical_services,
      id: 'medicine',
      type: 'expense'),
  Category(
      title: 'Косметика', icon: Icons.brush, id: 'cosmetics', type: 'expense'),
  Category(
      title: 'Игры', icon: Icons.videogame_asset, id: 'games', type: 'expense'),
];

class UnifiedCategoryNotifier extends StateNotifier<List<Category>> {
  UnifiedCategoryNotifier(super.state);

  void addCategory(Category category) {
    state = [
      category,
      ...state,
    ];
  }

  void removeCategory(String id) {
    state = state.where((cat) => cat.id != id).toList();
  }

  void editCategory(Category updatedCategory) {
    state = state.map((cat) {
      return cat.id == updatedCategory.id ? updatedCategory : cat;
    }).toList();
  }

  List<Category> filterByType(String type) {
    return state.where((cat) => cat.type == type).toList();
  }
}

final unifiedCategoriesProvider =
    StateNotifierProvider<UnifiedCategoryNotifier, List<Category>>((ref) {
  return UnifiedCategoryNotifier(defaultCategories);
});

final incomeCategoriesProvider = Provider<List<Category>>((ref) {
  return ref
      .watch(unifiedCategoriesProvider)
      .where((cat) => cat.type == 'income')
      .toList();
});

final spendingCategoriesProvider = Provider<List<Category>>((ref) {
  return ref
      .watch(unifiedCategoriesProvider)
      .where((cat) => cat.type == 'spend')
      .toList();
});
