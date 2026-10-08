import '../constants/app_currency.dart';

/// Formats an amount with the app currency (see [AppCurrency]).
String formatEgp(num amount) => AppCurrency.format(amount);
