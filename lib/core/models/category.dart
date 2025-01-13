
import 'package:flutter/material.dart';

class Category {
  String title;
  IconData icon;
  String? id;
  String? type;

  Category({required this.title,  this.icon = Icons.add, this.id, this.type});

  Map<String, dynamic> toJson() =>
      {'title': title, 'icon': icon.codePoint, 'id': id, "type": type};

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
        title: json['title'],
        icon: IconData(json['icon'], fontFamily: 'MaterialIcons'),
        id: json['id'],
        type: json['type']);
  }
  @override
  String toString() {
    return 'Category{title: $title, icon: $icon, id: $id, type: $type}';
  }
}
