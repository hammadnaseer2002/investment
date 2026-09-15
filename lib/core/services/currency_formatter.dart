import 'package:intl/intl.dart';

/// Centralized currency formatting. Currency symbols stay out of the
/// calculation layer entirely (RDP section 19 - Currency & Localization).
/// MVP ships with PKR; USD/GBP/AED can be added here without touching
/// InvestmentCalculator.
class CurrencyFormatter {
  CurrencyFormatter._();

  static const Map<String, String> symbols = {
    'PKR': 'Rs',
    'USD': '\$',
    'GBP': '£',
    'AED': 'AED',
  };

  static String format(double amount, {String currency = 'PKR'}) {
    final symbol = symbols[currency] ?? currency;
    final formatted = NumberFormat.decimalPattern('en_US').format(amount.round());
    return '$symbol $formatted';
  }

  static String percent(double value, {int decimals = 2}) {
    return '${value.toStringAsFixed(decimals)}%';
  }
}
