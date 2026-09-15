import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/property_expenses.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/bottom_action_bar.dart';
import '../../widgets/currency_input_field.dart';
import '../../widgets/progress_stepper.dart';
import '../investment_analysis/investment_analysis_screen.dart';
import 'new_investment_provider.dart';

class PropertyExpensesScreen extends ConsumerStatefulWidget {
  const PropertyExpensesScreen({super.key});

  @override
  ConsumerState<PropertyExpensesScreen> createState() => _PropertyExpensesScreenState();
}

class _PropertyExpensesScreenState extends ConsumerState<PropertyExpensesScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isAnnual = true;
  final _taxCtrl = TextEditingController();
  final _maintenanceCtrl = TextEditingController();
  final _hoaCtrl = TextEditingController();
  final _insuranceCtrl = TextEditingController();
  final _repairsCtrl = TextEditingController();
  final _managementCtrl = TextEditingController();
  final _utilitiesCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    final inv = ref.read(newInvestmentProvider);
    final e = inv.expenses;
    if (e.propertyTax > 0) _taxCtrl.text = e.propertyTax.toString();
    if (e.maintenance > 0) _maintenanceCtrl.text = e.maintenance.toString();
    if (e.hoaServiceCharges > 0) _hoaCtrl.text = e.hoaServiceCharges.toString();
    if (e.insurance > 0) _insuranceCtrl.text = e.insurance.toString();
    if (e.other > 0) _repairsCtrl.text = e.other.toString();
    if (e.managementFee > 0) _managementCtrl.text = e.managementFee.toString();
    if (e.ownerPaidUtilities > 0) _utilitiesCtrl.text = e.ownerPaidUtilities.toString();
  }

  @override
  void dispose() {
    _taxCtrl.dispose();
    _maintenanceCtrl.dispose();
    _hoaCtrl.dispose();
    _insuranceCtrl.dispose();
    _repairsCtrl.dispose();
    _managementCtrl.dispose();
    _utilitiesCtrl.dispose();
    super.dispose();
  }

  double _val(TextEditingController ctrl) => double.tryParse(ctrl.text) ?? 0;

  double get _totalEntered =>
      _val(_taxCtrl) +
      _val(_maintenanceCtrl) +
      _val(_hoaCtrl) +
      _val(_insuranceCtrl) +
      _val(_repairsCtrl) +
      _val(_managementCtrl) +
      _val(_utilitiesCtrl);

  void _next() {
    if (!_formKey.currentState!.validate()) return;
    
    final multiplier = _isAnnual ? 1 : 12;
    ref.read(newInvestmentProvider.notifier).updateExpenses(
      PropertyExpenses(
        propertyTax: _val(_taxCtrl) * multiplier,
        maintenance: _val(_maintenanceCtrl) * multiplier,
        hoaServiceCharges: _val(_hoaCtrl) * multiplier,
        insurance: _val(_insuranceCtrl) * multiplier,
        other: _val(_repairsCtrl) * multiplier, // Map repairs to other
        managementFee: _val(_managementCtrl) * multiplier,
        ownerPaidUtilities: _val(_utilitiesCtrl) * multiplier,
      ),
    );

    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const InvestmentAnalysisScreen()));
  }

  void _togglePeriod(bool isAnnual) {
    if (_isAnnual == isAnnual) return;
    
    // Convert current values to the new period
    final factor = isAnnual ? 12.0 : (1 / 12.0);
    
    void updateCtrl(TextEditingController ctrl) {
      final val = double.tryParse(ctrl.text);
      if (val != null && val > 0) {
        ctrl.text = (val * factor).toStringAsFixed(0);
      }
    }

    setState(() {
      _isAnnual = isAnnual;
      updateCtrl(_taxCtrl);
      updateCtrl(_maintenanceCtrl);
      updateCtrl(_hoaCtrl);
      updateCtrl(_insuranceCtrl);
      updateCtrl(_repairsCtrl);
      updateCtrl(_managementCtrl);
      updateCtrl(_utilitiesCtrl);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isAnnualColor = _isAnnual ? AppColors.primaryBlue : AppColors.cardBackground;
    final isAnnualTextColor = _isAnnual ? Colors.white : AppColors.textSecondary;
    final isMonthlyColor = !_isAnnual ? AppColors.primaryBlue : AppColors.cardBackground;
    final isMonthlyTextColor = !_isAnnual ? Colors.white : AppColors.textSecondary;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Property Expenses', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const ProgressStepper(
            currentStep: 4,
            steps: ['Property', 'Purchase', 'Finance', 'Rental', 'Expenses', 'Review'],
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
                            onTap: () => _togglePeriod(true),
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: isAnnualColor,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Text('Annual', style: TextStyle(color: isAnnualTextColor, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _togglePeriod(false),
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: isMonthlyColor,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Text('Monthly', style: TextStyle(color: isMonthlyTextColor, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  CurrencyInputField(label: 'Property Tax', controller: _taxCtrl, optional: true, prefixIcon: const Icon(Icons.account_balance_outlined, size: 18)),
                  const SizedBox(height: 12),
                  CurrencyInputField(label: 'Maintenance', controller: _maintenanceCtrl, optional: true, prefixIcon: const Icon(Icons.handyman_outlined, size: 18)),
                  const SizedBox(height: 12),
                  CurrencyInputField(label: 'Society Charges', controller: _hoaCtrl, optional: true, prefixIcon: const Icon(Icons.home_work_outlined, size: 18)),
                  const SizedBox(height: 12),
                  CurrencyInputField(label: 'Insurance', controller: _insuranceCtrl, optional: true, prefixIcon: const Icon(Icons.security_outlined, size: 18)),
                  const SizedBox(height: 12),
                  CurrencyInputField(label: 'Repairs', controller: _repairsCtrl, optional: true, prefixIcon: const Icon(Icons.build_outlined, size: 18)),
                  const SizedBox(height: 12),
                  CurrencyInputField(label: 'Management Fee', controller: _managementCtrl, optional: true, prefixIcon: const Icon(Icons.support_agent_outlined, size: 18)),
                  const SizedBox(height: 12),
                  CurrencyInputField(label: 'Utilities (Owner Paid)', controller: _utilitiesCtrl, optional: true, prefixIcon: const Icon(Icons.bolt_outlined, size: 18)),
                  const SizedBox(height: 24),
                  AnimatedBuilder(
                    animation: Listenable.merge([
                      _taxCtrl, _maintenanceCtrl, _hoaCtrl, _insuranceCtrl, _repairsCtrl, _managementCtrl, _utilitiesCtrl
                    ]),
                    builder: (_, __) => Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total Expenses (${_isAnnual ? 'Annual' : 'Monthly'})', style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.darkNavy)),
                          Text(
                            'Rs ${_totalEntered.toStringAsFixed(0)}',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.success, fontSize: 16),
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
