import 'package:flutter/material.dart';
import '../../../core/layouts/main_layout.dart';
import '../widgets/food_card.dart';
import '../services/food_service.dart';
import '../models/food.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Food>> _foodsFuture;
  final FoodService _foodService = FoodService();

  @override
  void initState() {
    super.initState();
    _foodsFuture = _foodService.getFoods();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF23220f) : const Color(0xFFf8f8f5);
    final textSecondary = isDark ? Colors.grey[400] : const Color(0xFF9e9d47);

    return MainLayout(
      title: 'Ăn gì?',
      body: Container(
        color: bgColor,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 24),
                child: Text(
                  'Hôm nay bạn muốn ăn gì?',
                  style: TextStyle(
                    color: textSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              FutureBuilder<List<Food>>(
                future: _foodsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Lỗi: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                     return const Center(child: Text('Chưa có món ăn nào.'));
                  }

                  final foods = snapshot.data!;
                  return Column(
                    children: foods.map((food) => FoodCard(
                      title: food.title,
                      description: food.description,
                      imageUrl: food.imageUrl,
                      imageAlt: food.imageAlt,
                      isFavorite: food.isFavorite,
                      onTap: () {
                         Navigator.pushNamed(
                           context, 
                           '/food-detail',
                           arguments: food.id,
                         ).then((_) => setState(() {
                            // Reload to update favorites if changed
                            _foodsFuture = _foodService.getFoods();
                         }));
                      },
                    )).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
