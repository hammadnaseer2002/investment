import 'package:flutter/material.dart';
import '../../widgets/currency_input_field.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/section_card.dart';

/// Sell Property calculator (RDP section 16).
/// Net Sale Proceeds = Sale Price - Selling Costs - Remaining Loan Balance.
class SellPropertyScreen extends StatefulWidget {
  const SellPropertyScreen({super.key});

  @override
  State<SellPropertyScreen> createState() => _SellPropertyScreenState();
}

class _SellPropertyScreenState extends State<SellPropertyScreen> {
  final _currentValueCtrl = TextEditingController();
  final _originalPriceCtrl = TextEditingController();
  final _remainingLoanCtrl = TextEditingController();
  final _sellingFeesCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sell Property')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SectionCard(
            child: Column(
              children: [
                CurrencyInputField(label: 'Current / Sale Value', controller: _currentValueCtrl),
                const SizedBox(height: 12),
                CurrencyInputField(label: 'Original Purchase Price', controller: _originalPriceCtrl),
                const SizedBox(height: 12),
                CurrencyInputField(label: 'Remaining Loan Balance', controller: _remainingLoanCtrl, optional: true),
                const SizedBox(height: 12),
                CurrencyInputField(label: 'Selling Fees / Taxes', controller: _sellingFeesCtrl, optional: true),
              ],
            ),
          ),
          const SizedBox(height: 24),
          PrimaryButton(label: 'Calculate Net Proceeds', onPressed: () {}),
        ],
      ),
    );
  }
}
