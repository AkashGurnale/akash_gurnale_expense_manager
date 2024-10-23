import 'package:flutter/material.dart';

class Category {
  final String name;
  final IconData icon;
  final Color color;

  Category({
    required this.name,
    required this.icon,
    required this.color,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Category) return false;
    return name == other.name && icon == other.icon && color == other.color;
  }

  @override
  int get hashCode => name.hashCode ^ icon.hashCode ^ color.hashCode;
}
