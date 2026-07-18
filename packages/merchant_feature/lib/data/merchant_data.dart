final class MerchantData {
  final String slug;
  final String name;
  final String? description;
  final String? iconId;
  final List<String> categoryIds;
  final int usageCount;

  MerchantData({
    required this.slug,
    required this.name,
    this.description,
    this.iconId,
    required List<String> categoryIds,
    required this.usageCount,
  }) : categoryIds = List.unmodifiable(categoryIds);

  MerchantData copyWith({int? usageCount}) {
    return MerchantData(
      slug: slug,
      name: name,
      description: description,
      iconId: iconId,
      categoryIds: categoryIds,
      usageCount: usageCount ?? this.usageCount,
    );
  }
}
