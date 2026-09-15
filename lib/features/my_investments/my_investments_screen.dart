import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/section_card.dart';
import '../../core/theme/app_colors.dart';
import '../new_investment/new_investment_flow.dart';
import '../new_investment/new_investment_provider.dart';
import '../dashboard/dashboard_screen.dart';

/// My Investments (RDP section 6 & 22 - lists saved Investment records).
class MyInvestmentsScreen extends ConsumerWidget {
  const MyInvestmentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncInvestments = ref.watch(allInvestmentsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Investments', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        centerTitle: true,
        automaticallyImplyLeading: false, // If nested in dashboard, no back button needed. 
        actions: [
          IconButton(
            onPressed: () {
              ref.read(newInvestmentProvider.notifier).reset();
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const NewInvestmentFlow()),
              ).then((_) {
                ref.invalidate(allInvestmentsProvider);
              });
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: asyncInvestments.when(
        data: (investments) {
          if (investments.isEmpty) {
            return const Center(
              child: SectionCard(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text('No investments saved yet.', style: TextStyle(color: AppColors.textSecondary)),
                ),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: investments.length,
            itemBuilder: (context, index) {
              final inv = investments[index];
              return RecentInvestmentCard(investment: inv);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
