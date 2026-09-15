/// Recurring annual operating expenses (RDP section 12 - Expenses).
class PropertyExpenses {
  final double propertyTax;
  final double maintenance;
  final double insurance;
  final double managementFee;
  final double ownerPaidUtilities;
  final double hoaServiceCharges;
  final double other;

  const PropertyExpenses({
    this.propertyTax = 0,
    this.maintenance = 0,
    this.insurance = 0,
    this.managementFee = 0,
    this.ownerPaidUtilities = 0,
    this.hoaServiceCharges = 0,
    this.other = 0,
  });

  double get totalAnnual =>
      propertyTax +
      maintenance +
      insurance +
      managementFee +
      ownerPaidUtilities +
      hoaServiceCharges +
      other;

  Map<String, dynamic> toJson() => {
        'propertyTax': propertyTax,
        'maintenance': maintenance,
        'insurance': insurance,
        'managementFee': managementFee,
        'ownerPaidUtilities': ownerPaidUtilities,
        'hoaServiceCharges': hoaServiceCharges,
        'other': other,
      };

  factory PropertyExpenses.fromJson(Map<String, dynamic> json) => PropertyExpenses(
        propertyTax: (json['propertyTax'] ?? 0).toDouble(),
        maintenance: (json['maintenance'] ?? 0).toDouble(),
        insurance: (json['insurance'] ?? 0).toDouble(),
        managementFee: (json['managementFee'] ?? 0).toDouble(),
        ownerPaidUtilities: (json['ownerPaidUtilities'] ?? 0).toDouble(),
        hoaServiceCharges: (json['hoaServiceCharges'] ?? 0).toDouble(),
        other: (json['other'] ?? 0).toDouble(),
      );
}
