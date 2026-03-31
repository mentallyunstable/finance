import 'package:flutter/material.dart';
import 'package:transaction_feature/data/category_data.dart';
import 'package:transaction_feature/data/transaction_data.dart';

final class TransactionListItem extends StatelessWidget {
  final TransactionData data;

  const TransactionListItem({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final category = CategoryData.mockData.firstWhere((c) => c.id == data.categoryId);

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
          Text(data.title, style: TextTheme.of(context).titleSmall),
          Text(
            '${category.title} • ${data.date.hour}:${data.date.minute}',
            style: TextTheme.of(context).bodySmall,
          ),
        ],
      ),
      trailing: Text(
        data.amount,
        style: TextTheme.of(context).bodyLarge,
      ),
    );
  }
}
