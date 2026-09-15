import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/utils/validators.dart';

/// Reusable amount input (RDP section 30 - use reusable currency/percentage
/// /duration/frequency inputs).
class CurrencyInputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String currencySymbol;
  final bool optional;
  final Widget? prefixIcon;

  const CurrencyInputField({
    super.key,
    required this.label,
    required this.controller,
    this.currencySymbol = 'Rs',
    this.optional = false,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
      validator: optional ? null : Validators.nonNegativeAmount,
      decoration: InputDecoration(
        labelText: optional ? '$label (Optional)' : label,
        prefixText: '$currencySymbol ',
        prefixIcon: prefixIcon,
      ),
    );
  }
}
