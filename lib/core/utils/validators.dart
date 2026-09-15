/// Shared input validation (RDP section 18 - Validation).
class Validators {
  Validators._();

  static String? nonNegativeAmount(String? value) {
    if (value == null || value.trim().isEmpty) return 'Required';
    final n = double.tryParse(value);
    if (n == null) return 'Enter a valid number';
    if (n < 0) return 'Must be zero or more';
    return null;
  }

  static String? percentRange(String? value, {double min = 0, double max = 100}) {
    if (value == null || value.trim().isEmpty) return 'Required';
    final n = double.tryParse(value);
    if (n == null) return 'Enter a valid number';
    if (n < min || n > max) return 'Must be between $min and $max';
    return null;
  }

  static String? requiredField(String? value) {
    if (value == null || value.trim().isEmpty) return 'Required';
    return null;
  }

  /// Guards divide-by-zero across the calculation layer.
  static double safeDivide(double numerator, double denominator) {
    if (denominator == 0) return 0;
    return numerator / denominator;
  }
}
