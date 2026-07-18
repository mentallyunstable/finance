import 'package:flutter/material.dart' show Color, IconData;

final class CategoryData {
  final String id;
  final String name;
  final Color color;
  final IconData icon;

  const CategoryData({
    required this.id,
    required this.name,
    required this.color,
    required this.icon,
  });
}
