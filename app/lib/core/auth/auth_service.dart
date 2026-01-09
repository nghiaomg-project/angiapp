import 'package:flutter/foundation.dart';

class AuthService extends ChangeNotifier {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  bool _isLoggedIn = false;
  String? _pendingRoute;

  bool get isLoggedIn => _isLoggedIn;
  String? get pendingRoute => _pendingRoute;

  void login() {
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _pendingRoute = null;
    notifyListeners();
  }

  void setPendingRoute(String? route) {
    _pendingRoute = route;
  }

  void clearPendingRoute() {
    _pendingRoute = null;
  }
}

