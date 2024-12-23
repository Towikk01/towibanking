import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Category {
  final String title;
  final IconData icon;
  final String id;

  Category({required this.title, required this.icon, required this.id});
}

final defaultCategories = [
  Category(title: 'Питание', icon: Icons.fastfood, id: 'food'),
  Category(title: 'Дом', icon: Icons.home, id: 'home'),
  Category(title: 'Спорт', icon: Icons.sports_baseball, id: 'sports'),
  Category(title: 'Транспорт', icon: Icons.directions_car, id: 'transport'),
];

final categoriesProvider = StateProvider<List<Category>>((ref) {
  return defaultCategories;
});
