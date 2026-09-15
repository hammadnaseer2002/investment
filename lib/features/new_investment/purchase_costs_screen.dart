import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/purchase_costs.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/bottom_action_bar.dart';
import '../../widgets/currency_input_field.dart';
import '../../widgets/progress_stepper.dart';
import 'financing_screen.dart';
import 'new_investment_provider.dart';

class PurchaseCostsScreen extends ConsumerStatefulWidget {
  const PurchaseCostsScreen({super.key});

  @override
  ConsumerState<PurchaseCostsScreen> createState() => _PurchaseCostsScreenState();
}

class _PurchaseCostsScreenState extends ConsumerState<PurchaseCostsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _priceCtrl = TextEditingController();
  final _registrationCtrl = TextEditingController();
  final _transferCtrl = TextEditingController();
  final _stampDutyCtrl = TextEditingController();
  final _commissionCtrl = TextEditingController();
  final _legalCtrl = TextEditingController();
  final _renovationCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    final inv = ref.read(newInvestmentProvider);
    if (inv.purchasePrice > 0) _priceCtrl.text = inv.purchasePrice.toString();
    final c = inv.purchaseCosts;
    if (c.registration > 0) _registrationCtrl.text = c.registration.toString();
    if (c.transferTax > 0) _transferCtrl.text = c.transferTax.toString();
    if (c.legalFee > 0) _stampDutyCtrl.text = c.legalFee.toString();
    if (c.brokerCommission > 0) _commissionCtrl.text = c.brokerCommission.toString();
    if (c.other > 0) _legalCtrl.text = c.other.toString();
    if (c.renovation > 0) _renovationCtrl.text = c.renovation.toString();
  }

  @override
  void dispose() {
    _priceCtrl.dispose();
    _registrationCtrl.dispose();
    _transferCtrl.dispose();
    _stampDutyCtrl.dispose();
    _commissionCtrl.dispose();
    _legalCtrl.dispose();
    _renovationCtrl.dispose();
    super.dispose();
  }

  double get _total {
    double n(String s) => double.tryParse(s) ?? 0;
    return n(_priceCtrl.text) +
        n(_registrationCtrl.text) +
        n(_transferCtrl.text) +
        n(_stampDutyCtrl.text) +
        n(_commissionCtrl.text) +
        n(_legalCtrl.text) +
        n(_renovationCtrl.text);
  }

  void _next() {
    if (!_formKey.currentState!.validate()) return;
    
    double n(String s) => double.tryParse(s) ?? 0;
    ref.read(newInvestmentProvider.notifier).updatePurchaseCosts(
      price: n(_priceCtrl.text),
      costs: PurchaseCosts(
        registration: n(_registrationCtrl.text),
        transferTax: n(_transferCtrl.text),
        legalFee: n(_stampDutyCtrl.text),
        brokerCommission: n(_commissionCtrl.text),
        other: n(_legalCtrl.text),
        renovation: n(_renovationCtrl.text),
      ),
    );

    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const FinancingScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Purchase Costs', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const ProgressStepper(
            currentStep: 1,
            steps: ['Property', 'Purchase', 'Finance', 'Rental', 'Expenses', 'Review'],
          ),
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  CurrencyInputField(label: 'Property Purchase Price', controller: _priceCtrl),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const Icon(Icons.account_balance_wallet_outlined, color: AppColors.primaryBlue, size: 18),
                      const SizedBox(width: 8),
                      Text('Additional Costs', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: AppColors.darkNavy)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  CurrencyInputField(label: 'Registration Fee', controller: _registrationCtrl, optional: true, prefixIcon: const Icon(Icons.receipt_long_outlined, size: 18)),
                  const SizedBox(height: 12),
                  CurrencyInputField(label: 'Transfer Fee', controller: _transferCtrl, optional: true, prefixIcon: const Icon(Icons.swap_horiz, size: 18)),
                  const SizedBox(height: 12),
                  CurrencyInputField(label: 'Stamp Duty', controller: _stampDutyCtrl, optional: true, prefixIcon: const Icon(Icons.gavel_outlined, size: 18)),
                  const SizedBox(height: 12),
                  CurrencyInputField(label: 'Agent Commission', controller: _commissionCtrl, optional: true, prefixIcon: const Icon(Icons.person_outline, size: 18)),
                  const SizedBox(height: 12),
                  CurrencyInputField(label: 'Legal Fee', controller: _legalCtrl, optional: true, prefixIcon: const Icon(Icons.account_balance_outlined, size: 18)),
                  const SizedBox(height: 12),
                  CurrencyInputField(label: 'Renovation', controller: _renovationCtrl, optional: true, prefixIcon: const Icon(Icons.build_outlined, size: 18)),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Investment Cost', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.darkNavy)),
                        AnimatedBuilder(
                          animation: Listenable.merge([
                            _priceCtrl, _registrationCtrl, _transferCtrl, _stampDutyCtrl, _commissionCtrl, _legalCtrl, _renovationCtrl,
                          ]),
                          builder: (_, __) => Text(
                            'Rs ${_total.toStringAsFixed(0)}',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.success, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          BottomActionBar(
            onBack: () => Navigator.of(context).pop(),
            onNext: _next,
          ),
        ],
      ),
    );
  }
}
