import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_colors.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.bg,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.shopping_bag_outlined,
                        color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Products App',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.dark),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            const SizedBox(height: 8),

            // Home
            _drawerItem(
              context,
              icon: Icons.home_outlined,
              label: 'Home',
              route: '/home',
            ),

            // Add Product
            _drawerItem(
              context,
              icon: Icons.add_box_outlined,
              label: 'Add Product',
              route: '/add-product',
            ),

            // Search
            _drawerItem(
              context,
              icon: Icons.search_rounded,
              label: 'Search',
              route: '/search',
            ),

            // Profile
            _drawerItem(
              context,
              icon: Icons.person_outline_rounded,
              label: 'Profile',
              route: '/profile',
            ),
          ],
        ),
      ),
    );
  }

  // Single drawer item
  Widget _drawerItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String route,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.dark),
      title: Text(
        label,
        style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.dark),
      ),
      onTap: () {
        Navigator.pop(context); // close drawer
        context.go(route);
      },
    );
  }
}