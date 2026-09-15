import 'package:flutter/material.dart';
import 'primary_button.dart';
import '../core/theme/app_colors.dart';

class BottomActionBar extends StatelessWidget {
  final VoidCallback? onBack;
  final VoidCallback? onNext;
  final String nextLabel;

  const BottomActionBar({
    super.key,
    this.onBack,
    this.onNext,
    this.nextLabel = 'Next',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(
          top: BorderSide(color: AppColors.divider),
        ),
      ),
      child: Row(
        children: [
          if (onBack != null) ...[
            Expanded(
              flex: 1,
              child: PrimaryButton(
                label: 'Back',
                outlined: true,
                onPressed: onBack,
              ),
            ),
            const SizedBox(width: 16),
          ],
          Expanded(
            child: PrimaryButton(
              label: nextLabel,
              onPressed: onNext,
            ),
          ),
        ],
      ),
    );
  }
}
