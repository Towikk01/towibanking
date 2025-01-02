import 'package:flutter/cupertino.dart';

class Category {
  String title;
  IconData? icon;
  String? id;
  String? type;

  Category({required this.title, this.icon, this.id, this.type});

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
