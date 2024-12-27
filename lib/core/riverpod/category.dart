import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:towibanking/core/models/category.dart';

final defaultSpendCategories = [
  Category(title: 'Питание', icon: Icons.fastfood, id: 'food'),
  Category(title: 'Дом', icon: Icons.home, id: 'home'),
  Category(title: 'Спорт', icon: Icons.sports_baseball, id: 'sports'),
  Category(title: 'Транспорт', icon: Icons.directions_car, id: 'transport'),
  Category(title: 'Здоровье', icon: Icons.local_hospital, id: 'health'),
  Category(title: 'Одежда', icon: Icons.shopping_bag, id: 'clothes'),
  Category(title: 'Развлечения', icon: Icons.movie, id: 'entertainment'),
  Category(title: 'Подарки', icon: Icons.card_giftcard_sharp, id: 'gift'),
  Category(title: 'Другое', icon: Icons.attach_money, id: 'other'),
  Category(title: 'Подписки', icon: Icons.event_repeat_sharp, id: 'subs'),
  Category(title: 'Кафе', icon: Icons.local_cafe, id: 'cafe'),
];

final defaultIncCategories = [
  Category(title: "Зарплата", icon: Icons.money, id: 'sellary'),
  Category(title: "Другое", icon: Icons.attach_money, id: 'other'),
  Category(title: "Подарки", icon: Icons.card_giftcard_sharp, id: 'gift'),
];

final mapOfCategories = {
  'inc': defaultIncCategories,
  'spend': defaultSpendCategories,
};

final categoriesProvider = StateProvider<Map<String, List<Category>>>((ref) {
  return mapOfCategories;
});
