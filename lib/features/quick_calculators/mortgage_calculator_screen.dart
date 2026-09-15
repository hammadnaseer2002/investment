import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/section_card.dart';

class MortgageCalculatorScreen extends StatefulWidget {
  const MortgageCalculatorScreen({super.key});

  @override
  State<MortgageCalculatorScreen> createState() => _MortgageCalculatorScreenState();
}

class _MortgageCalculatorScreenState extends State<MortgageCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  double _principal = 10000000;
  double _rate = 12.0;
  int _years = 20;

  double? _monthlyPayment;
  double? _totalPayment;
  double? _totalInterest;

  void _calculate() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      final r = (_rate / 100) / 12;
      final n = _years * 12;
      
      if (r == 0) {
        _monthlyPayment = _principal / n;
      } else {
        _monthlyPayment = _principal * (r * pow(1 + r, n)) / (pow(1 + r, n) - 1);
      }
      
      _totalPayment = _monthlyPayment! * n;
      _totalInterest = _totalPayment! - _principal;
      
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.currency(symbol: 'Rs ', decimalDigits: 0);
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Mortgage Calculator', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)), centerTitle: true),
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
                    initialValue: _principal.toStringAsFixed(0),
                    decoration: const InputDecoration(labelText: 'Loan Amount (Principal)', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    onSaved: (v) => _principal = double.tryParse(v ?? '') ?? 0,
                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: _rate.toStringAsFixed(1),
                    decoration: const InputDecoration(labelText: 'Annual Interest Rate (%)', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    onSaved: (v) => _rate = double.tryParse(v ?? '') ?? 0,
                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: _years.toString(),
                    decoration: const InputDecoration(labelText: 'Loan Term (Years)', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    onSaved: (v) => _years = int.tryParse(v ?? '') ?? 0,
                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 24),
                  PrimaryButton(label: 'Calculate', onPressed: _calculate),
                ],
              ),
            ),
          ),
          if (_monthlyPayment != null) ...[
            const SizedBox(height: 24),
            const Text('Results', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.darkNavy)),
            const SizedBox(height: 12),
            SectionCard(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Text('Estimated Monthly Payment', style: TextStyle(color: AppColors.textSecondary)),
                  const SizedBox(height: 8),
                  Text(fmt.format(_monthlyPayment), style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
                  const Divider(height: 32),
                  _ResultRow(label: 'Total Principal', value: fmt.format(_principal)),
                  const SizedBox(height: 12),
                  _ResultRow(label: 'Total Interest', value: fmt.format(_totalInterest)),
                  const SizedBox(height: 12),
                  _ResultRow(label: 'Total Payment', value: fmt.format(_totalPayment)),
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
  const _ResultRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textSecondary)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
