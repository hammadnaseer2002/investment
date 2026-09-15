import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/section_card.dart';

class RoiCalculatorScreen extends StatefulWidget {
  const RoiCalculatorScreen({super.key});

  @override
  State<RoiCalculatorScreen> createState() => _RoiCalculatorScreenState();
}

class _RoiCalculatorScreenState extends State<RoiCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  double _totalInvestment = 5000000;
  double _netProfit = 500000;

  double? _roi;

  void _calculate() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _roi = (_netProfit / _totalInvestment) * 100;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final pct = NumberFormat.percentPattern()..maximumFractionDigits = 2;
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('ROI Calculator', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)), centerTitle: true),
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
                    initialValue: _totalInvestment.toStringAsFixed(0),
                    decoration: const InputDecoration(labelText: 'Total Investment Amount', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    onSaved: (v) => _totalInvestment = double.tryParse(v ?? '') ?? 0,
                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: _netProfit.toStringAsFixed(0),
                    decoration: const InputDecoration(labelText: 'Net Profit (Annual)', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    onSaved: (v) => _netProfit = double.tryParse(v ?? '') ?? 0,
                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 24),
                  PrimaryButton(label: 'Calculate ROI', onPressed: _calculate),
                ],
              ),
            ),
          ),
          if (_roi != null) ...[
            const SizedBox(height: 24),
            const Text('Results', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.darkNavy)),
            const SizedBox(height: 12),
            SectionCard(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Text('Return on Investment (ROI)', style: TextStyle(color: AppColors.textSecondary)),
                  const SizedBox(height: 8),
                  Text(pct.format(_roi! / 100), style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
