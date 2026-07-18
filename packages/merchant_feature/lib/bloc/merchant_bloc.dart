import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:merchant_feature/data/default_merchants_data.dart';
import 'package:merchant_feature/data/merchant_data.dart';
import 'package:merchant_feature/domain/merchant_search.dart';

part 'merchant_bloc_event.dart';
part 'merchant_bloc_state.dart';
part 'merchant_bloc_state_data.dart';

final class MerchantBloc extends Bloc<MerchantBlocEvent, MerchantBlocState> {
  MerchantBloc({Iterable<MerchantData>? initialMerchants})
    : super(
        MerchantBlocState.initial(
          data: MerchantBlocStateData(
            merchants: initialMerchants ?? defaultMerchantsData,
          ),
        ),
      ) {
    on<MerchantBlocEvent>(
      (event, emit) => switch (event) {
        final CreateMerchantEvent event => _create(event, emit),
        final MerchantUsedEvent event => _markUsed(event, emit),
      },
    );
  }

  void _create(CreateMerchantEvent event, Emitter<MerchantBlocState> emit) {
    final name = event.name.trim();
    if (name.isEmpty) {
      emit(
        MerchantBlocState.error(
          data: state.data,
          message: 'Merchant name cannot be blank.',
        ),
      );
      return;
    }

    MerchantData? existingMerchant;
    final normalizedName = normalizeMerchantText(name);
    for (final merchant in state.data.merchants) {
      if (normalizeMerchantText(merchant.name) == normalizedName) {
        existingMerchant = merchant;
        break;
      }
    }
    if (existingMerchant != null) {
      emit(
        MerchantBlocState.error(
          data: state.data,
          message: 'Merchant already exists.',
          existingMerchant: existingMerchant,
        ),
      );
      return;
    }

    final merchant = MerchantData(
      slug: createMerchantSlug(
        name,
        state.data.merchants.map((merchant) => merchant.slug),
      ),
      name: name,
      description: _trimToNull(event.description),
      iconId: _trimToNull(event.iconId),
      categoryIds: _normalizeCategoryIds(event.categoryIds),
      usageCount: 0,
    );
    final data = state.data.copyWith(
      merchants: [...state.data.merchants, merchant],
    );
    emit(MerchantBlocState.created(data: data, merchant: merchant));
  }

  void _markUsed(MerchantUsedEvent event, Emitter<MerchantBlocState> emit) {
    final index = state.data.merchants.indexWhere(
      (merchant) => merchant.slug == event.slug,
    );
    if (index == -1) {
      return;
    }

    final merchants = state.data.merchants.toList();
    final merchant = merchants[index];
    merchants[index] = merchant.copyWith(usageCount: merchant.usageCount + 1);
    emit(
      MerchantBlocState.initial(
        data: state.data.copyWith(merchants: merchants),
      ),
    );
  }
}

String? _trimToNull(String? value) {
  final trimmed = value?.trim();
  return trimmed == null || trimmed.isEmpty ? null : trimmed;
}

List<String> _normalizeCategoryIds(Iterable<String> categoryIds) {
  final normalized = <String>[];
  final seen = <String>{};

  for (final categoryId in categoryIds) {
    final trimmed = categoryId.trim();
    if (trimmed.isNotEmpty && seen.add(trimmed)) {
      normalized.add(trimmed);
    }
  }

  return normalized;
}
