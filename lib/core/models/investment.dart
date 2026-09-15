import 'purchase_costs.dart';
import 'financing.dart';
import 'rental_income.dart';
import 'property_expenses.dart';

/// Root aggregate for a single saved property investment
/// (RDP section 22 - Local Data Model).
class Investment {
  final String id;
  final String name;
  final String propertyType;
  final String location;
  final double purchasePrice;
  final double? size;
  final String sizeUnit;
  final String currency;
  final String notes;
  final PurchaseCosts purchaseCosts;
  final Financing financing;
  final RentalIncome rentalIncome;
  final PropertyExpenses expenses;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Investment({
    required this.id,
    required this.name,
    required this.propertyType,
    required this.location,
    required this.purchasePrice,
    this.size,
    this.sizeUnit = 'Marla',
    this.currency = 'PKR',
    this.notes = '',
    this.purchaseCosts = const PurchaseCosts(),
    this.financing = const Financing(),
    this.rentalIncome = const RentalIncome(),
    this.expenses = const PropertyExpenses(),
    required this.createdAt,
    required this.updatedAt,
  });

  Investment copyWith({
    String? name,
    String? propertyType,
    String? location,
    double? purchasePrice,
    double? size,
    String? sizeUnit,
    String? notes,
    PurchaseCosts? purchaseCosts,
    Financing? financing,
    RentalIncome? rentalIncome,
    PropertyExpenses? expenses,
  }) {
    return Investment(
      id: id,
      name: name ?? this.name,
      propertyType: propertyType ?? this.propertyType,
      location: location ?? this.location,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      size: size ?? this.size,
      sizeUnit: sizeUnit ?? this.sizeUnit,
      currency: currency,
      notes: notes ?? this.notes,
      purchaseCosts: purchaseCosts ?? this.purchaseCosts,
      financing: financing ?? this.financing,
      rentalIncome: rentalIncome ?? this.rentalIncome,
      expenses: expenses ?? this.expenses,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'propertyType': propertyType,
        'location': location,
        'purchasePrice': purchasePrice,
        'size': size,
        'sizeUnit': sizeUnit,
        'currency': currency,
        'notes': notes,
        'purchaseCosts': purchaseCosts.toJson(),
        'financing': financing.toJson(),
        'rentalIncome': rentalIncome.toJson(),
        'expenses': expenses.toJson(),
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory Investment.fromJson(Map<String, dynamic> json) => Investment(
        id: json['id'],
        name: json['name'],
        propertyType: json['propertyType'],
        location: json['location'],
        purchasePrice: (json['purchasePrice'] ?? 0).toDouble(),
        size: json['size']?.toDouble(),
        sizeUnit: json['sizeUnit'] ?? 'Marla',
        currency: json['currency'] ?? 'PKR',
        notes: json['notes'] ?? '',
        purchaseCosts: PurchaseCosts.fromJson(json['purchaseCosts'] ?? {}),
        financing: Financing.fromJson(json['financing'] ?? {}),
        rentalIncome: RentalIncome.fromJson(json['rentalIncome'] ?? {}),
        expenses: PropertyExpenses.fromJson(json['expenses'] ?? {}),
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
      );
}
