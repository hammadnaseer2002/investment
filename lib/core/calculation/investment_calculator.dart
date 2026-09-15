import 'dart:math';
import '../models/investment.dart';
import '../models/investment_analysis.dart';

/// Pure, unit-testable calculation engine.
/// Never place these formulas inside UI widgets (RDP section 30).
///
/// Formulas sourced directly from RDP section 17 - Calculation Engine:
/// - Total Acquisition Cost = Purchase Price + Acquisition Costs + Renovation
/// - Annual Gross Rent = Monthly Rent x 12 + Other Annual Rental Income
/// - Effective Rental Income = Annual Gross Rent x (1 - Vacancy Rate)
/// - NOI = Effective Rental Income - Operating Expenses
/// - Gross Yield = Annual Gross Rent / Purchase Price x 100
/// - Net Yield = NOI / Purchase Price x 100
/// - Annual Cash Flow = NOI - Annual Debt Payments
/// - Future Value = Current Value x (1 + Appreciation Rate) ^ Years
/// - Net Sale Proceeds = Sale Price - Selling Costs - Remaining Loan Balance
class InvestmentCalculator {
  const InvestmentCalculator._();

  /// Purchase Price + one-time acquisition costs + renovation/setup.
  static double totalAcquisitionCost(Investment inv) {
    return inv.purchasePrice + inv.purchaseCosts.total;
  }

  static double annualGrossRent(Investment inv) {
    return (inv.rentalIncome.monthlyRent * 12) + inv.rentalIncome.otherAnnualIncome;
  }

  static double effectiveRentalIncome(Investment inv) {
    final vacancy = (inv.rentalIncome.vacancyRatePercent.clamp(0, 100)) / 100;
    return annualGrossRent(inv) * (1 - vacancy);
  }

  static double netOperatingIncome(Investment inv) {
    return effectiveRentalIncome(inv) - inv.expenses.totalAnnual;
  }

  static double grossYieldPercent(Investment inv) {
    if (inv.purchasePrice <= 0) return 0;
    return (annualGrossRent(inv) / inv.purchasePrice) * 100;
  }

  static double netYieldPercent(Investment inv) {
    if (inv.purchasePrice <= 0) return 0;
    return (netOperatingIncome(inv) / inv.purchasePrice) * 100;
  }

  /// Standard amortized monthly loan payment (used to derive annual debt
  /// service for cash-flow / ROI). Falls back to 0 for cash purchases.
  static double monthlyLoanPayment(Investment inv) {
    final f = inv.financing;
    if (!f.isFinanced || f.loanAmount <= 0 || f.termYears <= 0) return 0;
    final monthlyRate = (f.annualRatePercent / 100) / 12;
    final numPayments = f.termYears * 12;
    if (monthlyRate == 0) return f.loanAmount / numPayments;
    final factor = pow(1 + monthlyRate, numPayments);
    return f.loanAmount * (monthlyRate * factor) / (factor - 1);
  }

  static double annualDebtService(Investment inv) => monthlyLoanPayment(inv) * 12;

  static double annualCashFlow(Investment inv) {
    return netOperatingIncome(inv) - annualDebtService(inv);
  }

  static double monthlyCashFlow(Investment inv) => annualCashFlow(inv) / 12;

  /// Simple ROI on cash invested (down payment + acquisition costs for a
  /// financed deal, or full purchase price + costs for cash).
  static double cashInvested(Investment inv) {
    final acquisition = totalAcquisitionCost(inv);
    if (inv.financing.isFinanced) {
      return inv.financing.downPayment + inv.purchaseCosts.total;
    }
    return acquisition;
  }

  static double roiPercent(Investment inv) {
    final invested = cashInvested(inv);
    if (invested <= 0) return 0;
    return (annualCashFlow(inv) / invested) * 100;
  }

  static double futureValue({
    required double currentValue,
    required double appreciationRatePercent,
    required int years,
  }) {
    return currentValue * pow(1 + (appreciationRatePercent / 100), years);
  }

  /// Years until cumulative cash flow recovers the cash invested.
  /// Returns double.infinity when cash flow is not positive.
  static double breakEvenYears(Investment inv) {
    final invested = cashInvested(inv);
    final flow = annualCashFlow(inv);
    if (flow <= 0) return double.infinity;
    return invested / flow;
  }

  static double netSaleProceeds({
    required double salePrice,
    required double sellingCosts,
    required double remainingLoanBalance,
  }) {
    return salePrice - sellingCosts - remainingLoanBalance;
  }

  /// Convenience: run the full Investment Analysis screen output at once.
  static InvestmentAnalysis analyze(
    Investment inv, {
    double appreciationRatePercent = 0,
    int projectionYears = 5,
  }) {
    return InvestmentAnalysis(
      totalInvestment: totalAcquisitionCost(inv),
      grossYieldPercent: grossYieldPercent(inv),
      netYieldPercent: netYieldPercent(inv),
      noi: netOperatingIncome(inv),
      monthlyCashFlow: monthlyCashFlow(inv),
      annualCashFlow: annualCashFlow(inv),
      roiPercent: roiPercent(inv),
      futureValue: futureValue(
        currentValue: inv.purchasePrice,
        appreciationRatePercent: appreciationRatePercent,
        years: projectionYears,
      ),
      breakEvenYears: breakEvenYears(inv),
    );
  }
}
