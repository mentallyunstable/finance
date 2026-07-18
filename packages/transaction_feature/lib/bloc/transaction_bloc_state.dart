part of 'transaction_bloc.dart';

sealed class TransactionBlocState {
  final BaseTransactionBlocStateData data;

  const TransactionBlocState({required this.data});

  const factory TransactionBlocState.initial({
    required final BaseTransactionBlocStateData data,
  }) = InitialCreateTransactionBlocState;

  const factory TransactionBlocState.error({
    required final BaseTransactionBlocStateData data,
    required final String message,
  }) = ErrorCreateTransactionBlocState;

  const factory TransactionBlocState.created({
    required final BaseTransactionBlocStateData data,
  }) = CreatedTransactionBlocState;
}

final class InitialCreateTransactionBlocState extends TransactionBlocState {
  const InitialCreateTransactionBlocState({required super.data});
}

final class ErrorCreateTransactionBlocState extends TransactionBlocState {
  final String message;

  const ErrorCreateTransactionBlocState({
    required super.data,
    required this.message,
  });
}

final class CreatedTransactionBlocState extends TransactionBlocState {
  const CreatedTransactionBlocState({required super.data});
}
