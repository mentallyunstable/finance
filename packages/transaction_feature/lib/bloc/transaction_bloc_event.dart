part of 'transaction_bloc.dart';

sealed class TransactionBlocEvent {
  const TransactionBlocEvent();

  const factory TransactionBlocEvent.create({
    required final String title,
    required final String amount,
    required final String categoryId,
    required final String? merchant,
    required final String? notes,
  }) = CreateTransactionEvent;
}

final class CreateTransactionEvent extends TransactionBlocEvent {
  final String title;
  final String amount;
  final String categoryId;
  final String? merchant;
  final String? notes;

  const CreateTransactionEvent({
    required this.title,
    required this.amount,
    required this.categoryId,
    required this.merchant,
    required this.notes,
  });
}
