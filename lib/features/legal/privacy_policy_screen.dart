import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Privacy Policy', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: const [
          Text(
            'Privacy Policy',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.darkNavy),
          ),
          SizedBox(height: 16),
          Text(
            'Last updated: September 2026\n\n'
            'This Privacy Policy describes our policies and procedures on the collection, use and disclosure of your information when you use the service.\n\n'
            '1. Information Collection\n'
            'We do not collect any personal data. All data you enter into the Property Investment Calculator (such as property values, loan amounts, etc.) is stored locally on your device using an offline SQLite database. We do not transmit or store your investment data on any external servers.\n\n'
            '2. Usage Data\n'
            'Since this app operates completely offline, we do not collect usage data or analytics.\n\n'
            '3. Changes to this Privacy Policy\n'
            'We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page.\n\n'
            'Contact Us\n'
            'If you have any questions about this Privacy Policy, you can contact us at support@example.com.',
            style: TextStyle(fontSize: 16, color: AppColors.textPrimary, height: 1.5),
          ),
        ],
      ),
    );
  }
}
