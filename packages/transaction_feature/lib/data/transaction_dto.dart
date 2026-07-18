import 'package:transaction_feature/domain/entity/transaction_entity.dart';

final class TransactionDto implements TransactionEntity {
  @override
  final String title;

  @override
  final String amount;

  @override
  final String categoryId;

  @override
  final String? merchant;

  @override
  final String? notes;

  @override
  final DateTime date;

  const TransactionDto({
    required this.title,
    required this.categoryId,
    required this.amount,
    required this.merchant,
    required this.notes,
    required this.date,
  });
}
