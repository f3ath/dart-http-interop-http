abstract interface class HeaderFolding {
  /// Split folded [values] for the [keyLowerCase].
  List<String> split(String keyLowerCase, String values);

  /// Folds the [values] into a single string.
  String fold(List<String> values);
}
