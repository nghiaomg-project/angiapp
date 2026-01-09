import 'package:heroicons/heroicons.dart';
import '../icons/app_icons.dart';

class BottomNavTab {
  final String route;
  final String label;
  final HeroIcons icon;
  final bool requiresLogin;

  const BottomNavTab({
    required this.route,
    required this.label,
    required this.icon,
    this.requiresLogin = false,
  });
}

class BottomNavConfig {
  static const List<BottomNavTab> tabs = [
    BottomNavTab(route: '/home', label: 'Khám phá', icon: AppIcons.home),
    BottomNavTab(
      route: '/ingredients',
      label: 'Tìm món',
      icon: AppIcons.search,
    ),
    BottomNavTab(
      route: '/favorites',
      label: 'Yêu thích',
      icon: AppIcons.heart,
      requiresLogin: true,
    ),
  ];

  static int getTabIndex(String route) {
    return tabs.indexWhere((tab) => tab.route == route);
  }

  static String getRoute(int index) {
    if (index >= 0 && index < tabs.length) {
      return tabs[index].route;
    }
    return '/home';
  }

  static bool requiresLogin(int index) {
    if (index >= 0 && index < tabs.length) {
      return tabs[index].requiresLogin;
    }
    return false;
  }
}
