import 'package:flutter_test/flutter_test.dart';
import 'package:merchant_feature/data/merchant_data.dart';
import 'package:merchant_feature/domain/merchant_search.dart';

void main() {
  group('normalizeMerchantText', () {
    test('trims, lowercases, and collapses whitespace', () {
      expect(normalizeMerchantText('  The\tCoffee\n SHOP  '), 'the coffee shop');
    });
  });

  group('createMerchantSlug', () {
    test('creates a lowercase URL-safe slug', () {
      expect(createMerchantSlug('  Joe & The Juice!  ', const []), 'joe-the-juice');
    });

    test('uses merchant when the name has no ASCII slug characters', () {
      expect(createMerchantSlug('Кыргызстан', const []), 'merchant');
    });

    test('appends the first available numeric suffix on collision', () {
      expect(
        createMerchantSlug('Coffee Shop', const ['coffee-shop', 'coffee-shop-2']),
        'coffee-shop-3',
      );
    });
  });

  group('searchMerchants', () {
    test('orders an empty query by usage descending then name', () {
      final result = searchMerchants([
        _merchant('zulu', usageCount: 4),
        _merchant('Bravo', usageCount: 8),
        _merchant('alpha', usageCount: 8),
      ], '   ');

      expect(result.map((merchant) => merchant.name), ['alpha', 'Bravo', 'zulu']);
    });

    test('ranks exact, name prefix, word prefix, then substring matches', () {
      final result = searchMerchants([
        _merchant('Icedcoffee', usageCount: 100),
        _merchant('Best Coffee Shop'),
        _merchant('Coffee Stop'),
        _merchant('Coffee'),
        _merchant('Tea', usageCount: 999),
      ], ' coffee ');

      expect(result.map((merchant) => merchant.name), [
        'Coffee',
        'Coffee Stop',
        'Best Coffee Shop',
        'Icedcoffee',
      ]);
    });

    test('breaks equal rank by usage descending then name', () {
      final result = searchMerchants([
        _merchant('Coffee Zoo', usageCount: 1),
        _merchant('Coffee Beta', usageCount: 3),
        _merchant('Coffee Alpha', usageCount: 3),
      ], 'coffee');

      expect(result.map((merchant) => merchant.name), [
        'Coffee Alpha',
        'Coffee Beta',
        'Coffee Zoo',
      ]);
    });

    test('uses a default limit of five and accepts a smaller limit', () {
      final merchants = List.generate(
        7,
        (index) => _merchant('Merchant $index', usageCount: index),
      );

      expect(searchMerchants(merchants, ''), hasLength(5));
      expect(searchMerchants(merchants, '', limit: 2), hasLength(2));
    });

    test('excludes non-matching merchants', () {
      final result = searchMerchants([
        _merchant('Starbucks'),
        _merchant('Amazon'),
      ], 'netflix');

      expect(result, isEmpty);
    });
  });
}

MerchantData _merchant(String name, {int usageCount = 0}) {
  return MerchantData(
    slug: name.toLowerCase().replaceAll(' ', '-'),
    name: name,
    categoryIds: const [],
    usageCount: usageCount,
  );
}
