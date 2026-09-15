enum PaymentFrequency { monthly, quarterly, annually }

/// Cash or financed purchase details (RDP section 10 - Financing).
class Financing {
  final bool isFinanced;
  final double downPayment;
  final double loanAmount;
  final double annualRatePercent;
  final int termYears;
  final PaymentFrequency frequency;

  const Financing({
    this.isFinanced = false,
    this.downPayment = 0,
    this.loanAmount = 0,
    this.annualRatePercent = 0,
    this.termYears = 0,
    this.frequency = PaymentFrequency.monthly,
  });

  Financing copyWith({
    bool? isFinanced,
    double? downPayment,
    double? loanAmount,
    double? annualRatePercent,
    int? termYears,
    PaymentFrequency? frequency,
  }) {
    return Financing(
      isFinanced: isFinanced ?? this.isFinanced,
      downPayment: downPayment ?? this.downPayment,
      loanAmount: loanAmount ?? this.loanAmount,
      annualRatePercent: annualRatePercent ?? this.annualRatePercent,
      termYears: termYears ?? this.termYears,
      frequency: frequency ?? this.frequency,
    );
  }

  Map<String, dynamic> toJson() => {
        'isFinanced': isFinanced,
        'downPayment': downPayment,
        'loanAmount': loanAmount,
        'annualRatePercent': annualRatePercent,
        'termYears': termYears,
        'frequency': frequency.name,
      };

  factory Financing.fromJson(Map<String, dynamic> json) => Financing(
        isFinanced: json['isFinanced'] ?? false,
        downPayment: (json['downPayment'] ?? 0).toDouble(),
        loanAmount: (json['loanAmount'] ?? 0).toDouble(),
        annualRatePercent: (json['annualRatePercent'] ?? 0).toDouble(),
        termYears: json['termYears'] ?? 0,
        frequency: PaymentFrequency.values.firstWhere(
          (e) => e.name == json['frequency'],
          orElse: () => PaymentFrequency.monthly,
        ),
      );
}
