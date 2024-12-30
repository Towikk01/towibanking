import 'package:flutter/cupertino.dart';

class Category {
  final String title;
  final IconData? icon;
  final String? id;

  Category({required this.title, this.icon, this.id});

  Map<String, dynamic> toJson() => {
        'title': title,
        'icon': icon?.codePoint,
        'id': id,
      };

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      title: json['title'],
      icon: json['icon'] != null
          ? IconData(json['icon'], fontFamily: 'MaterialIcons')
          : null,
      id: json['id'],
    );
  }
}
