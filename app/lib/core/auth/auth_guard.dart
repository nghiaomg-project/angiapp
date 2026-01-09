import 'package:flutter/material.dart';
import '../config/protected_screens.dart';
import 'auth_service.dart';

class AuthGuard {
  static final AuthService _authService = AuthService();

  static void navigate(BuildContext context, String routeName) {
    if (ProtectedScreens.isProtected(routeName) && !_authService.isLoggedIn) {
      _authService.setPendingRoute(routeName);
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      if (ModalRoute.of(context)?.settings.name != routeName) {
        Navigator.pushReplacementNamed(context, routeName);
      }
    }
  }

  static void navigateAfterLogin(BuildContext context) {
    final pendingRoute = _authService.pendingRoute ?? '/home';
    _authService.clearPendingRoute();
    Navigator.pushReplacementNamed(context, pendingRoute);
  }

  static void navigateToTab(BuildContext context, int tabIndex) {
    final route = _getRouteForTab(tabIndex);
    navigate(context, route);
  }

  static String _getRouteForTab(int index) {
    switch (index) {
      case 0:
        return '/home';
      case 1:
        return '/search';
      case 2:
        return '/favorites';
      case 3:
        return '/profile';
      default:
        return '/home';
    }
  }
}

