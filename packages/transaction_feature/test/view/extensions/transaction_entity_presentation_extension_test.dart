import 'package:flutter_test/flutter_test.dart';
import 'package:transaction_feature/data/transaction_dto.dart';
import 'package:transaction_feature/view/extensions/transaction_entity_presentation_extension.dart';

void main() {
  test('formats transaction time as a padded human-readable value', () {
    final transaction = TransactionDto(
      title: 'Coffee Shop',
      amount: '12.50',
      categoryId: 'food',
      merchant: 'Coffee Shop',
      notes: 'Breakfast',
      date: DateTime(2026, 7, 19, 9, 5),
    );

    expect(transaction.formattedTime, '09:05');
  });
}
