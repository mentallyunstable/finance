import 'package:flutter_test/flutter_test.dart';
import 'package:merchant_feature/bloc/merchant_bloc.dart';
import 'package:merchant_feature/data/default_merchants_data.dart';
import 'package:merchant_feature/data/merchant_data.dart';

void main() {
  test('defaults to the immutable seed merchant list', () {
    final bloc = MerchantBloc();
    addTearDown(bloc.close);

    expect(bloc.state, isA<InitialMerchantState>());
    expect(bloc.state.data.merchants, defaultMerchantsData);
    expect(
      () => bloc.state.data.merchants.add(_merchant('other', 'Other')),
      throwsUnsupportedError,
    );
  });

  test('creates a trimmed merchant with immutable categories and zero usage', () async {
    final bloc = MerchantBloc(initialMerchants: const []);
    addTearDown(bloc.close);
    final sourceCategoryIds = ['food', 'shopping'];
    final stateExpectation = expectLater(
      bloc.stream,
      emits(
        isA<CreatedMerchantState>()
            .having((state) => state.merchant.slug, 'slug', 'corner-shop')
            .having((state) => state.merchant.name, 'name', 'Corner Shop')
            .having((state) => state.merchant.description, 'description', 'Local store')
            .having((state) => state.merchant.iconId, 'iconId', 'simple-icons:shopify')
            .having((state) => state.merchant.categoryIds, 'categoryIds', [
              'food',
              'shopping',
            ])
            .having((state) => state.merchant.usageCount, 'usageCount', 0)
            .having((state) => state.data.merchants.length, 'merchant count', 1),
      ),
    );

    bloc.add(
      MerchantBlocEvent.create(
        name: '  Corner Shop  ',
        description: '  Local store  ',
        iconId: '  simple-icons:shopify  ',
        categoryIds: sourceCategoryIds,
      ),
    );

    await stateExpectation;
    sourceCategoryIds.add('other');
    expect(bloc.state.data.merchants.single.categoryIds, ['food', 'shopping']);
    expect(
      () => bloc.state.data.merchants.single.categoryIds.add('other'),
      throwsUnsupportedError,
    );
  });

  test('rejects a blank merchant name without changing data', () async {
    final initial = [_merchant('existing', 'Existing')];
    final bloc = MerchantBloc(initialMerchants: initial);
    addTearDown(bloc.close);
    final stateExpectation = expectLater(
      bloc.stream,
      emits(
        isA<ErrorMerchantState>()
            .having((state) => state.message, 'message', 'Merchant name cannot be blank.')
            .having((state) => state.existingMerchant, 'existing merchant', isNull)
            .having((state) => state.data.merchants, 'merchants', initial),
      ),
    );

    bloc.add(MerchantBlocEvent.create(name: ' \n ', categoryIds: const []));

    await stateExpectation;
  });

  test('rejects a case-insensitive duplicate and exposes the existing merchant', () async {
    final existing = _merchant('starbucks', 'Starbucks');
    final bloc = MerchantBloc(initialMerchants: [existing]);
    addTearDown(bloc.close);
    final stateExpectation = expectLater(
      bloc.stream,
      emits(
        isA<ErrorMerchantState>()
            .having((state) => state.message, 'message', 'Merchant already exists.')
            .having((state) => state.existingMerchant, 'existing merchant', same(existing))
            .having((state) => state.data.merchants, 'merchants', [existing]),
      ),
    );

    bloc.add(MerchantBlocEvent.create(name: '  STARBUCKS ', categoryIds: const []));

    await stateExpectation;
  });

  test('generates a unique slug when another merchant owns the base slug', () async {
    final bloc = MerchantBloc(
      initialMerchants: [_merchant('coffee-shop', 'Original Merchant')],
    );
    addTearDown(bloc.close);
    final stateExpectation = expectLater(
      bloc.stream,
      emits(
        isA<CreatedMerchantState>().having(
          (state) => state.merchant.slug,
          'slug',
          'coffee-shop-2',
        ),
      ),
    );

    bloc.add(MerchantBlocEvent.create(name: 'Coffee Shop', categoryIds: const []));

    await stateExpectation;
  });

  test('increments usage only for the matching slug', () async {
    final coffee = _merchant('coffee', 'Coffee', usageCount: 2);
    final tea = _merchant('tea', 'Tea', usageCount: 4);
    final bloc = MerchantBloc(initialMerchants: [coffee, tea]);
    addTearDown(bloc.close);
    final stateExpectation = expectLater(
      bloc.stream,
      emits(
        isA<InitialMerchantState>()
            .having(
              (state) => state.data.merchants.first.usageCount,
              'coffee usage',
              3,
            )
            .having(
              (state) => state.data.merchants.last.usageCount,
              'tea usage',
              4,
            ),
      ),
    );

    bloc.add(const MerchantBlocEvent.used(slug: 'coffee'));

    await stateExpectation;
  });

  test('emits no state when a used slug is unknown', () async {
    final bloc = MerchantBloc(initialMerchants: [_merchant('coffee', 'Coffee')]);
    final emittedStates = <MerchantBlocState>[];
    final subscription = bloc.stream.listen(emittedStates.add);

    bloc.add(const MerchantBlocEvent.used(slug: 'unknown'));
    await bloc.close();
    await subscription.cancel();

    expect(emittedStates, isEmpty);
  });
}

MerchantData _merchant(String slug, String name, {int usageCount = 0}) {
  return MerchantData(
    slug: slug,
    name: name,
    categoryIds: const [],
    usageCount: usageCount,
  );
}
