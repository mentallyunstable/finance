import 'package:transaction_feature/domain/entity/transaction_entity.dart';

extension TransactionEntityPresentationExtension on TransactionEntity {
  String get formattedTime {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }
}
