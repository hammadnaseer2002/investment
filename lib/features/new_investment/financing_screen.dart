import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/financing.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/bottom_action_bar.dart';
import '../../widgets/currency_input_field.dart';
import '../../widgets/percentage_input_field.dart';
import '../../widgets/progress_stepper.dart';
import 'new_investment_provider.dart';
import 'rental_income_screen.dart';

class FinancingScreen extends ConsumerStatefulWidget {
  const FinancingScreen({super.key});

  @override
  ConsumerState<FinancingScreen> createState() => _FinancingScreenState();
}

class _FinancingScreenState extends ConsumerState<FinancingScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoan = true;
  final _loanAmountCtrl = TextEditingController();
  final _rateCtrl = TextEditingController();
  String _term = '10 Years';

  @override
  void initState() {
    super.initState();
    final inv = ref.read(newInvestmentProvider);
    final f = inv.financing;
    _isLoan = f.isFinanced;
    if (f.loanAmount > 0) _loanAmountCtrl.text = f.loanAmount.toString();
    if (f.annualRatePercent > 0)
      _rateCtrl.text = f.annualRatePercent.toString();
    if (f.termYears > 0) _term = '${f.termYears} Years';
  }

  @override
  void dispose() {
    _loanAmountCtrl.dispose();
    _rateCtrl.dispose();
    super.dispose();
  }

  double get _loanAmount => double.tryParse(_loanAmountCtrl.text) ?? 0;
  double get _annualRate => double.tryParse(_rateCtrl.text) ?? 0;
  int get _termYears => int.tryParse(_term.split(' ')[0]) ?? 10;

  double get _monthlyPayment {
    if (_loanAmount <= 0 || _termYears <= 0) return 0;
    final monthlyRate = (_annualRate / 100) / 12;
    final numPayments = _termYears * 12;
    if (monthlyRate == 0) return _loanAmount / numPayments;
    final factor = pow(1 + monthlyRate, numPayments);
    return _loanAmount * (monthlyRate * factor) / (factor - 1);
  }

  double get _totalInterest {
    final numPayments = _termYears * 12;
    return (_monthlyPayment * numPayments) - _loanAmount;
  }

  void _next() {
    if (_isLoan && !_formKey.currentState!.validate()) return;

    ref.read(newInvestmentProvider.notifier).updateFinancing(
          Financing(
            isFinanced: _isLoan,
            downPayment:
                0, // This is derived/calculated later, or we don't capture it here. Wait, down payment is PurchasePrice + costs - loanAmount.
            loanAmount: _loanAmount,
            annualRatePercent: _annualRate,
            termYears: _termYears,
          ),
        );

    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const RentalIncomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final isLoanColor =
        _isLoan ? AppColors.primaryBlue : AppColors.cardBackground;
    final isLoanTextColor = _isLoan ? Colors.white : AppColors.textSecondary;
    final isCashColor =
        !_isLoan ? AppColors.primaryBlue : AppColors.cardBackground;
    final isCashTextColor = !_isLoan ? Colors.white : AppColors.textSecondary;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Financing / Loan',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const ProgressStepper(
            currentStep: 2,
            steps: [
              'Property',
              'Purchase',
              'Finance',
              'Rental',
              'Expenses',
              'Review'
            ],
          ),
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  // Custom Segmented Control to match UI
                  Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _isLoan = true),
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: isLoanColor,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.check,
                                      size: 16, color: isLoanTextColor),
                                  const SizedBox(width: 8),
                                  Text('Loan',
                                      style: TextStyle(
                                          color: isLoanTextColor,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _isLoan = false),
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: isCashColor,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.money_off,
                                      size: 16, color: isCashTextColor),
                                  const SizedBox(width: 8),
                                  Text('Cash Purchase',
                                      style: TextStyle(
                                          color: isCashTextColor,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (_isLoan) ...[
                    CurrencyInputField(
                        label: 'Loan Amount', controller: _loanAmountCtrl),
                    const SizedBox(height: 16),
                    PercentageInputField(
                        label: 'Interest Rate',
                        controller: _rateCtrl,
                        max: 100),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      initialValue: _term,
                      icon: const Icon(Icons.keyboard_arrow_down,
                          color: AppColors.textSecondary),
                      decoration: const InputDecoration(labelText: 'Loan Term'),
                      items: const [
                        '1 Years',
                        '2 Years',
                        '3 Years',
                        '4 Years',
                        '5 Years',
                        '10 Years',
                        '15 Years',
                        '20 Years',
                        '25 Years',
                        '30 Years'
                      ]
                          .map(
                              (t) => DropdownMenuItem(value: t, child: Text(t)))
                          .toList(),
                      onChanged: (v) => setState(() => _term = v ?? _term),
                    ),
                    const SizedBox(height: 24),
                    AnimatedBuilder(
                      animation: Listenable.merge([_loanAmountCtrl, _rateCtrl]),
                      builder: (_, __) => Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Monthly Payment',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.darkNavy)),
                                Text(
                                  'Rs ${_monthlyPayment.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.success,
                                      fontSize: 16),
                                ),
                              ],
                            ),
                            const Divider(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Total Interest',
                                    style: TextStyle(
                                        color: AppColors.textSecondary)),
                                Text('Rs ${_totalInterest.toStringAsFixed(0)}',
                                    style: const TextStyle(
                                        color: AppColors.textPrimary)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Total Loan Cost',
                                    style: TextStyle(
                                        color: AppColors.textSecondary)),
                                Text(
                                    'Rs ${(_loanAmount + _totalInterest).toStringAsFixed(0)}',
                                    style: const TextStyle(
                                        color: AppColors.textPrimary)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ] else
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 32),
                      child: Text(
                          'No financing details required for a cash purchase.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.textSecondary)),
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
