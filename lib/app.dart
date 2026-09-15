import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_routes.dart';
import 'features/splash/splash_screen.dart';

class PropertyInvestmentApp extends StatelessWidget {
  const PropertyInvestmentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Property Investment Calculator',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routes: AppRoutes.routes,
      home: const SplashScreen(),
    );
  }
}
