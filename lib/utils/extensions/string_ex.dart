extension StringEx on String? {
  String get capitalize {
    if (this == null || this!.isEmpty) {
      return '';
    }
    return this![0].toUpperCase() + this!.substring(1);
  }

  String get camelToSnake {
    if (this == null || this!.isEmpty) {
      return '';
    }
    return this!
        .replaceAllMapped(
            RegExp(r'([a-z])([A-Z])'), (Match m) => '${m[1]}_${m[2]}')
        .toLowerCase();
  }
}