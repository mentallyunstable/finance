import 'package:category_feature/data/default_categories_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:merchant_feature/data/merchant_data.dart';
import 'package:merchant_feature/data/merchant_icon_repository.dart';
import 'package:merchant_feature/view/merchant_icon.dart';
import 'package:transaction_feature/domain/entity/transaction_entity.dart';

final class TransactionListItem extends StatelessWidget {
  final TransactionEntity transaction;
  final Iterable<MerchantData> merchants;

  const TransactionListItem({
    super.key,
    required this.transaction,
    this.merchants = const [],
  });

  @override
  Widget build(BuildContext context) {
    final category = defaultCategoriesData.firstWhere((c) => c.id == transaction.categoryId);
    final merchant = _findMerchant();
    final merchantIconId = merchant?.iconId;
    final formattedTime = _formatTime(transaction.date);
    final categoryIcon = Icon(category.icon, color: category.color);

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
        child: merchantIconId == null
            ? categoryIcon
            : MerchantIcon(
                iconId: merchantIconId,
                repository: context.read<MerchantIconRepository>(),
                fallback: categoryIcon,
              ),
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

  MerchantData? _findMerchant() {
    final merchantSlug = transaction.merchantSlug;
    if (merchantSlug == null) {
      return null;
    }

    for (final merchant in merchants) {
      if (merchant.slug == merchantSlug) {
        return merchant;
      }
    }
    return null;
  }

  String _formatTime(final DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }
}
