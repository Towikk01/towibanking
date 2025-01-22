import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Category {
  String title;
  IconData icon;
  String? id;
  String? type;
  Map<String, String>? localTitles;

  Category(
      {required this.title,
      this.icon = Icons.add,
      this.id,
      this.type,
      this.localTitles});

  Map<String, dynamic> toJson() => {
        'title': title,
        'icon': icon.codePoint,
        'id': id,
        "type": type,
        'localTitles': localTitles
      };

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      title: json['title'],
      icon: IconData(json['icon'], fontFamily: 'MaterialIcons'),
      id: json['id'],
      localTitles: Map<String, String>.from(json['localTitles'] ?? {}),
      type: json['type'],
    );
  }
  @override
  String toString() {
    return 'Category{title: $title, icon: $icon, id: $id, type: $type}';
  }

  Category copyWith({
    String? title,
    IconData? icon,
    String? id,
    String? type,
    Map<String, String>? localTitles,
  }) {
    return Category(
        title: title ?? this.title,
        icon: icon ?? this.icon,
        id: id ?? this.id,
        type: type ?? this.type,
        localTitles: localTitles ?? this.localTitles);
  }
}
