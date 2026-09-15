import 'package:flutter/material.dart';
import 'property_details_screen.dart';

/// Multi-step "New Investment" wizard container matching screens 6-10:
/// Property Details -> Purchase Costs -> Financing/Loan -> Rental Income
/// -> Property Expenses -> Investment Analysis (RDP section 3 & 6).
///
/// Each step screen owns its own form state and pushes the next step,
/// passing the partially-built Investment forward.
class NewInvestmentFlow extends StatelessWidget {
  const NewInvestmentFlow({super.key});

  @override
  Widget build(BuildContext context) {
    return const PropertyDetailsScreen();
  }
}

/// Shared step indicator used across all New Investment screens
/// (see screen 6 mockup: "1 2 3 4 5 6" stepper in the app bar).
class StepIndicator extends StatelessWidget {
  final int step; // 1-based
  final int totalSteps;

  const StepIndicator({super.key, required this.step, this.totalSteps = 6});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(totalSteps, (i) {
        final active = i < step;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          width: 22,
          height: 22,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: active ? Theme.of(context).colorScheme.primary : Colors.grey.shade200,
          ),
          child: Text(
            '${i + 1}',
            style: TextStyle(fontSize: 11, color: active ? Colors.white : Colors.grey.shade600),
          ),
        );
      }),
    );
  }
}
