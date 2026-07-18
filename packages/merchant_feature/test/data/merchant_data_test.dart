import 'package:flutter_test/flutter_test.dart';
import 'package:merchant_feature/data/default_merchants_data.dart';
import 'package:merchant_feature/data/merchant_data.dart';

void main() {
  test('stores immutable category IDs and copies usage count', () {
    final merchant = MerchantData(
      slug: 'corner-shop',
      name: 'Corner Shop',
      description: 'Local groceries',
      iconId: 'simple-icons:shopify',
      categoryIds: const ['groceries', 'shopping'],
      usageCount: 2,
    );

    expect(() => merchant.categoryIds.add('other'), throwsUnsupportedError);

    final updated = merchant.copyWith(usageCount: 3);
    expect(updated.slug, merchant.slug);
    expect(updated.name, merchant.name);
    expect(updated.description, merchant.description);
    expect(updated.iconId, merchant.iconId);
    expect(updated.categoryIds, merchant.categoryIds);
    expect(updated.usageCount, 3);
  });

  test('seeds exactly the five common merchants', () {
    expect(
      defaultMerchantsData
          .map(
            (merchant) => (
              merchant.slug,
              merchant.name,
              merchant.iconId,
              merchant.categoryIds.join(','),
              merchant.usageCount,
            ),
          )
          .toList(),
      [
        ('starbucks', 'Starbucks', 'simple-icons:starbucks', 'food', 9),
        ('uber', 'Uber', 'simple-icons:uber', 'transport,travel', 7),
        ('amazon', 'Amazon', 'simple-icons:amazon', 'shopping,electronics', 5),
        ('netflix', 'Netflix', 'simple-icons:netflix', 'entertainment,subscriptions', 3),
        ('mcdonalds', "McDonald's", 'simple-icons:mcdonalds', 'food', 1),
      ],
    );
  });
}
