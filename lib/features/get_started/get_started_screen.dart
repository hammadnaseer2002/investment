import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_strings.dart';
import '../../widgets/primary_button.dart';
import '../dashboard/dashboard_screen.dart';

/// Screen 4 - "Your Property Investment Partner" (RDP section 6).
class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              const Icon(Icons.phone_iphone_rounded, size: 120),
              const SizedBox(height: 24),
              Text('Your Property Investment Partner',
                  textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text('Make smarter, data-driven decisions with our powerful calculators.',
                  textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium),
              const Spacer(),
              PrimaryButton(
                label: 'Get Started',
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('has_seen_onboarding', true);
                  if (context.mounted) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const DashboardScreen()),
                    );
                  }
                },
              ),
              const SizedBox(height: 8),
              Text(AppStrings.disclaimer,
                  textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}
