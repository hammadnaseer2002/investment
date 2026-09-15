import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/section_card.dart';

class AppreciationCalculatorScreen extends StatefulWidget {
  const AppreciationCalculatorScreen({super.key});

  @override
  State<AppreciationCalculatorScreen> createState() => _AppreciationCalculatorScreenState();
}

class _AppreciationCalculatorScreenState extends State<AppreciationCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  double _currentValue = 10000000;
  double _growthRate = 5.0;
  int _years = 5;

  double? _futureValue;
  double? _totalProfit;

  void _calculate() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _futureValue = _currentValue * pow(1 + (_growthRate / 100), _years);
      _totalProfit = _futureValue! - _currentValue;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.currency(symbol: 'Rs ', decimalDigits: 0);
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Appreciation Calculator', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)), centerTitle: true),
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
                    initialValue: _currentValue.toStringAsFixed(0),
                    decoration: const InputDecoration(labelText: 'Current Property Value', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    onSaved: (v) => _currentValue = double.tryParse(v ?? '') ?? 0,
                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: _growthRate.toStringAsFixed(1),
                    decoration: const InputDecoration(labelText: 'Expected Annual Growth Rate (%)', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    onSaved: (v) => _growthRate = double.tryParse(v ?? '') ?? 0,
                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: _years.toString(),
                    decoration: const InputDecoration(labelText: 'Years to Hold', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    onSaved: (v) => _years = int.tryParse(v ?? '') ?? 0,
                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 24),
                  PrimaryButton(label: 'Calculate Future Value', onPressed: _calculate),
                ],
              ),
            ),
          ),
          if (_futureValue != null) ...[
            const SizedBox(height: 24),
            const Text('Results', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.darkNavy)),
            const SizedBox(height: 12),
            SectionCard(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Text('Estimated Future Value', style: TextStyle(color: AppColors.textSecondary)),
                  const SizedBox(height: 8),
                  Text(fmt.format(_futureValue), style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
                  const Divider(height: 32),
                  _ResultRow(label: 'Total Value Gained', value: fmt.format(_totalProfit), color: AppColors.success),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;
  const _ResultRow({required this.label, required this.value, this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textSecondary)),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }
}
