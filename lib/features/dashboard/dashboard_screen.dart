import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/models/investment.dart';
import '../../core/storage/investment_repository.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/bottom_nav_shell.dart';
import '../../widgets/section_card.dart';
import '../new_investment/new_investment_flow.dart';
import '../new_investment/new_investment_provider.dart';
import '../my_investments/my_investments_screen.dart';
import '../quick_calculators/quick_calculators_screen.dart';
import '../compare_properties/compare_properties_screen.dart';
import '../final_report/final_report_screen.dart';
import '../settings/settings_screen.dart';

final allInvestmentsProvider =
    FutureProvider.autoDispose<List<Investment>>((ref) async {
  final repo = ref.read(investmentRepositoryProvider);
  final all = await repo.getAll();
  all.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  return all;
});

final recentInvestmentsProvider =
    Provider.autoDispose<AsyncValue<List<Investment>>>((ref) {
  final allAsync = ref.watch(allInvestmentsProvider);
  return allAsync.whenData((all) => all.take(5).toList());
});

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int _navIndex = 0;

  Widget _buildBody() {
    switch (_navIndex) {
      case 0:
        return _buildHome();
      case 1:
        return const MyInvestmentsScreen();
      case 2:
        return const FinalReportScreen();
      case 3:
        return const SettingsScreen();
      default:
        return _buildHome();
    }
  }

  Widget _buildHome() {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(allInvestmentsProvider);
        },
        child: ListView(
          padding:
              const EdgeInsets.only(top: 48, left: 16, right: 16, bottom: 24),
          children: [
            Text('Property Investment Calculator',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold, color: AppColors.darkNavy)),
            const SizedBox(height: 4),
            const Text('Calculate. Plan. Grow.',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () {
                ref.read(newInvestmentProvider.notifier).reset();
                Navigator.of(context)
                    .push(
                  MaterialPageRoute(builder: (_) => const NewInvestmentFlow()),
                )
                    .then((_) {
                  ref.invalidate(allInvestmentsProvider);
                });
              },
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primaryBlue, AppColors.darkNavy],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.add, color: Colors.white),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('New Investment',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text('Start analyzing a new property',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 12)),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: Colors.white),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _DashboardTile(
                    icon: Icons.apartment_outlined,
                    label: 'My Investments',
                    onTap: () => setState(() => _navIndex = 1),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _DashboardTile(
                    icon: Icons.calculate_outlined,
                    label: 'Quick Calculators',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => const QuickCalculatorsScreen()),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _DashboardTile(
                    icon: Icons.compare_arrows_rounded,
                    label: 'Compare',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => const ComparePropertiesScreen()),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _DashboardTile(
                    icon: Icons.description_outlined,
                    label: 'Reports',
                    onTap: () => setState(() => _navIndex = 2),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Recent Investments',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkNavy)),
                TextButton(
                  onPressed: () => setState(() => _navIndex = 1),
                  child: const Text('See All'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Consumer(
              builder: (context, ref, child) {
                final recentsAsync = ref.watch(recentInvestmentsProvider);
                return recentsAsync.when(
                  data: (investments) {
                    if (investments.isEmpty) {
                      return const SectionCard(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(
                              child: Text('No investments saved yet.',
                                  style: TextStyle(
                                      color: AppColors.textSecondary))),
                        ),
                      );
                    }
                    return Column(
                      children: investments
                          .map((inv) => RecentInvestmentCard(investment: inv))
                          .toList(),
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (err, stack) =>
                      Text('Error loading recent investments: $err'),
                );
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavShell(
      currentIndex: _navIndex,
      onTap: (i) => setState(() => _navIndex = i),
      body: _buildBody(),
    );
  }
}

class _DashboardTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _DashboardTile(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: SectionCard(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.primaryBlue, size: 28),
            const SizedBox(height: 12),
            Text(label,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, color: AppColors.darkNavy)),
          ],
        ),
      ),
    );
  }
}

class RecentInvestmentCard extends StatelessWidget {
  final Investment investment;
  const RecentInvestmentCard({super.key, required this.investment});

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.currency(symbol: 'Rs ', decimalDigits: 0);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SectionCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child:
                  const Icon(Icons.home_outlined, color: AppColors.primaryBlue),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    investment.location.isNotEmpty
                        ? investment.location
                        : 'Unknown Location',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: AppColors.darkNavy),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    investment.propertyType,
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 12),
                  ),
                ],
              ),
            ),
            Text(
              fmt.format(investment.purchasePrice),
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: AppColors.primaryBlue),
            ),
          ],
        ),
      ),
    );
  }
}
