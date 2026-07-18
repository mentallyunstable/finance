import 'package:flutter_test/flutter_test.dart';
import 'package:transaction_feature/bloc/transaction_bloc.dart';
import 'package:transaction_feature/domain/entity/transaction_entity.dart';

void main() {
  test('emits created state with the new transaction first', () async {
    final bloc = TransactionBloc();
    addTearDown(bloc.close);

    final stateExpectation = expectLater(
      bloc.stream,
      emits(
        isA<CreatedTransactionBlocState>().having(
          (state) => state.data.transactions.single,
          'transaction',
          isA<TransactionEntity>()
              .having((transaction) => transaction.title, 'title', 'Coffee Shop')
              .having((transaction) => transaction.amount, 'amount', '12.50')
              .having((transaction) => transaction.categoryId, 'categoryId', 'food')
              .having((transaction) => transaction.merchant, 'merchant', 'Coffee Shop')
              .having((transaction) => transaction.notes, 'notes', 'Breakfast'),
        ),
      ),
    );

    bloc.add(
      const TransactionBlocEvent.create(
        title: 'Coffee Shop',
        amount: '12.50',
        categoryId: 'food',
        merchant: 'Coffee Shop',
        notes: 'Breakfast',
      ),
    );

    await stateExpectation;
  });
}
