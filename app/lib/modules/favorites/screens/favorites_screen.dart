import 'package:flutter/material.dart';
import '../../../core/layouts/main_layout.dart';

import '../../home/models/food.dart';
import '../../home/services/food_service.dart';
import '../../home/widgets/food_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final FoodService _foodService = FoodService();
  List<Food> _favoriteFoods = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() => _isLoading = true);
    try {
      final foods = await _foodService.getFoods();
      if (mounted) {
        setState(() {
          _favoriteFoods = foods.where((f) => f.isFavorite).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Không thể tải danh sách yêu thích: $e')),
        );
      }
    }
  }

  Future<void> _removeFavorite(Food food) async {
    try {
      await _foodService.toggleFavorite(food.id);
      if (mounted) {
        setState(() {
          _favoriteFoods.removeWhere((f) => f.id == food.id);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Yêu thích',
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadFavorites,
              child: _favoriteFoods.isEmpty
                  ? Center(
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.favorite_border, size: 64, color: Colors.grey[300]),
                            const SizedBox(height: 16),
                            Text(
                              'Chưa có món yêu thích nào',
                              style: TextStyle(fontSize: 18, color: Colors.grey[500]),
                            ),
                            const SizedBox(height: 200), // Ensure scrollable for RefreshIndicator
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _favoriteFoods.length,
                      itemBuilder: (context, index) {
                        final food = _favoriteFoods[index];
                        return FoodCard(
                          title: food.title,
                          description: food.description,
                          imageUrl: food.imageUrl,
                          imageAlt: food.imageAlt,
                          isFavorite: true,
                          onTap: () {
                            Navigator.pushNamed(
                              context, 
                              '/food-detail',
                              arguments: food.id,
                            ).then((_) => _loadFavorites()); // Reload when returning
                          },
                          onFavoriteTap: () => _removeFavorite(food),
                        );
                      },
                    ),
            ),
    );
  }
}

