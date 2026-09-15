import 'package:flutter/material.dart';
import '../../widgets/section_card.dart';
import 'mortgage_calculator_screen.dart';
import 'rental_yield_calculator_screen.dart';
import 'roi_calculator_screen.dart';
import 'cash_flow_calculator_screen.dart';
import 'appreciation_calculator_screen.dart';

/// Quick Calculators - standalone single-purpose calculators
/// (RDP section 7 - Dashboard: ROI, Rental Yield, Mortgage, Appreciation,
/// Cash Flow).
class QuickCalculatorsScreen extends StatelessWidget {
  const QuickCalculatorsScreen({super.key});

  static const _calculators = [
    ('Mortgage Calculator', Icons.request_quote_outlined),
    ('Rental Yield Calculator', Icons.percent_rounded),
    ('ROI Calculator', Icons.trending_up_rounded),
    ('Cash Flow Analysis', Icons.account_balance_wallet_outlined),
    ('Appreciation Calculator', Icons.show_chart_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quick Calculators', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)), centerTitle: true),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _calculators.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, i) {
          final item = _calculators[i];
          final label = item.$1;
          final icon = item.$2;
          return SectionCard(
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(icon),
              title: Text(label),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Widget? screen;
                switch (label) {
                  case 'Mortgage Calculator':
                    screen = const MortgageCalculatorScreen();
                    break;
                  case 'Rental Yield Calculator':
                    screen = const RentalYieldCalculatorScreen();
                    break;
                  case 'ROI Calculator':
                    screen = const RoiCalculatorScreen();
                    break;
                  case 'Cash Flow Analysis':
                    screen = const CashFlowCalculatorScreen();
                    break;
                  case 'Appreciation Calculator':
                    screen = const AppreciationCalculatorScreen();
                    break;
                }
                
                if (screen != null) {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen!));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$label coming soon!')));
                }
              },
            ),
          );
        },
      ),
    );
  }
}
