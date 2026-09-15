import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/section_card.dart';

class CashFlowCalculatorScreen extends StatefulWidget {
  const CashFlowCalculatorScreen({super.key});

  @override
  State<CashFlowCalculatorScreen> createState() => _CashFlowCalculatorScreenState();
}

class _CashFlowCalculatorScreenState extends State<CashFlowCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  double _monthlyRent = 50000;
  double _monthlyMortgage = 20000;
  double _monthlyExpenses = 5000;

  double? _monthlyCashFlow;
  double? _annualCashFlow;

  void _calculate() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _monthlyCashFlow = _monthlyRent - _monthlyMortgage - _monthlyExpenses;
      _annualCashFlow = _monthlyCashFlow! * 12;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.currency(symbol: 'Rs ', decimalDigits: 0);
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Cash Flow Analysis', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)), centerTitle: true),
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
                    initialValue: _monthlyRent.toStringAsFixed(0),
                    decoration: const InputDecoration(labelText: 'Monthly Rent Income', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    onSaved: (v) => _monthlyRent = double.tryParse(v ?? '') ?? 0,
                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: _monthlyMortgage.toStringAsFixed(0),
                    decoration: const InputDecoration(labelText: 'Monthly Mortgage Payment', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    onSaved: (v) => _monthlyMortgage = double.tryParse(v ?? '') ?? 0,
                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: _monthlyExpenses.toStringAsFixed(0),
                    decoration: const InputDecoration(labelText: 'Other Monthly Expenses (Tax, Maint, etc)', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    onSaved: (v) => _monthlyExpenses = double.tryParse(v ?? '') ?? 0,
                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 24),
                  PrimaryButton(label: 'Calculate Cash Flow', onPressed: _calculate),
                ],
              ),
            ),
          ),
          if (_monthlyCashFlow != null) ...[
            const SizedBox(height: 24),
            const Text('Results', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.darkNavy)),
            const SizedBox(height: 12),
            SectionCard(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Text('Monthly Cash Flow', style: TextStyle(color: AppColors.textSecondary)),
                  const SizedBox(height: 8),
                  Text(fmt.format(_monthlyCashFlow), style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: _monthlyCashFlow! >= 0 ? AppColors.success : Colors.red)),
                  const Divider(height: 32),
                  _ResultRow(label: 'Annual Cash Flow', value: fmt.format(_annualCashFlow), color: _annualCashFlow! >= 0 ? AppColors.success : Colors.red),
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
