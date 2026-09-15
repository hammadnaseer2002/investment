import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/section_card.dart';
import '../../core/models/investment.dart';
import '../../core/calculation/investment_calculator.dart';
import '../../core/services/pdf_report_service.dart';
import '../dashboard/dashboard_screen.dart'; // for allInvestmentsProvider

class FinalReportScreen extends ConsumerStatefulWidget {
  final Investment? initialInvestment;
  const FinalReportScreen({super.key, this.initialInvestment});

  @override
  ConsumerState<FinalReportScreen> createState() => _FinalReportScreenState();
}

class _FinalReportScreenState extends ConsumerState<FinalReportScreen> {
  Investment? _selectedInvestment;
  bool _isGenerating = false;

  @override
  void initState() {
    super.initState();
    _selectedInvestment = widget.initialInvestment;
  }

  Future<void> _generatePdf(Investment inv) async {
    setState(() => _isGenerating = true);
    try {
      final analysis = InvestmentCalculator.analyze(inv);
      final pdfFile = await PdfReportService.generate(inv, analysis);
      await PdfReportService.share(pdfFile);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to generate PDF: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isGenerating = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final asyncInvestments = ref.watch(allInvestmentsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Final Report', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: asyncInvestments.when(
        data: (investments) {
          if (investments.isEmpty) {
            return const Center(child: Text('No investments saved. Create one first!'));
          }
          
          final inv = _selectedInvestment ?? investments.first;
          final analysis = InvestmentCalculator.analyze(inv);
          final fmt = NumberFormat.currency(symbol: 'Rs ', decimalDigits: 0);
          final pct = NumberFormat.percentPattern()..maximumFractionDigits = 2;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (investments.length > 1) ...[
                DropdownButtonFormField<Investment>(
                  decoration: const InputDecoration(labelText: 'Select Investment', border: OutlineInputBorder()),
                  initialValue: inv,
                  items: investments.map((e) => DropdownMenuItem(value: e, child: Text('${e.name} - ${e.location}'))).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedInvestment = val);
                  },
                ),
                const SizedBox(height: 16),
              ],
              SectionCard(
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(color: AppColors.primaryBlue.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.home_outlined, color: AppColors.primaryBlue),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(inv.name.isNotEmpty ? inv.name : 'Property', style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text(inv.location.isNotEmpty ? inv.location : 'Unknown Location', style: const TextStyle(color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Total Investment', style: TextStyle(color: AppColors.textSecondary)),
                    Text(fmt.format(analysis.totalInvestment), style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppColors.primaryBlue, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text('Key Highlights', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              SectionCard(
                child: Column(
                  children: [
                    _HighlightRow(label: 'Net Rental Yield', value: pct.format(analysis.netYieldPercent / 100)),
                    _HighlightRow(label: 'ROI (Annual)', value: pct.format(analysis.roiPercent / 100)),
                    _HighlightRow(label: 'Break-even Period', value: '${analysis.breakEvenYears.toStringAsFixed(1)} Years'),
                    _HighlightRow(label: 'Monthly Cash Flow', value: fmt.format(analysis.monthlyCashFlow)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SectionCard(
                child: Row(
                  children: [
                    Icon(analysis.roiPercent > 5 ? Icons.check_circle : Icons.info, color: analysis.roiPercent > 5 ? AppColors.success : AppColors.primaryBlue),
                    const SizedBox(width: 8),
                    Expanded(child: Text(analysis.roiPercent > 5 ? 'Good Investment Potential' : 'Moderate Investment Potential', style: const TextStyle(fontWeight: FontWeight.w500))),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _isGenerating 
                ? const Center(child: CircularProgressIndicator())
                : PrimaryButton(
                    label: 'Generate & Download PDF', 
                    onPressed: () => _generatePdf(inv),
                  ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}

class _HighlightRow extends StatelessWidget {
  final String label;
  final String value;
  const _HighlightRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(label, style: const TextStyle(color: AppColors.textSecondary)), Text(value, style: const TextStyle(fontWeight: FontWeight.bold))],
      ),
    );
  }
}
