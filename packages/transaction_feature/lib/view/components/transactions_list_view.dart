import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:transaction_feature/data/transaction_data.dart';
import 'package:transaction_feature/view/components/transaction_list_item.dart';
import 'package:transaction_feature/view/components/transactions_preview_theme.dart';

final class TransactionsListView extends StatelessWidget {
  @Preview(
    group: 'Transactions',
    name: 'TransactionListView',
    theme: transactionPreviewTheme,
    brightness: Brightness.light,
  )
  @Preview(
    group: 'Transactions',
    name: 'TransactionListView',
    theme: transactionPreviewTheme,
    brightness: Brightness.dark,
  )
  const TransactionsListView({super.key});

  @override
  Widget build(BuildContext context) {
    final mockData = TransactionData.mockData;

    return ListView.separated(
      itemCount: mockData.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) => TransactionListItem(
        data: mockData[index],
      ),
    );
  }
}
