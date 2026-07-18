import 'package:category_feature/data/category_data.dart';
import 'package:flutter/material.dart';

typedef CategorySelectCallback = void Function(CategoryData category);

final class CategoryItem extends StatelessWidget {
  final CategoryData category;
  final CategorySelectCallback onSelect;

  const CategoryItem({
    super.key,
    required this.category,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 56,
      child: Ink(
        decoration: const BoxDecoration(
          borderRadius: .all(.circular(24)),
        ),
        child: InkWell(
          borderRadius: const .all(.circular(24)),
          onTap: () => onSelect(category),
          child: Icon(category.icon),
        ),
      ),
    );
  }
}
