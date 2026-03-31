final class TransactionData {
  final String title;
  final String categoryId;
  final String amount;
  final DateTime date;

  const TransactionData({
    required this.title,
    required this.categoryId,
    required this.amount,
    required this.date,
  });

  static List mockData = <TransactionData>[
    TransactionData(
      title: 'Grocery Shopping',
      categoryId: 'groceries',
      amount: '\$132.20',
      date: DateTime(2025, 6, 15, 12, 30),
    ),
    TransactionData(
      title: 'McDonald\'s',
      categoryId: 'food',
      amount: '\$15.99',
      date: DateTime(2025, 5, 10, 15, 24),
    ),
    TransactionData(
      title: 'Uber',
      categoryId: 'transport',
      amount: '\$27.82',
      date: DateTime(2025, 3, 22, 23, 12),
    ),
    TransactionData(
      title: 'Apple Store',
      categoryId: 'electronics',
      amount: '\$559.99',
      date: DateTime(2025, 3, 20, 9, 45),
    ),
  ];
}
