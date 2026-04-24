import 'package:TR/core/localization/app_localizations.dart';
import 'package:TR/core/theme/app_theme.dart';
import 'package:TR/features/cart/ui/screen/cart_screen.dart';
import 'package:TR/features/home/ui/screen/home_screen.dart';
import 'package:TR/features/profile/ui/screen/profile_screen.dart';
import 'package:flutter/material.dart';

class BottomNavShell extends StatefulWidget {
  const BottomNavShell({super.key});

  @override
  State<BottomNavShell> createState() => _BottomNavShellState();
}

class _BottomNavShellState extends State<BottomNavShell> {
  int _currentIndex = 0;

  late final List<Widget> _screens = const [
    HomeScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        backgroundColor: Theme.of(context).navigationBarTheme.backgroundColor,
        indicatorColor: AppTheme.secondaryColor.withValues(alpha: 0.18),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home_outlined, color: isDark ? Colors.white70 : null),
            selectedIcon: const Icon(Icons.home),
            label: l10n.home,
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_bag_outlined, color: isDark ? Colors.white70 : null),
            selectedIcon: const Icon(Icons.shopping_bag),
            label: l10n.cart,
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline, color: isDark ? Colors.white70 : null),
            selectedIcon: const Icon(Icons.person),
            label: l10n.myProfile,
          ),
        ],
      ),
    );
  }
}
