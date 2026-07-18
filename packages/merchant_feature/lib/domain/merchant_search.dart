import 'package:merchant_feature/data/merchant_data.dart';

String normalizeMerchantText(String value) {
  return value.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
}

String createMerchantSlug(String name, Iterable<String> existingSlugs) {
  final normalizedName = normalizeMerchantText(name).replaceAll("'", '');
  final slug = normalizedName.replaceAll(RegExp('[^a-z0-9]+'), '-').replaceAll(RegExp(r'^-+|-+$'), '');
  final baseSlug = slug.isEmpty ? 'merchant' : slug;
  final normalizedExistingSlugs = existingSlugs.map((slug) => slug.toLowerCase()).toSet();

  if (!normalizedExistingSlugs.contains(baseSlug)) {
    return baseSlug;
  }

  var suffix = 2;
  while (normalizedExistingSlugs.contains('$baseSlug-$suffix')) {
    suffix++;
  }
  return '$baseSlug-$suffix';
}

List<MerchantData> searchMerchants(
  Iterable<MerchantData> merchants,
  String query, {
  int limit = 5,
}) {
  if (limit <= 0) {
    return const [];
  }

  final normalizedQuery = normalizeMerchantText(query);
  final ranked = <({MerchantData merchant, int rank})>[];

  for (final merchant in merchants) {
    final normalizedName = normalizeMerchantText(merchant.name);
    final rank = _matchRank(normalizedName, normalizedQuery);
    if (rank != null) {
      ranked.add((merchant: merchant, rank: rank));
    }
  }

  ranked.sort((left, right) {
    final rankComparison = left.rank.compareTo(right.rank);
    if (rankComparison != 0) {
      return rankComparison;
    }

    final usageComparison = right.merchant.usageCount.compareTo(left.merchant.usageCount);
    if (usageComparison != 0) {
      return usageComparison;
    }

    return normalizeMerchantText(
      left.merchant.name,
    ).compareTo(normalizeMerchantText(right.merchant.name));
  });

  return ranked.take(limit).map((entry) => entry.merchant).toList(growable: false);
}

int? _matchRank(String name, String query) {
  if (query.isEmpty) {
    return 0;
  }
  if (name == query) {
    return 0;
  }
  if (name.startsWith(query)) {
    return 1;
  }
  if (name.split(' ').any((word) => word.startsWith(query))) {
    return 2;
  }
  if (name.contains(query)) {
    return 3;
  }
  return null;
}
