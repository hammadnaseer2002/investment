import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/providers/settings_provider.dart';
import '../my_investments/my_investments_screen.dart';
import '../final_report/final_report_screen.dart';
import '../legal/privacy_policy_screen.dart';
import '../legal/terms_conditions_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _showCurrencyDialog(
      BuildContext context, WidgetRef ref, String current) async {
    final currencies = ['PKR', 'USD', 'EUR', 'GBP', 'INR', 'AED'];
    await showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Select Currency'),
        children: currencies
            .map((c) => SimpleDialogOption(
                  onPressed: () {
                    ref.read(settingsProvider.notifier).updateCurrency(c);
                    Navigator.pop(ctx);
                  },
                  child: Text(c,
                      style: TextStyle(
                          fontWeight: c == current
                              ? FontWeight.bold
                              : FontWeight.normal)),
                ))
            .toList(),
      ),
    );
  }

  Future<void> _showUnitDialog(
      BuildContext context, WidgetRef ref, String current) async {
    final units = ['Sq.Ft', 'Sq.M', 'Sq.Yd'];
    await showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Select Measurement Unit'),
        children: units
            .map((u) => SimpleDialogOption(
                  onPressed: () {
                    ref.read(settingsProvider.notifier).updateUnit(u);
                    Navigator.pop(ctx);
                  },
                  child: Text(u,
                      style: TextStyle(
                          fontWeight: u == current
                              ? FontWeight.bold
                              : FontWeight.normal)),
                ))
            .toList(),
      ),
    );
  }

  Future<void> _showLocationDialog(
      BuildContext context, WidgetRef ref, String current) async {
    final ctrl = TextEditingController(text: current);
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Default City / Location'),
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(
              hintText: 'Enter city name', border: OutlineInputBorder()),
          autofocus: true,
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              if (ctrl.text.trim().isNotEmpty) {
                ref
                    .read(settingsProvider.notifier)
                    .updateLocation(ctrl.text.trim());
              }
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Profile & Settings',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text('Preferences',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
          ),
          ListTile(
            leading: const Icon(Icons.attach_money_rounded,
                color: AppColors.primaryBlue),
            title: const Text('Currency',
                style: TextStyle(
                    color: AppColors.darkNavy, fontWeight: FontWeight.w500)),
            trailing: Text(settings.currency,
                style: const TextStyle(color: AppColors.textSecondary)),
            onTap: () => _showCurrencyDialog(context, ref, settings.currency),
          ),
          const Divider(height: 1, color: AppColors.divider),
          ListTile(
            leading: const Icon(Icons.straighten_rounded,
                color: AppColors.primaryBlue),
            title: const Text('Measurement Unit',
                style: TextStyle(
                    color: AppColors.darkNavy, fontWeight: FontWeight.w500)),
            trailing: Text(settings.measurementUnit,
                style: const TextStyle(color: AppColors.textSecondary)),
            onTap: () =>
                _showUnitDialog(context, ref, settings.measurementUnit),
          ),
          const Divider(height: 1, color: AppColors.divider),
          ListTile(
            leading: const Icon(Icons.location_city_rounded,
                color: AppColors.primaryBlue),
            title: const Text('City / Location',
                style: TextStyle(
                    color: AppColors.darkNavy, fontWeight: FontWeight.w500)),
            trailing: Text(settings.defaultLocation,
                style: const TextStyle(color: AppColors.textSecondary)),
            onTap: () =>
                _showLocationDialog(context, ref, settings.defaultLocation),
          ),
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text('My Data',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
          ),
          ListTile(
            leading: const Icon(Icons.apartment_outlined,
                color: AppColors.primaryBlue),
            title: const Text('My Investments',
                style: TextStyle(
                    color: AppColors.darkNavy, fontWeight: FontWeight.w500)),
            trailing:
                const Icon(Icons.chevron_right, color: AppColors.textSecondary),
            onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const MyInvestmentsScreen())),
          ),
          const Divider(height: 1, color: AppColors.divider),
          ListTile(
            leading: const Icon(Icons.description_outlined,
                color: AppColors.primaryBlue),
            title: const Text('Reports',
                style: TextStyle(
                    color: AppColors.darkNavy, fontWeight: FontWeight.w500)),
            trailing:
                const Icon(Icons.chevron_right, color: AppColors.textSecondary),
            onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const FinalReportScreen())),
          ),
          const Divider(height: 1, color: AppColors.divider),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text('Legal & Info',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
          ),
          ListTile(
            leading: const Icon(Icons.gavel_rounded,
                color: AppColors.primaryBlue),
            title: const Text('Terms & Conditions',
                style: TextStyle(
                    color: AppColors.darkNavy, fontWeight: FontWeight.w500)),
            trailing:
                const Icon(Icons.chevron_right, color: AppColors.textSecondary),
            onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const TermsConditionsScreen())),
          ),
          const Divider(height: 1, color: AppColors.divider),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined,
                color: AppColors.primaryBlue),
            title: const Text('Privacy Policy',
                style: TextStyle(
                    color: AppColors.darkNavy, fontWeight: FontWeight.w500)),
            trailing:
                const Icon(Icons.chevron_right, color: AppColors.textSecondary),
            onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen())),
          ),
          const Divider(height: 1, color: AppColors.divider),
          ListTile(
            leading: const Icon(Icons.info_outline_rounded,
                color: AppColors.primaryBlue),
            title: const Text('About App',
                style: TextStyle(
                    color: AppColors.darkNavy, fontWeight: FontWeight.w500)),
            trailing:
                const Icon(Icons.chevron_right, color: AppColors.textSecondary),
            onTap: () => showAboutDialog(
              context: context,
              applicationName: 'Property Calculator',
              applicationVersion: '1.0.0',
              applicationLegalese: '© 2026 Property Investment Calculator',
            ),
          ),
          const Divider(height: 1, color: AppColors.divider),
        ],
      ),
    );
  }
}
