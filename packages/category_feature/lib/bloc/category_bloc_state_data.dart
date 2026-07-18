part of 'category_bloc.dart';

abstract class BaseCategoryBlocStateData {
  final List<CategoryData> categories;

  const BaseCategoryBlocStateData({required this.categories});

  BaseCategoryBlocStateData copyWith({List<CategoryData>? categories});
}

final class CategoryBlocStateData extends BaseCategoryBlocStateData {
  const CategoryBlocStateData({required super.categories});

  factory CategoryBlocStateData.initial() => const CategoryBlocStateData(categories: defaultCategoriesData);

  factory CategoryBlocStateData.empty() => const CategoryBlocStateData(categories: []);

  @override
  CategoryBlocStateData copyWith({
    final List<CategoryData>? categories,
  }) {
    return CategoryBlocStateData(
      categories: categories ?? this.categories,
    );
  }
}
