part of 'merchant_bloc.dart';

sealed class MerchantBlocState {
  final MerchantBlocStateData data;

  const MerchantBlocState({required this.data});

  const factory MerchantBlocState.initial({
    required MerchantBlocStateData data,
  }) = InitialMerchantState;

  const factory MerchantBlocState.created({
    required MerchantBlocStateData data,
    required MerchantData merchant,
  }) = CreatedMerchantState;

  const factory MerchantBlocState.error({
    required MerchantBlocStateData data,
    required String message,
    MerchantData? existingMerchant,
  }) = ErrorMerchantState;
}

final class InitialMerchantState extends MerchantBlocState {
  const InitialMerchantState({required super.data});
}

final class CreatedMerchantState extends MerchantBlocState {
  final MerchantData merchant;

  const CreatedMerchantState({required super.data, required this.merchant});
}

final class ErrorMerchantState extends MerchantBlocState {
  final String message;
  final MerchantData? existingMerchant;

  const ErrorMerchantState({
    required super.data,
    required this.message,
    this.existingMerchant,
  });
}
