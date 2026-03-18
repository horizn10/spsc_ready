import 'package:flutter/material.dart';
import 'core/theme/app_colors.dart';
import 'presentation/navigation/main_navigation_wrapper.dart';
import 'presentation/pages/auth/login_page.dart';
import 'presentation/pages/auth/register_page.dart';

void main() {
  runApp(const SpscReadyApp());
}

class SpscReadyApp extends StatelessWidget {
  const SpscReadyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SPSC READY',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          surface: AppColors.background,
        ),
        fontFamily: 'Inter',
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            color: AppColors.headingText,
            fontWeight: FontWeight.bold,
          ),
          bodyMedium: TextStyle(color: AppColors.bodyText),
        ),
      ),
      // Define routes so they are available throughout the app
      routes: {
        '/': (context) => const MainNavigationWrapper(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
      },
      initialRoute: '/',
    );
  }
}
