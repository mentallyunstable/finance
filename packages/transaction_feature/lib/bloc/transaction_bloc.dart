import 'dart:async';

import 'package:core/utils/try_catcher/bloc_try_catcher_mixin.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transaction_feature/bloc/transaction_bloc_state_data.dart';
import 'package:transaction_feature/data/transaction_dto.dart';

part 'transaction_bloc_event.dart';
part 'transaction_bloc_state.dart';

final class TransactionBloc extends Bloc<TransactionBlocEvent, TransactionBlocState> with BlocTryCatcherMixin {
  TransactionBloc() : super(TransactionBlocState.initial(data: BaseTransactionBlocStateData.empty())) {
    on<TransactionBlocEvent>(
      (event, emit) => switch (event) {
        final CreateTransactionEvent e => _onCreateTransactionEvent(e, emit),
      },
    );
  }

  FutureOr<void> _onCreateTransactionEvent(
    final CreateTransactionEvent event,
    final Emitter<TransactionBlocState> emit,
  ) {
    return tryCatch(event, emit, () async {
      final transaction = TransactionDto(
        amount: event.amount,
        title: event.title,
        categoryId: event.categoryId,
        merchantSlug: event.merchantSlug,
        notes: event.notes,
        date: DateTime.now(),
      );

      final data = state.data;
      emit(
        TransactionBlocState.created(
          data: data.copyWith(
            transactions: [transaction, ...data.transactions],
          ),
        ),
      );
    });
  }

  @override
  void emitError(final Emitter<TransactionBlocState> emit, final TryCatchError error) {
    // TODO: add localized error message
    emit(
      TransactionBlocState.error(
        data: state.data,
        message: error.message ?? 'Unexpected error',
      ),
    );
  }
}
