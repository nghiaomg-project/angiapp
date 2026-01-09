import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import '../auth/auth_service.dart';
import '../navigation/bottom_nav_config.dart';
import '../icons/app_icons.dart';

class MainLayout extends StatelessWidget {
  final String title;
  final Widget body;
  final bool showAppBar;

  const MainLayout({
    super.key, 
    required this.title, 
    required this.body,
    this.showAppBar = true,
  });

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name ?? '/home';
    final routeIndex = BottomNavConfig.getTabIndex(currentRoute);
    final effectiveIndex = routeIndex >= 0 ? routeIndex : 0;
    final authService = AuthService();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF23220f) : const Color(0xFFf8f8f5);

    return Scaffold(
      appBar: showAppBar ? AppBar(
        title: Text(title),
        backgroundColor: bgColor,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/profile');
              },
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.grey[300],
                backgroundImage: authService.currentUser?.photoUrl != null
                    ? NetworkImage(authService.currentUser!.photoUrl!)
                    : null,
                child: authService.currentUser?.photoUrl == null
                    ? const Icon(Icons.person, color: Colors.grey)
                    : null,
              ),
            ),
          ),
        ],
      ) : null,
      body: SafeArea(child: body),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: effectiveIndex,
        onTap: (index) {
          if (effectiveIndex == index) {
            return;
          }

          final route = BottomNavConfig.getRoute(index);
          final requiresLogin = BottomNavConfig.requiresLogin(index);

          if (requiresLogin && !authService.isLoggedIn) {
            authService.setPendingRoute(route);
            Navigator.pushReplacementNamed(context, '/login');
            return;
          }

          if (ModalRoute.of(context)?.settings.name != route) {
            Navigator.pushReplacementNamed(context, route);
          }
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        items: BottomNavConfig.tabs.asMap().entries.map((entry) {
          final index = entry.key;
          final tab = entry.value;
          final isSelected = effectiveIndex == index;

          Widget iconWidget;
          if (isSelected && index == 1) {
            // Tab "Tìm món" (search) - active với vòng tròn cam
            iconWidget = Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFFF6B35), // Màu cam
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const HeroIcon(
                AppIcons.search,
                color: Colors.white,
                size: 24,
              ),
            );
          } else {
            // Tab inactive hoặc tab khác khi active
            iconWidget = HeroIcon(
              tab.icon,
              color: isSelected ? Colors.black : Colors.grey,
            );
          }

          return BottomNavigationBarItem(icon: iconWidget, label: tab.label);
        }).toList(),
      ),
    );
  }
}
