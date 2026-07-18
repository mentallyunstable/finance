import 'package:transaction_feature/data/transaction_dto.dart';

final class TransactionData {
  static final List<TransactionDto> mockData = <TransactionDto>[
    TransactionDto(
      title: 'Grocery Shopping',
      categoryId: 'groceries',
      amount: '132.20',
      merchant: null,
      notes: null,
      date: DateTime(2025, 6, 15, 12, 30),
    ),
    TransactionDto(
      title: 'McDonald\'s',
      categoryId: 'food',
      amount: '15.99',
      merchant: 'McDonald\'s',
      notes: null,
      date: DateTime(2025, 5, 10, 15, 24),
    ),
    TransactionDto(
      title: 'Uber taxi',
      categoryId: 'transport',
      amount: '27.82',
      merchant: 'Uber',
      notes: null,
      date: DateTime(2025, 3, 22, 23, 12),
    ),
    TransactionDto(
      title: 'Apple Store',
      categoryId: 'electronics',
      amount: '559.99',
      merchant: 'Apple',
      notes: null,
      date: DateTime(2025, 3, 20, 9, 45),
    ),
  ];
}
