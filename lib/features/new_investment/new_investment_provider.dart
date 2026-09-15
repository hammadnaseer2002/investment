import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../core/models/investment.dart';
import '../../core/models/purchase_costs.dart';
import '../../core/models/financing.dart';
import '../../core/models/rental_income.dart';
import '../../core/models/property_expenses.dart';

final newInvestmentProvider = NotifierProvider<NewInvestmentNotifier, Investment>(() {
  return NewInvestmentNotifier();
});

class NewInvestmentNotifier extends Notifier<Investment> {
  @override
  Investment build() {
    // Initial empty state
    return Investment(
      id: const Uuid().v4(),
      name: 'New Investment',
      propertyType: 'House',
      location: '',
      purchasePrice: 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  void updatePropertyDetails({
    required String type,
    required String status,
    required String location,
    double? size,
    String? sizeUnit,
    String? notes,
  }) {
    state = state.copyWith(
      propertyType: type,
      location: location,
      size: size,
      sizeUnit: sizeUnit,
      notes: notes,
    );
  }

  void updatePurchaseCosts({
    required double price,
    required PurchaseCosts costs,
  }) {
    state = state.copyWith(
      purchasePrice: price,
      purchaseCosts: costs,
    );
  }

  void updateFinancing(Financing financing) {
    state = state.copyWith(financing: financing);
  }

  void updateRentalIncome(RentalIncome rental) {
    state = state.copyWith(rentalIncome: rental);
  }

  void updateExpenses(PropertyExpenses expenses) {
    state = state.copyWith(expenses: expenses);
  }
  
  void reset() {
    state = Investment(
      id: const Uuid().v4(),
      name: 'New Investment',
      propertyType: 'House',
      location: '',
      purchasePrice: 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}
