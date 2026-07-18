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
    return SizedBox(
      width: 72,
      child: InkWell(
        borderRadius: const .all(.circular(12)),
        onTap: () => onSelect(category),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Ink(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: category.color.withValues(alpha: 0.3),
                borderRadius: const .all(.circular(16)),
              ),
              child: Icon(category.icon),
            ),
            const SizedBox(height: 6),
            Text(
              category.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextTheme.of(context).labelSmall,
            ),
          ],
        ),
      ),
    );
  }
}
