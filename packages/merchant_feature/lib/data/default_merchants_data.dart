import 'package:merchant_feature/data/merchant_data.dart';

final List<MerchantData> defaultMerchantsData = List.unmodifiable([
  MerchantData(
    slug: 'starbucks',
    name: 'Starbucks',
    iconId: 'simple-icons:starbucks',
    categoryIds: const ['food'],
    usageCount: 9,
  ),
  MerchantData(
    slug: 'uber',
    name: 'Uber',
    iconId: 'simple-icons:uber',
    categoryIds: const ['transport', 'travel'],
    usageCount: 7,
  ),
  MerchantData(
    slug: 'amazon',
    name: 'Amazon',
    iconId: 'simple-icons:amazon',
    categoryIds: const ['shopping', 'electronics'],
    usageCount: 5,
  ),
  MerchantData(
    slug: 'netflix',
    name: 'Netflix',
    iconId: 'simple-icons:netflix',
    categoryIds: const ['entertainment', 'subscriptions'],
    usageCount: 3,
  ),
  MerchantData(
    slug: 'mcdonalds',
    name: "McDonald's",
    iconId: 'simple-icons:mcdonalds',
    categoryIds: const ['food'],
    usageCount: 1,
  ),
]);
