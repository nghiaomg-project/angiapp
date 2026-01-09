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
    final textPrimary = isDark ? Colors.white : const Color(0xFF1c1c0d);
    final textSecondary = isDark ? Colors.grey[400] : const Color(0xFF9e9d47);

    return MainLayout(
      title: 'Foodie',
      body: Container(
        color: bgColor,
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 140),
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
                             );
                          },
                        )).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTapDown: (_) {},
                  onTapUp: (_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Gợi ý món mới')),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF7A00),
                      borderRadius: BorderRadius.circular(9999),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF7A00).withValues(alpha: 0.4),
                          blurRadius: 15,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.autorenew,
                          color: Color(0xFF1c1c0d),
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Gợi ý món mới',
                          style: TextStyle(
                            color: textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
