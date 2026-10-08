class AppValidators {
  static String? Function(String?) required(String message) {
    return (String? value) {
      if (value == null || value.trim().isEmpty) {
        return message;
      }
      return null;
    };
  }

  static String? Function(String?) price({
    required String empty,
    required String invalid,
    required String negative,
  }) {
    return (String? value) {
      if (value == null || value.trim().isEmpty) {
        return empty;
      }
      if (double.tryParse(value) == null) {
        return invalid;
      }
      if (double.parse(value) < 0) {
        return negative;
      }
      return null;
    };
  }
}
