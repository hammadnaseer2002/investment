/// Rental assumptions (RDP section 11 - Rental Income).
class RentalIncome {
  final double monthlyRent;
  final double otherAnnualIncome;
  final double vacancyRatePercent; // 0-100

  const RentalIncome({
    this.monthlyRent = 0,
    this.otherAnnualIncome = 0,
    this.vacancyRatePercent = 0,
  });

  Map<String, dynamic> toJson() => {
        'monthlyRent': monthlyRent,
        'otherAnnualIncome': otherAnnualIncome,
        'vacancyRatePercent': vacancyRatePercent,
      };

  factory RentalIncome.fromJson(Map<String, dynamic> json) => RentalIncome(
        monthlyRent: (json['monthlyRent'] ?? 0).toDouble(),
        otherAnnualIncome: (json['otherAnnualIncome'] ?? 0).toDouble(),
        vacancyRatePercent: (json['vacancyRatePercent'] ?? 0).toDouble(),
      );
}
