import 'package:flutter_test/flutter_test.dart';
import 'package:transaction_feature/data/transaction_dto.dart';
import 'package:transaction_feature/domain/entity/transaction_entity.dart';

void main() {
  test('transaction dto implements transaction entity', () {
    final transaction = TransactionDto(
      title: 'Coffee Shop',
      amount: '12.50',
      categoryId: 'food',
      merchantSlug: 'Coffee Shop',
      notes: 'Breakfast',
      date: DateTime(2026, 7, 19, 9, 5),
    );

    expect(transaction, isA<TransactionEntity>());
    expect(transaction.title, 'Coffee Shop');
    expect(transaction.amount, '12.50');
    expect(transaction.categoryId, 'food');
    expect(transaction.merchantSlug, 'Coffee Shop');
    expect(transaction.notes, 'Breakfast');
    expect(transaction.date, DateTime(2026, 7, 19, 9, 5));
  });
}
