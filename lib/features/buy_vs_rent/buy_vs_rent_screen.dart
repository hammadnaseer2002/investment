import 'package:flutter/material.dart';
import '../../widgets/currency_input_field.dart';
import '../../widgets/percentage_input_field.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/section_card.dart';

/// Buy vs Rent calculator (RDP section 15).
class BuyVsRentScreen extends StatefulWidget {
  const BuyVsRentScreen({super.key});

  @override
  State<BuyVsRentScreen> createState() => _BuyVsRentScreenState();
}

class _BuyVsRentScreenState extends State<BuyVsRentScreen> {
  bool _buy = true;
  final _priceCtrl = TextEditingController();
  final _downPaymentCtrl = TextEditingController();
  final _loanAmountCtrl = TextEditingController();
  final _rateCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buy vs Rent')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SegmentedButton<bool>(
            segments: const [
              ButtonSegment(value: true, label: Text('Buy')),
              ButtonSegment(value: false, label: Text('Rent')),
            ],
            selected: {_buy},
            onSelectionChanged: (s) => setState(() => _buy = s.first),
          ),
          const SizedBox(height: 16),
          SectionCard(
            child: Column(
              children: [
                CurrencyInputField(label: 'Property Price', controller: _priceCtrl),
                const SizedBox(height: 12),
                CurrencyInputField(label: 'Down Payment', controller: _downPaymentCtrl),
                const SizedBox(height: 12),
                CurrencyInputField(label: 'Loan Amount', controller: _loanAmountCtrl),
                const SizedBox(height: 12),
                PercentageInputField(label: 'Interest Rate', controller: _rateCtrl),
              ],
            ),
          ),
          const SizedBox(height: 24),
          PrimaryButton(label: 'Calculate', onPressed: () {}),
        ],
      ),
    );
  }
}
