import 'package:flutter/material.dart';
import '../../../core/layouts/main_layout.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Favorites',
      body: const Center(
        child: Text('Favorites Screen'),
      ),
    );
  }
}

