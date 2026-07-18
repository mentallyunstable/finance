import 'package:transaction_feature/domain/entity/transaction_entity.dart';

abstract base class BaseTransactionBlocStateData {
  final List<TransactionEntity> transactions;

  const BaseTransactionBlocStateData({required this.transactions});

  factory BaseTransactionBlocStateData.empty() => TransactionBlocStateData.empty();

  BaseTransactionBlocStateData copyWith({List<TransactionEntity>? transactions});
}

final class TransactionBlocStateData extends BaseTransactionBlocStateData {
  const TransactionBlocStateData({required super.transactions});

  factory TransactionBlocStateData.empty() => const TransactionBlocStateData(transactions: []);

  @override
  BaseTransactionBlocStateData copyWith({final List<TransactionEntity>? transactions}) {
    return TransactionBlocStateData(transactions: transactions ?? this.transactions);
  }
}
