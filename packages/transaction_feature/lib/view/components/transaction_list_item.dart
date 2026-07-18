import 'package:category_feature/data/default_categories_data.dart';
import 'package:flutter/material.dart';
import 'package:transaction_feature/domain/entity/transaction_entity.dart';

final class TransactionListItem extends StatelessWidget {
  final TransactionEntity transaction;

  const TransactionListItem({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    final category = defaultCategoriesData.firstWhere((c) => c.id == transaction.categoryId);
    final formattedTime = _formatTime(transaction.date);

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
            '${category.name} • $formattedTime',
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

  String _formatTime(final DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }
}
