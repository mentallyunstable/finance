import 'package:category_feature/bloc/category_bloc.dart';
import 'package:category_feature/data/category_data.dart';
import 'package:category_feature/view/components/category_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef SelectCategoryCallback = void Function(CategoryData category);

final class CategoriesModalSheet extends StatelessWidget {
  final SelectCategoryCallback onSelect;

  const CategoriesModalSheet({super.key, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryBlocState>(
      builder: (context, state) => Wrap(
        spacing: 16,
        runSpacing: 16,
        children: state.data.categories
            .map(
              (category) => CategoryItem(
                category: category,
                onSelect: (category) => _onSelectCategory(context, category),
              ),
            )
            .toList(),
      ),
    );
  }

  void _onSelectCategory(final BuildContext context, final CategoryData category) {
    onSelect(category);
    Navigator.of(context).pop();
  }
}
