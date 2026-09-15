import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/models/investment.dart';
import '../../core/calculation/investment_calculator.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/section_card.dart';
import '../dashboard/dashboard_screen.dart'; // for allInvestmentsProvider

class ComparePropertiesScreen extends ConsumerStatefulWidget {
  const ComparePropertiesScreen({super.key});

  @override
  ConsumerState<ComparePropertiesScreen> createState() => _ComparePropertiesScreenState();
}

class _ComparePropertiesScreenState extends ConsumerState<ComparePropertiesScreen> {
  Investment? _prop1;
  Investment? _prop2;
  bool _showComparison = false;

  Widget _buildPropSelector(String label, Investment? current, List<Investment> options, ValueChanged<Investment?> onChanged) {
    return DropdownButtonFormField<Investment>(
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      initialValue: current,
      isExpanded: true,
      items: options.map((e) => DropdownMenuItem(value: e, child: Text('${e.name} - ${e.location}'))).toList(),
      onChanged: onChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    final asyncInvestments = ref.watch(allInvestmentsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Compare Properties', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)), centerTitle: true),
      body: asyncInvestments.when(
        data: (investments) {
          if (investments.length < 2) {
            return const Center(child: Padding(padding: EdgeInsets.all(16), child: Text('Save at least 2 investments to compare them.', textAlign: TextAlign.center)));
          }

          if (_prop1 == null && investments.isNotEmpty) _prop1 = investments[0];
          if (_prop2 == null && investments.length > 1) _prop2 = investments[1];

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              SectionCard(
                child: Column(
                  children: [
                    _buildPropSelector('Property 1', _prop1, investments, (v) => setState(() { _prop1 = v; _showComparison = false; })),
                    const SizedBox(height: 16),
                    _buildPropSelector('Property 2', _prop2, investments, (v) => setState(() { _prop2 = v; _showComparison = false; })),
                    const SizedBox(height: 16),
                    PrimaryButton(label: 'Compare Now', onPressed: _prop1 != null && _prop2 != null ? () => setState(() => _showComparison = true) : null),
                  ],
                ),
              ),
              if (_showComparison && _prop1 != null && _prop2 != null) ...[
                const SizedBox(height: 24),
                const Text('Comparison Results', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.darkNavy)),
                const SizedBox(height: 12),
                SectionCard(
                  padding: EdgeInsets.zero,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Builder(
                      builder: (context) {
                        final fmt = NumberFormat.currency(symbol: 'Rs ', decimalDigits: 0);
                        final pct = NumberFormat.percentPattern()..maximumFractionDigits = 2;
                        final a1 = InvestmentCalculator.analyze(_prop1!);
                        final a2 = InvestmentCalculator.analyze(_prop2!);
                        
                        DataRow buildRow(String label, String v1, String v2, {bool highlight = false, bool isEven = false}) {
                          final color = isEven ? AppColors.primaryBlue.withValues(alpha: 0.04) : Colors.transparent;
                          final style = TextStyle(fontWeight: highlight ? FontWeight.bold : FontWeight.normal, color: highlight ? AppColors.primaryBlue : AppColors.textPrimary);
                          return DataRow(
                            color: WidgetStateProperty.all(color),
                            cells: [
                              DataCell(Text(label, style: const TextStyle(fontWeight: FontWeight.w500, color: AppColors.textSecondary))),
                              DataCell(Text(v1, style: style)),
                              DataCell(Text(v2, style: style)),
                            ],
                          );
                        }

                        return Theme(
                          data: Theme.of(context).copyWith(
                            dataTableTheme: DataTableThemeData(
                              headingRowColor: WidgetStateProperty.all(AppColors.primaryBlue.withValues(alpha: 0.1)),
                            ),
                          ),
                          child: DataTable(
                            columnSpacing: 32,
                            headingTextStyle: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryBlue),
                            columns: [
                              const DataColumn(label: Text('Metric')),
                              DataColumn(label: Text(_prop1!.name)),
                              DataColumn(label: Text(_prop2!.name)),
                            ],
                            rows: [
                              buildRow('Purchase Price', fmt.format(_prop1!.purchasePrice), fmt.format(_prop2!.purchasePrice), isEven: false),
                              buildRow('Total Cost', fmt.format(a1.totalInvestment), fmt.format(a2.totalInvestment), isEven: true),
                              buildRow('Monthly Cash Flow', fmt.format(a1.monthlyCashFlow), fmt.format(a2.monthlyCashFlow), highlight: true, isEven: false),
                              buildRow('Gross Yield', pct.format(a1.grossYieldPercent / 100), pct.format(a2.grossYieldPercent / 100), isEven: true),
                              buildRow('Net Yield', pct.format(a1.netYieldPercent / 100), pct.format(a2.netYieldPercent / 100), isEven: false),
                              buildRow('ROI (Annual)', pct.format(a1.roiPercent / 100), pct.format(a2.roiPercent / 100), highlight: true, isEven: true),
                              buildRow('Break-even', '${a1.breakEvenYears.toStringAsFixed(1)} yrs', '${a2.breakEvenYears.toStringAsFixed(1)} yrs', isEven: false),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
