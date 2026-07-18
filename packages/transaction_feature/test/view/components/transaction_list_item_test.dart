import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:transaction_feature/data/transaction_dto.dart';
import 'package:transaction_feature/view/components/transaction_list_item.dart';

void main() {
  testWidgets('formats transaction time as a padded human-readable value', (tester) async {
    final transaction = TransactionDto(
      title: 'Coffee Shop',
      amount: '12.50',
      categoryId: 'food',
      merchant: 'Coffee Shop',
      notes: 'Breakfast',
      date: DateTime(2026, 7, 19, 9, 5),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TransactionListItem(transaction: transaction),
        ),
      ),
    );

    expect(find.text('Food • 09:05'), findsOneWidget);
  });
}
