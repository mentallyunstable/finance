import 'package:flutter/material.dart';
import 'package:merchant_feature/data/merchant_data.dart';
import 'package:transaction_feature/domain/entity/transaction_entity.dart';
import 'package:transaction_feature/view/components/transaction_list_item.dart';

final class TransactionsListView extends StatelessWidget {
  final List<TransactionEntity> transactions;
  final Iterable<MerchantData> merchants;

  const TransactionsListView({
    super.key,
    required this.transactions,
    this.merchants = const [],
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: transactions.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) => TransactionListItem(
        transaction: transactions[index],
        merchants: merchants,
      ),
    );
  }
}
