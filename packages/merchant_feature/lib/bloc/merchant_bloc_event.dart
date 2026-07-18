part of 'merchant_bloc.dart';

sealed class MerchantBlocEvent {
  const MerchantBlocEvent();

  factory MerchantBlocEvent.create({
    required String name,
    String? description,
    String? iconId,
    required List<String> categoryIds,
  }) = CreateMerchantEvent;

  const factory MerchantBlocEvent.used({required String slug}) = MerchantUsedEvent;
}

final class CreateMerchantEvent extends MerchantBlocEvent {
  final String name;
  final String? description;
  final String? iconId;
  final List<String> categoryIds;

  CreateMerchantEvent({
    required this.name,
    this.description,
    this.iconId,
    required List<String> categoryIds,
  }) : categoryIds = List.unmodifiable(categoryIds);
}

final class MerchantUsedEvent extends MerchantBlocEvent {
  final String slug;

  const MerchantUsedEvent({required this.slug});
}
