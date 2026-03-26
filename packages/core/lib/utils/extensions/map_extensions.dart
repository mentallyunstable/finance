extension MapExtensions on Map {
  Map<String, dynamic> normalize() {
    return Map<String, dynamic>.fromEntries(
      entries.map(
        (entry) => MapEntry(entry.key.toString(), entry.value),
      ),
    );
  }
}
