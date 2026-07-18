abstract class TransactionEntity {
  String get amount;
  String get title;
  String get categoryId;
  String? get merchantSlug;
  String? get notes;
  DateTime get date;
}
