import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:transaction_feature/data/transaction_data.dart';
import 'package:transaction_feature/view/components/transaction_list_item.dart';
import 'package:transaction_feature/view/components/transactions_preview_theme.dart';

final class RecentActivityWidget extends StatelessWidget {
  @Preview(
    group: 'Transactions',
    name: 'RecentActivityWidget',
    theme: transactionPreviewTheme,
    brightness: Brightness.light,
  )
  @Preview(
    group: 'Transactions',
    name: 'RecentActivityWidget',
    theme: transactionPreviewTheme,
    brightness: Brightness.dark,
  )
  const RecentActivityWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final transactions = TransactionData.mockData.cast<TransactionData>();
    final splitIndex = (transactions.length / 2).ceil();
    final todayTransactions = transactions.take(splitIndex).toList();
    final yesterdayTransactions = transactions.skip(splitIndex).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Activity',
              style: TextTheme.of(context).titleLarge,
            ),
            TextButton(
              onPressed: () {
                // TODO: implement view all transactions
              },
              child: const Text('View all'),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          'Today',
          style: TextTheme.of(context).labelSmall,
        ),
        const SizedBox(height: 16),
        _buildSection(todayTransactions),
        const SizedBox(height: 24),
        Text(
          'Yesterday',
          style: TextTheme.of(context).labelSmall,
        ),
        const SizedBox(height: 16),
        _buildSection(yesterdayTransactions),
      ],
    );
  }

  Widget _buildSection(List<TransactionData> transactions) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: transactions.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) => TransactionListItem(data: transactions[index]),
    );
  }
}
