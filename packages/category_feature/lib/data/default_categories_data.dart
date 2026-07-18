import 'package:category_feature/data/category_data.dart';
import 'package:flutter/material.dart' show Colors, Icons;

const List<CategoryData> defaultCategoriesData = [
  CategoryData(
    id: 'groceries',
    name: 'Groceries',
    color: Colors.green,
    icon: Icons.shopping_cart_outlined,
  ),
  CategoryData(
    id: 'food',
    name: 'Food',
    color: Colors.orange,
    icon: Icons.restaurant_outlined,
  ),
  CategoryData(
    id: 'transport',
    name: 'Transport',
    color: Colors.blue,
    icon: Icons.directions_car_outlined,
  ),
  CategoryData(
    id: 'housing',
    name: 'Housing',
    color: Colors.brown,
    icon: Icons.home_outlined,
  ),
  CategoryData(
    id: 'utilities',
    name: 'Utilities',
    color: Colors.amber,
    icon: Icons.lightbulb_outline,
  ),
  CategoryData(
    id: 'health',
    name: 'Health',
    color: Colors.red,
    icon: Icons.favorite_border_rounded,
  ),
  CategoryData(
    id: 'shopping',
    name: 'Shopping',
    color: Colors.pink,
    icon: Icons.shopping_bag_outlined,
  ),
  CategoryData(
    id: 'entertainment',
    name: 'Entertainment',
    color: Colors.deepPurple,
    icon: Icons.movie_outlined,
  ),
  CategoryData(
    id: 'education',
    name: 'Education',
    color: Colors.indigo,
    icon: Icons.school_outlined,
  ),
  CategoryData(
    id: 'travel',
    name: 'Travel',
    color: Colors.cyan,
    icon: Icons.luggage_outlined,
  ),
  CategoryData(
    id: 'electronics',
    name: 'Electronics',
    color: Colors.purple,
    icon: Icons.devices_outlined,
  ),
  CategoryData(
    id: 'subscriptions',
    name: 'Subscriptions',
    color: Colors.teal,
    icon: Icons.subscriptions_outlined,
  ),
  CategoryData(
    id: 'gifts',
    name: 'Gifts',
    color: Colors.redAccent,
    icon: Icons.card_giftcard_outlined,
  ),
  CategoryData(
    id: 'personal_care',
    name: 'Personal Care',
    color: Colors.lime,
    icon: Icons.spa_outlined,
  ),
  CategoryData(
    id: 'sport',
    name: 'Sport',
    color: Colors.yellow,
    icon: Icons.sports_baseball_outlined,
  ),
  CategoryData(
    id: 'other',
    name: 'Other',
    color: Colors.blueGrey,
    icon: Icons.more_horiz_rounded,
  ),
];
