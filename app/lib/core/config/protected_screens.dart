class ProtectedScreens {
  static const Set<String> protectedRoutes = {
    '/profile',
    '/favorites',
  };

  static bool isProtected(String routeName) {
    return protectedRoutes.contains(routeName);
  }
}