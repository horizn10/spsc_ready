import 'package:flutter/material.dart';
import 'package:spsc_ready/core/theme/app_colors.dart';
import 'package:spsc_ready/core/services/auth_service.dart';

class SpscAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SpscAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    // ValueListenableBuilder automatically rebuilds this widget when AuthService().isLoggedIn changes
    return ValueListenableBuilder<bool>(
      valueListenable: AuthService().isLoggedIn,
      builder: (context, isLoggedIn, _) {
        return AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          leadingWidth: 0,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.menu_book, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 10),
              const Text(
                'SPSC READY',
                style: TextStyle(
                  color: AppColors.headingText,
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          actions: isLoggedIn ? _buildLoggedInActions(context) : _buildLoggedOutActions(context),
        );
      },
    );
  }

  List<Widget> _buildLoggedInActions(BuildContext context) {
    return [
      Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: PopupMenuButton<String>(
          offset: const Offset(0, 45),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          onSelected: (value) async {
            if (value == 'logout') {
              await AuthService().logout();
              // No need to navigate, ValueListenableBuilder will update the UI
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'profile',
              child: Row(
                children: [
                  Icon(Icons.person_outline, size: 20, color: AppColors.bodyText),
                  SizedBox(width: 12),
                  Text('My Profile'),
                ],
              ),
            ),
            const PopupMenuDivider(),
            const PopupMenuItem(
              value: 'logout',
              child: Row(
                children: [
                  Icon(Icons.logout_rounded, size: 20, color: Colors.redAccent),
                  SizedBox(width: 12),
                  Text('Logout', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary.withOpacity(0.2), width: 2),
            ),
            child: const CircleAvatar(
              radius: 18,
              backgroundColor: Color(0xFFF1F5F9), // Light slate background
              child: Icon(Icons.person_rounded, color: AppColors.primary, size: 22),
            ),
          ),
        ),
      ),
    ];
  }

  List<Widget> _buildLoggedOutActions(BuildContext context) {
    return [
      TextButton(
        onPressed: () => Navigator.pushNamed(context, '/login'),
        child: const Text(
          'Login',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 16, left: 4),
        child: ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, '/register'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text('Register', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
    ];
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
