import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class ProgressStepper extends StatelessWidget {
  final int currentStep;
  final List<String> steps;

  const ProgressStepper({
    super.key,
    required this.currentStep,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double stepWidth = constraints.maxWidth / steps.length;
          return Stack(
            children: [
              // Connecting lines
              Positioned(
                top: 14, // center of the circles (28 / 2)
                left: stepWidth / 2,
                right: stepWidth / 2,
                child: Row(
                  children: List.generate(steps.length - 1, (index) {
                    final bool isCompleted = index < currentStep;
                    return Expanded(
                      child: Container(
                        height: 2,
                        color: isCompleted
                            ? AppColors.primaryBlue
                            : AppColors.divider,
                      ),
                    );
                  }),
                ),
              ),
              // Steps
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(steps.length, (index) {
                  final bool isCompleted = index < currentStep;
                  final bool isCurrent = index == currentStep;
                  
                  return SizedBox(
                    width: stepWidth,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: isCompleted || isCurrent
                                ? AppColors.primaryBlue
                                : AppColors.cardBackground,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isCompleted || isCurrent
                                  ? AppColors.primaryBlue
                                  : AppColors.divider,
                              width: 2,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: isCompleted
                              ? const Icon(Icons.check, size: 16, color: Colors.white)
                              : Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    color: isCurrent ? Colors.white : AppColors.textSecondary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          steps[index],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 10,
                            color: isCompleted || isCurrent
                                ? AppColors.textPrimary
                                : AppColors.textSecondary,
                            fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          );
        },
      ),
    );
  }
}
