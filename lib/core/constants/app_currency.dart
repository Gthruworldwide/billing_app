/// Central definition of the currency used across the app.
///
/// Keeping the currency in a single place avoids inconsistencies such as
/// displaying EGP in the UI while embedding another currency (e.g. INR) in a
/// payment QR code.
class AppCurrency {
  const AppCurrency._();

  /// ISO 4217 currency code.
  static const String code = 'EGP';

  /// Currency symbol as shown in the UI and printed on receipts.
  static const String symbol = 'ج.م';

  /// Formats [amount] with exactly two decimals followed by the symbol,
  /// e.g. `12.50 ج.م`.
  static String format(num amount) => '${amount.toStringAsFixed(2)} $symbol';

  /// Formats [amount] without the symbol, e.g. `12.50`.
  static String amount(num amount) => amount.toStringAsFixed(2);
}
