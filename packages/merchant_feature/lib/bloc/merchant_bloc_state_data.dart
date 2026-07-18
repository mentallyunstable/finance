part of 'merchant_bloc.dart';

final class MerchantBlocStateData {
  final List<MerchantData> merchants;

  MerchantBlocStateData({required Iterable<MerchantData> merchants}) : merchants = List.unmodifiable(merchants);

  MerchantBlocStateData copyWith({Iterable<MerchantData>? merchants}) {
    return MerchantBlocStateData(merchants: merchants ?? this.merchants);
  }
}
