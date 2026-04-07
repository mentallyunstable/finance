final class TransactionData {
  final String title;
  final String amount;
  final String categoryId;
  final String? merchant;
  final String? notes;
  final DateTime date;

  const TransactionData({
    required this.title,
    required this.categoryId,
    required this.amount,
    required this.merchant,
    required this.notes,
    required this.date,
  });

  static List mockData = <TransactionData>[
    TransactionData(
      title: 'Grocery Shopping',
      categoryId: 'groceries',
      amount: '\$132.20',
      merchant: null,
      notes: null,
      date: DateTime(2025, 6, 15, 12, 30),
    ),
    TransactionData(
      title: 'McDonald\'s',
      categoryId: 'food',
      amount: '\$15.99',
      merchant: 'McDonald\'s',
      notes: null,
      date: DateTime(2025, 5, 10, 15, 24),
    ),
    TransactionData(
      title: 'Uber taxi',
      categoryId: 'transport',
      amount: '\$27.82',
      merchant: 'Uber',
      notes: null,
      date: DateTime(2025, 3, 22, 23, 12),
    ),
    TransactionData(
      title: 'Apple Store',
      categoryId: 'electronics',
      amount: '\$559.99',
      merchant: 'Apple',
      notes: null,
      date: DateTime(2025, 3, 20, 9, 45),
    ),
  ];
}
