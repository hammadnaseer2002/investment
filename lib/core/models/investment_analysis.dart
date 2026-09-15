/// Computed output of the calculation engine (RDP section 13 & 22).
/// This is a pure result object - never computed inside UI widgets.
class InvestmentAnalysis {
  final double totalInvestment;
  final double grossYieldPercent;
  final double netYieldPercent;
  final double noi;
  final double monthlyCashFlow;
  final double annualCashFlow;
  final double roiPercent;
  final double futureValue;
  final double breakEvenYears;

  const InvestmentAnalysis({
    required this.totalInvestment,
    required this.grossYieldPercent,
    required this.netYieldPercent,
    required this.noi,
    required this.monthlyCashFlow,
    required this.annualCashFlow,
    required this.roiPercent,
    required this.futureValue,
    required this.breakEvenYears,
  });

  Map<String, dynamic> toJson() => {
        'totalInvestment': totalInvestment,
        'grossYieldPercent': grossYieldPercent,
        'netYieldPercent': netYieldPercent,
        'noi': noi,
        'monthlyCashFlow': monthlyCashFlow,
        'annualCashFlow': annualCashFlow,
        'roiPercent': roiPercent,
        'futureValue': futureValue,
        'breakEvenYears': breakEvenYears,
      };
}
