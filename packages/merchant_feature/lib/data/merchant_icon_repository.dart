import 'dart:io';

abstract interface class MerchantIconRepository {
  Future<List<String>> search(String query);

  Future<File> getFile(String iconId);
}
