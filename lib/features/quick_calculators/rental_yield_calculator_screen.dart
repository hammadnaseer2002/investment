import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/section_card.dart';

class RentalYieldCalculatorScreen extends StatefulWidget {
  const RentalYieldCalculatorScreen({super.key});

  @override
  State<RentalYieldCalculatorScreen> createState() => _RentalYieldCalculatorScreenState();
}

class _RentalYieldCalculatorScreenState extends State<RentalYieldCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  double _propertyValue = 10000000;
  double _monthlyRent = 50000;

  double? _grossYield;

  void _calculate() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final annualRent = _monthlyRent * 12;
      _grossYield = (annualRent / _propertyValue) * 100;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final pct = NumberFormat.percentPattern()..maximumFractionDigits = 2;
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Rental Yield Calculator', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SectionCard(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    initialValue: _propertyValue.toStringAsFixed(0),
                    decoration: const InputDecoration(labelText: 'Property Value', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    onSaved: (v) => _propertyValue = double.tryParse(v ?? '') ?? 0,
                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: _monthlyRent.toStringAsFixed(0),
                    decoration: const InputDecoration(labelText: 'Monthly Rent', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    onSaved: (v) => _monthlyRent = double.tryParse(v ?? '') ?? 0,
                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 24),
                  PrimaryButton(label: 'Calculate Yield', onPressed: _calculate),
                ],
              ),
            ),
          ),
          if (_grossYield != null) ...[
            const SizedBox(height: 24),
            const Text('Results', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.darkNavy)),
            const SizedBox(height: 12),
            SectionCard(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Text('Gross Rental Yield', style: TextStyle(color: AppColors.textSecondary)),
                  const SizedBox(height: 8),
                  Text(pct.format(_grossYield! / 100), style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
