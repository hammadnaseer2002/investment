/// One-time costs incurred at acquisition (RDP section 9 - Purchase Costs).
class PurchaseCosts {
  final double registration;
  final double transferTax;
  final double legalFee;
  final double brokerCommission;
  final double renovation;
  final double other;

  const PurchaseCosts({
    this.registration = 0,
    this.transferTax = 0,
    this.legalFee = 0,
    this.brokerCommission = 0,
    this.renovation = 0,
    this.other = 0,
  });

  double get total =>
      registration + transferTax + legalFee + brokerCommission + renovation + other;

  Map<String, dynamic> toJson() => {
        'registration': registration,
        'transferTax': transferTax,
        'legalFee': legalFee,
        'brokerCommission': brokerCommission,
        'renovation': renovation,
        'other': other,
      };

  factory PurchaseCosts.fromJson(Map<String, dynamic> json) => PurchaseCosts(
        registration: (json['registration'] ?? 0).toDouble(),
        transferTax: (json['transferTax'] ?? 0).toDouble(),
        legalFee: (json['legalFee'] ?? 0).toDouble(),
        brokerCommission: (json['brokerCommission'] ?? 0).toDouble(),
        renovation: (json['renovation'] ?? 0).toDouble(),
        other: (json['other'] ?? 0).toDouble(),
      );
}
