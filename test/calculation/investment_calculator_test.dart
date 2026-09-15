import 'package:flutter_test/flutter_test.dart';
import 'package:property_investment_calculator/core/calculation/investment_calculator.dart';
import 'package:property_investment_calculator/core/models/investment.dart';
import 'package:property_investment_calculator/core/models/purchase_costs.dart';
import 'package:property_investment_calculator/core/models/financing.dart';
import 'package:property_investment_calculator/core/models/rental_income.dart';
import 'package:property_investment_calculator/core/models/property_expenses.dart';

/// RDP section 27 - QA: unit-test every formula, zero/min/max inputs,
/// cash vs financed scenarios, vacancy/expenses, rounding, division-by-zero.
void main() {
  Investment buildInvestment({
    double price = 20000000,
    PurchaseCosts costs = const PurchaseCosts(registration: 150000, transferTax: 100000),
    Financing financing = const Financing(),
    RentalIncome rental = const RentalIncome(monthlyRent: 100000, vacancyRatePercent: 8),
    PropertyExpenses expenses = const PropertyExpenses(propertyTax: 50000, maintenance: 100000),
  }) {
    final now = DateTime.now();
    return Investment(
      id: 'test-1',
      name: '5 Marla House',
      propertyType: 'House',
      location: 'Lahore, Pakistan',
      purchasePrice: price,
      purchaseCosts: costs,
      financing: financing,
      rentalIncome: rental,
      expenses: expenses,
      createdAt: now,
      updatedAt: now,
    );
  }

  test('Total Acquisition Cost = price + acquisition costs', () {
    final inv = buildInvestment();
    expect(InvestmentCalculator.totalAcquisitionCost(inv), 20000000 + 150000 + 100000);
  });

  test('Annual Gross Rent = monthly rent x 12 + other income', () {
    final inv = buildInvestment(rental: const RentalIncome(monthlyRent: 100000, otherAnnualIncome: 5000));
    expect(InvestmentCalculator.annualGrossRent(inv), 100000 * 12 + 5000);
  });

  test('Effective Rental Income applies vacancy rate', () {
    final inv = buildInvestment(rental: const RentalIncome(monthlyRent: 100000, vacancyRatePercent: 10));
    final expected = (100000 * 12) * 0.9;
    expect(InvestmentCalculator.effectiveRentalIncome(inv), closeTo(expected, 0.01));
  });

  test('Gross Yield is zero when purchase price is zero (no division by zero)', () {
    final inv = buildInvestment(price: 0);
    expect(InvestmentCalculator.grossYieldPercent(inv), 0);
  });

  test('Cash purchase has zero debt service and zero monthly payment', () {
    final inv = buildInvestment(financing: const Financing(isFinanced: false));
    expect(InvestmentCalculator.monthlyLoanPayment(inv), 0);
    expect(InvestmentCalculator.annualDebtService(inv), 0);
  });

  test('Financed purchase produces a positive monthly payment', () {
    final inv = buildInvestment(
      financing: const Financing(
        isFinanced: true,
        downPayment: 4000000,
        loanAmount: 16000000,
        annualRatePercent: 12,
        termYears: 10,
      ),
    );
    expect(InvestmentCalculator.monthlyLoanPayment(inv), greaterThan(0));
  });

  test('Future Value compounds appreciation over years', () {
    final fv = InvestmentCalculator.futureValue(
      currentValue: 20000000,
      appreciationRatePercent: 8,
      years: 5,
    );
    expect(fv, closeTo(20000000 * 1.469328, 100));
  });

  test('Break-even is infinite when cash flow is not positive', () {
    final inv = buildInvestment(
      rental: const RentalIncome(monthlyRent: 0),
      expenses: const PropertyExpenses(propertyTax: 100000),
    );
    expect(InvestmentCalculator.breakEvenYears(inv), double.infinity);
  });

  test('Net Sale Proceeds subtracts costs and remaining loan', () {
    final proceeds = InvestmentCalculator.netSaleProceeds(
      salePrice: 25000000,
      sellingCosts: 500000,
      remainingLoanBalance: 10000000,
    );
    expect(proceeds, 25000000 - 500000 - 10000000);
  });
}
