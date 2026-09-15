import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/utils/validators.dart';

class PercentageInputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final double min;
  final double max;

  const PercentageInputField({
    super.key,
    required this.label,
    required this.controller,
    this.min = 0,
    this.max = 100,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
      validator: (v) => Validators.percentRange(v, min: min, max: max),
      decoration: InputDecoration(labelText: label, suffixText: '%'),
    );
  }
}
