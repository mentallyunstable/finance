import 'package:transaction_feature/data/transaction_data.dart';

final class TransactionEntity {
  final String amount;
  final String title;
  final String categoryId;
  final String? merchant;
  final String? notes;
  final DateTime date;

  const TransactionEntity({
    required this.amount,
    required this.title,
    required this.categoryId,
    required this.merchant,
    required this.notes,
    required this.date,
  });

  factory TransactionEntity.fromDto(final TransactionData data) => TransactionEntity(
    title: data.title,
    amount: data.amount,
    categoryId: data.categoryId,
    merchant: data.merchant,
    notes: data.notes,
    date: data.date,
  );
}
