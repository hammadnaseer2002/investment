import 'package:flutter/material.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/get_started/get_started_screen.dart';
import '../../features/dashboard/dashboard_screen.dart';
import '../../features/my_investments/my_investments_screen.dart';
import '../../features/compare_properties/compare_properties_screen.dart';
import '../../features/buy_vs_rent/buy_vs_rent_screen.dart';
import '../../features/sell_property/sell_property_screen.dart';
import '../../features/quick_calculators/quick_calculators_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/new_investment/new_investment_flow.dart';

/// Central named-route table. New Investment is a multi-step flow handled
/// by NewInvestmentFlow (see RDP section 6 - Screens / section 3 - Main User Flow).
class AppRoutes {
  AppRoutes._();

  static const onboarding = '/onboarding';
  static const getStarted = '/get-started';
  static const dashboard = '/dashboard';
  static const newInvestment = '/new-investment';
  static const myInvestments = '/my-investments';
  static const compareProperties = '/compare-properties';
  static const buyVsRent = '/buy-vs-rent';
  static const sellProperty = '/sell-property';
  static const quickCalculators = '/quick-calculators';
  static const aiPropertyAnalyst = '/ai-property-analyst';
  static const settings = '/settings';

  static Map<String, WidgetBuilder> get routes => {
        onboarding: (_) => const OnboardingScreen(),
        getStarted: (_) => const GetStartedScreen(),
        dashboard: (_) => const DashboardScreen(),
        newInvestment: (_) => const NewInvestmentFlow(),
        myInvestments: (_) => const MyInvestmentsScreen(),
        compareProperties: (_) => const ComparePropertiesScreen(),
        buyVsRent: (_) => const BuyVsRentScreen(),
        sellProperty: (_) => const SellPropertyScreen(),
        quickCalculators: (_) => const QuickCalculatorsScreen(),
        settings: (_) => const SettingsScreen(),
      };
}
