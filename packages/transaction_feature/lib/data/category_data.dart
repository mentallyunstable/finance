import 'package:flutter/material.dart' show Color, Colors, IconData, Icons;

final class CategoryData {
  final String id;
  final String title;
  final Color color;
  final IconData icon;

  const CategoryData({
    required this.id,
    required this.title,
    required this.color,
    required this.icon,
  });

  static const List<CategoryData> mockData = [
    CategoryData(
      id: 'groceries',
      title: 'Groceries',
      color: Colors.green,
      icon: Icons.shopping_cart,
    ),
    CategoryData(
      id: 'food',
      title: 'Food',
      color: Colors.orange,
      icon: Icons.restaurant,
    ),
    CategoryData(
      id: 'transport',
      title: 'Transport',
      color: Colors.blue,
      icon: Icons.directions_car,
    ),
    CategoryData(
      id: 'electronics',
      title: 'Electronics',
      color: Colors.purple,
      icon: Icons.devices,
    ),
    CategoryData(
      id: 'sport',
      title: 'Sport',
      color: Colors.yellow,
      icon: Icons.sports_baseball_outlined,
    ),
  ];
}
