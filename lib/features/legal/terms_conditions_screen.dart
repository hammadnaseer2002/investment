import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Terms & Conditions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: const [
          Text(
            'Terms & Conditions',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.darkNavy),
          ),
          SizedBox(height: 16),
          Text(
            'Last updated: September 2026\n\n'
            'Please read these terms and conditions carefully before using our Service.\n\n'
            '1. Acknowledgment\n'
            'These are the Terms and Conditions governing the use of this Service and the agreement that operates between you and the Company. Your access to and use of the Service is conditioned on your acceptance of and compliance with these Terms and Conditions.\n\n'
            '2. Disclaimer of Financial Advice\n'
            'The calculations, numbers, and projections provided by the Property Investment Calculator are for informational and educational purposes only. They do not constitute financial, investment, or legal advice. You should not make any investment decision solely based on the outputs of this application. Always consult with a certified financial advisor before making any property investments.\n\n'
            '3. Liability\n'
            'The developer of this application is not liable for any financial losses or damages resulting from the use of the calculators provided.\n\n'
            '4. Modifications\n'
            'We reserve the right, at our sole discretion, to modify or replace these Terms at any time.',
            style: TextStyle(fontSize: 16, color: AppColors.textPrimary, height: 1.5),
          ),
        ],
      ),
    );
  }
}
