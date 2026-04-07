import 'package:flutter/material.dart';
import 'package:transaction_feature/data/category_data.dart';
import 'package:transaction_feature/domain/entity/transaction_entity.dart';

final class TransactionListItem extends StatelessWidget {
  final TransactionEntity transaction;

  const TransactionListItem({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    final category = CategoryData.mockData.firstWhere((c) => c.id == transaction.categoryId);

    return ListTile(
      minTileHeight: 80,
      titleAlignment: ListTileTitleAlignment.center,
      shape: const RoundedRectangleBorder(borderRadius: .all(.circular(24))),
      onTap: () {
        // TODO: implement transaction details
      },
      tileColor: ColorScheme.of(context).surfaceBright,
      leading: CircleAvatar(
        backgroundColor: ColorScheme.of(context).surfaceContainerHigh,
        child: Icon(category.icon, color: category.color),
      ),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(transaction.title, style: TextTheme.of(context).titleSmall),
          Text(
            '${category.title} • ${transaction.date.hour}:${transaction.date.minute}',
            style: TextTheme.of(context).bodySmall,
          ),
        ],
      ),
      trailing: Text(
        '\$${transaction.amount}',
        style: TextTheme.of(context).bodyLarge,
      ),
    );
  }
}
