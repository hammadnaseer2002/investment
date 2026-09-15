import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/rental_income.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/bottom_action_bar.dart';
import '../../widgets/currency_input_field.dart';
import '../../widgets/percentage_input_field.dart';
import '../../widgets/progress_stepper.dart';
import 'new_investment_provider.dart';
import 'property_expenses_screen.dart';

class RentalIncomeScreen extends ConsumerStatefulWidget {
  const RentalIncomeScreen({super.key});

  @override
  ConsumerState<RentalIncomeScreen> createState() => _RentalIncomeScreenState();
}

class _RentalIncomeScreenState extends ConsumerState<RentalIncomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _monthlyRentCtrl = TextEditingController();
  final _parkingCtrl = TextEditingController();
  final _otherCtrl = TextEditingController();
  final _vacancyCtrl = TextEditingController(text: '8'); // 8% default from UI

  @override
  void initState() {
    super.initState();
    final inv = ref.read(newInvestmentProvider);
    final r = inv.rentalIncome;
    if (r.monthlyRent > 0) _monthlyRentCtrl.text = r.monthlyRent.toString();
    if (r.otherAnnualIncome > 0) _otherCtrl.text = r.otherAnnualIncome.toString();
    if (r.vacancyRatePercent > 0) _vacancyCtrl.text = r.vacancyRatePercent.toString();
  }

  @override
  void dispose() {
    _monthlyRentCtrl.dispose();
    _parkingCtrl.dispose();
    _otherCtrl.dispose();
    _vacancyCtrl.dispose();
    super.dispose();
  }

  double get _monthlyRent => double.tryParse(_monthlyRentCtrl.text) ?? 0;
  double get _parkingIncome => double.tryParse(_parkingCtrl.text) ?? 0;
  double get _otherIncome => double.tryParse(_otherCtrl.text) ?? 0;
  double get _vacancyRate => (double.tryParse(_vacancyCtrl.text) ?? 0).clamp(0, 100) / 100;

  double get _annualGrossRent => (_monthlyRent * 12) + _parkingIncome + _otherIncome;
  double get _effectiveAnnualRent => _annualGrossRent * (1 - _vacancyRate);

  void _next() {
    if (!_formKey.currentState!.validate()) return;
    
    ref.read(newInvestmentProvider.notifier).updateRentalIncome(
      RentalIncome(
        monthlyRent: _monthlyRent,
        otherAnnualIncome: _parkingIncome + _otherIncome,
        vacancyRatePercent: _vacancyRate * 100,
      ),
    );

    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PropertyExpensesScreen()));
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
        title: const Text('Rental Income', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const ProgressStepper(
            currentStep: 3,
            steps: ['Property', 'Purchase', 'Finance', 'Rental', 'Expenses', 'Review'],
          ),
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  CurrencyInputField(label: 'Monthly Rent', controller: _monthlyRentCtrl),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const Icon(Icons.add_circle_outline, color: AppColors.primaryBlue, size: 18),
                      const SizedBox(width: 8),
                      Text('Additional Income (Optional)', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: AppColors.darkNavy)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  CurrencyInputField(label: 'Parking', controller: _parkingCtrl, optional: true, prefixIcon: const Icon(Icons.local_parking, size: 18)),
                  const SizedBox(height: 12),
                  CurrencyInputField(label: 'Other Income', controller: _otherCtrl, optional: true, prefixIcon: const Icon(Icons.monetization_on_outlined, size: 18)),
                  const SizedBox(height: 24),
                  PercentageInputField(label: 'Vacancy Rate', controller: _vacancyCtrl),
                  const SizedBox(height: 24),
                  AnimatedBuilder(
                    animation: Listenable.merge([_monthlyRentCtrl, _parkingCtrl, _otherCtrl, _vacancyCtrl]),
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
                              const Text('Annual Gross Rent', style: TextStyle(color: AppColors.textSecondary)),
                              Text('Rs ${_annualGrossRent.toStringAsFixed(0)}', style: const TextStyle(color: AppColors.textPrimary)),
                            ],
                          ),
                          const Divider(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Effective Annual Rent', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.darkNavy)),
                              Text(
                                'Rs ${_effectiveAnnualRent.toStringAsFixed(0)}',
                                style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.success, fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
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
