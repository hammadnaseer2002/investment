import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

/// Bottom navigation: Home | Investments | Reports | Profile
/// (RDP section 5 - Navigation).
class BottomNavShell extends StatelessWidget {
  final int currentIndex;
  final Widget body;
  final ValueChanged<int> onTap;

  const BottomNavShell({
    super.key,
    required this.currentIndex,
    required this.body,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: body),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: onTap,
        backgroundColor: AppColors.cardBackground,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.apartment_outlined), selectedIcon: Icon(Icons.apartment), label: 'Investments'),
          NavigationDestination(icon: Icon(Icons.description_outlined), selectedIcon: Icon(Icons.description), label: 'Reports'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
