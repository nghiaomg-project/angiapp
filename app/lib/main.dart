import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/theme/app_theme.dart';
import 'modules/login/screens/login_screen.dart';
import 'modules/home/screens/home_screen.dart';
import 'modules/profile/screens/profile_screen.dart';
import 'modules/ingredients/screens/ingredients_screen.dart';
import 'modules/favorites/screens/favorites_screen.dart';
import 'modules/food/screens/food_detail_screen.dart';
import 'core/auth/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await AuthService().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'An Gi App',
      theme: AppTheme.lightTheme,
      initialRoute: '/home',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/search': (context) => const IngredientsScreen(),
        '/ingredients': (context) => const IngredientsScreen(), // Keep for backward compatibility
        '/favorites': (context) => const FavoritesScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/food-detail': (context) => const FoodDetailScreen(),
      },
    );
  }
}
