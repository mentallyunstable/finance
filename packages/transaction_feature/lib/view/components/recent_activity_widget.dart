import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transaction_feature/bloc/transaction_bloc.dart';
import 'package:transaction_feature/domain/entity/transaction_entity.dart';
import 'package:transaction_feature/view/components/transaction_list_item.dart';
import 'package:transaction_feature/view/components/transactions_preview_theme.dart';

final class RecentActivityWidget extends StatelessWidget {
  final Key? latestTransactionKey;

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
  const RecentActivityWidget({super.key, this.latestTransactionKey});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc, TransactionBlocState>(
      builder: (context, state) {
        final transactions = state.data.transactions;
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

            if (transactions.isEmpty) ...[
              // TODO: create empty state widget
              const SizedBox(height: 24),
              Center(
                child: Text(
                  'No transactions yet',
                  style: TextTheme.of(context).bodyMedium,
                ),
              ),
            ] else ...[
              const SizedBox(height: 24),
              if (todayTransactions.isNotEmpty) ...[
                Text(
                  'Today',
                  style: TextTheme.of(context).labelSmall,
                ),
                const SizedBox(height: 16),
                _buildSection(
                  todayTransactions,
                  identifyFirstTransaction: true,
                ),
              ],
              if (yesterdayTransactions.isNotEmpty) ...[
                const SizedBox(height: 24),
                Text(
                  'Yesterday',
                  style: TextTheme.of(context).labelSmall,
                ),
                const SizedBox(height: 16),
                _buildSection(yesterdayTransactions),
              ],
            ],
          ],
        );
      },
    );
  }

  Widget _buildSection(
    final List<TransactionEntity> transactions, {
    final bool identifyFirstTransaction = false,
  }) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: transactions.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) => TransactionListItem(
        key: identifyFirstTransaction && index == 0 ? latestTransactionKey : null,
        transaction: transactions[index],
      ),
    );
  }
}
