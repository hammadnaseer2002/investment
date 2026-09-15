import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/calculation/investment_calculator.dart';
import '../../core/theme/app_colors.dart';
import '../../core/storage/investment_repository.dart';
import '../../core/services/pdf_report_service.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/section_card.dart';
import '../new_investment/new_investment_provider.dart';

import '../dashboard/dashboard_screen.dart';

class InvestmentAnalysisScreen extends ConsumerStatefulWidget {
  const InvestmentAnalysisScreen({super.key});

  @override
  ConsumerState<InvestmentAnalysisScreen> createState() => _InvestmentAnalysisScreenState();
}

class _InvestmentAnalysisScreenState extends ConsumerState<InvestmentAnalysisScreen> {
  bool _isGeneratingPdf = false;

  @override
  Widget build(BuildContext context) {
    final inv = ref.watch(newInvestmentProvider);
    final analysis = InvestmentCalculator.analyze(inv);
    final currencyFormat = NumberFormat.currency(symbol: 'Rs ', decimalDigits: 0);
    
    // Workaround for down payment
    final effectiveDownPayment = inv.financing.isFinanced 
        ? (inv.purchasePrice - inv.financing.loanAmount) 
        : inv.purchasePrice;
    
    // Custom calculation to override ROI if down payment wasn't explicitly saved
    final totalInvested = effectiveDownPayment + inv.purchaseCosts.total;
    final breakEven = analysis.annualCashFlow > 0 ? (totalInvested / analysis.annualCashFlow) : double.infinity;

    Future<void> saveInvestment() async {
      try {
        final repo = ref.read(investmentRepositoryProvider);
        final finalInv = inv.copyWith(
          financing: inv.financing.copyWith(downPayment: effectiveDownPayment),
        );
        await repo.save(finalInv);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Investment saved successfully!')),
          );
          ref.invalidate(allInvestmentsProvider);
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error saving investment: $e')),
          );
        }
      }
    }

    Future<void> generatePdf() async {
      setState(() => _isGeneratingPdf = true);
      try {
        final pdfFile = await PdfReportService.generate(inv, analysis);
        await PdfReportService.share(pdfFile);
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to generate PDF: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isGeneratingPdf = false);
        }
      }
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Analysis Results', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primaryBlue, AppColors.darkNavy],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('Total Investment Cost', style: TextStyle(color: Colors.white70, fontSize: 14)),
                const SizedBox(height: 8),
                Text(
                  currencyFormat.format(totalInvested),
                  style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: _MetricCard(label: 'Gross Rental Yield', value: '${analysis.grossYieldPercent.toStringAsFixed(2)}%')),
              const SizedBox(width: 16),
              Expanded(child: _MetricCard(label: 'Net Rental Yield', value: '${analysis.netYieldPercent.toStringAsFixed(2)}%')),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _MetricCard(label: 'Monthly Cash Flow', value: currencyFormat.format(analysis.monthlyCashFlow))),
              const SizedBox(width: 16),
              Expanded(child: _MetricCard(label: 'Break-even Period', value: breakEven == double.infinity ? 'N/A' : '${breakEven.toStringAsFixed(1)} Yrs')),
            ],
          ),
          const SizedBox(height: 16),
          SectionCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _SummaryRow(label: 'Annual Gross Rent', value: currencyFormat.format(InvestmentCalculator.annualGrossRent(inv))),
                const Divider(height: 24),
                _SummaryRow(label: 'Operating Expenses', value: currencyFormat.format(inv.expenses.totalAnnual)),
                const Divider(height: 24),
                _SummaryRow(label: 'Net Operating Income', value: currencyFormat.format(analysis.noi)),
                if (inv.financing.isFinanced) ...[
                  const Divider(height: 24),
                  _SummaryRow(label: 'Annual Debt Service', value: currencyFormat.format(InvestmentCalculator.annualDebtService(inv))),
                ],
              ],
            ),
          ),
          const SizedBox(height: 32),
          _isGeneratingPdf 
            ? const Center(child: CircularProgressIndicator())
            : PrimaryButton(
                label: 'Generate PDF Report',
                onPressed: generatePdf,
              ),
          const SizedBox(height: 12),
          PrimaryButton(
            label: 'Save Investment',
            outlined: true,
            onPressed: saveInvestment,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;

  const _MetricCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textSecondary)),
        Text(value, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
