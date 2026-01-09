import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import '../../../core/icons/app_icons.dart';
import '../../../core/layouts/main_layout.dart';

import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import '../../../core/icons/app_icons.dart';
import '../../../core/layouts/main_layout.dart';
import '../../home/models/food.dart';
import '../services/ingredient_service.dart';

class IngredientsScreen extends StatefulWidget {
  const IngredientsScreen({super.key});

  @override
  State<IngredientsScreen> createState() => _IngredientsScreenState();
}

class _IngredientsScreenState extends State<IngredientsScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _selectedIngredients = [];
  final IngredientService _ingredientService = IngredientService();
  List<Food> _suggestedFoods = [];
  bool _isLoading = false;
  bool _hasSearched = false;

  void _addIngredient() {
    final text = _controller.text.trim();
    if (text.isNotEmpty && !_selectedIngredients.contains(text)) {
      setState(() {
        _selectedIngredients.add(text);
        _controller.clear();
      });
    }
  }

  void _removeIngredient(String ingredient) {
    setState(() {
      _selectedIngredients.remove(ingredient);
    });
  }

  Future<void> _searchFoods() async {
    if (_selectedIngredients.isEmpty) {
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vui lòng chọn ít nhất 1 nguyên liệu')));
       return;
    }
    setState(() {
      _isLoading = true;
      _hasSearched = true;
    });
    try {
      final foods = await _ingredientService.searchFoodsByIngredients(_selectedIngredients);
      setState(() {
        _suggestedFoods = foods;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  // Calculate status: "x/y Có sẵn" based on selected ingredients matching food ingredients
  String _calculateStatus(Food food, Color? color) {
    // Simple matching: check if food ingredient name contains any selected ingredient string (or vice versa)
    // For now, let's just count matches.
    int matches = 0;
    for (var fIng in food.ingredients) {
      for (var sIng in _selectedIngredients) {
        if (fIng.name.toLowerCase().contains(sIng.toLowerCase()) || sIng.toLowerCase().contains(fIng.name.toLowerCase())) {
          matches++;
          break;
        }
      }
    }
    
    int total = food.ingredients.length;
    if (matches == total) return 'Đủ nguyên liệu';
    return '$matches/$total Có sẵn';
  }

  Color _calculateStatusColor(Food food) {
    int matches = 0;
    for (var fIng in food.ingredients) {
      for (var sIng in _selectedIngredients) {
        if (fIng.name.toLowerCase().contains(sIng.toLowerCase()) || sIng.toLowerCase().contains(fIng.name.toLowerCase())) {
          matches++;
          break;
        }
      }
    }
    int total = food.ingredients.length;
    if (matches == total) return Colors.green;
    if (matches > 0) return Colors.green; // Partial match is still good
    return Colors.orange;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF23220f) : const Color(0xFFf8f8f5);
    final textMain = isDark ? Colors.white : const Color(0xFF1c1c0d);
    final textMuted = isDark ? Colors.grey[400] : const Color(0xFF9e9d47);
    final surfaceColor = isDark ? const Color(0xFF23220f) : const Color(0xFFf8f8f5);
    final primaryColor = textMain; // Use text color for icon as per design, or use App primary

    return MainLayout(
      title: 'Tìm Món Từ Nguyên Liệu',
      showAppBar: false,
      body: Container(
        color: bgColor,
        child: Column(
          children: [
            // Sticky header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: bgColor.withOpacity(0.9),
                border: Border(
                  bottom: BorderSide(
                    color: isDark ? const Color(0xFF374151) : const Color(0xFFF3F4F6),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Tìm Món Từ Nguyên Liệu',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textMain,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    Text(
                      'Bạn có gì trong tủ lạnh?',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: textMain,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Chọn ít nhất 1 nguyên liệu để nhận gợi ý tốt nhất.',
                      style: TextStyle(fontSize: 14, color: textMuted),
                    ),
                    const SizedBox(height: 16),
                    
                    // Input Row
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: surfaceColor,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 2,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: _controller,
                              onSubmitted: (_) => _addIngredient(),
                              decoration: InputDecoration(
                                hintText: 'Nhập tôm, thịt, trứng...',
                                hintStyle: TextStyle(color: textMuted),
                                prefixIcon: Icon(Icons.search, color: textMuted),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                filled: true,
                                fillColor: surfaceColor,
                              ),
                              style: TextStyle(color: textMain),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Material(
                          color: surfaceColor,
                          borderRadius: BorderRadius.circular(12),
                          child: InkWell(
                            onTap: _addIngredient,
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 2,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.add, size: 18, color: textMain),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Thêm',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: textMain,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Chips
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _selectedIngredients.map((ing) => _IngredientChip(
                        label: ing,
                        delay: 0,
                        onRemove: () => _removeIngredient(ing),
                      )).toList(),
                    ),
                    const SizedBox(height: 32),
                    
                    // Search Button
                    SizedBox(
                      width: double.infinity,
                      child: Material(
                        color: const Color(0xFFFF7A00),
                        borderRadius: BorderRadius.circular(9999),
                        child: InkWell(
                          onTap: _isLoading ? null : _searchFoods,
                          borderRadius: BorderRadius.circular(9999),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                            alignment: Alignment.center,
                            child: _isLoading 
                              ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                              : const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.soup_kitchen, color: Colors.white),
                                    SizedBox(width: 8),
                                    Text(
                                      'Gợi ý món ngay',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    Container(height: 1, color: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB)),
                    const SizedBox(height: 24),
                    
                    // Results Header
                    if (_suggestedFoods.isNotEmpty || _hasSearched) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Món ngon có thể nấu (${_suggestedFoods.length})',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: textMain,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Results List
                    if (_suggestedFoods.isEmpty && _hasSearched && !_isLoading)
                       Center(child: Text('Không tìm thấy món ăn nào phù hợp.', style: TextStyle(color: textMuted))),

                    Column(
                      children: _suggestedFoods.map((food) => GestureDetector(
                        onTap: () {
                           Navigator.pushNamed(
                             context, 
                             '/food-detail',
                             arguments: food.id,
                           );
                        },
                        child:Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: _RecipeCard(
                            imageUrl: food.imageUrl,
                            title: food.title,
                            description: food.description,
                            time: food.time.isNotEmpty ? food.time : '??p',
                            status: _calculateStatus(food, null),
                            statusColor: _calculateStatusColor(food),
                            isDark: isDark,
                            textMain: textMain,
                            textMuted: textMuted!,
                            surfaceColor: surfaceColor,
                          ),
                        ),
                      )).toList(),
                    ),
                    
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Ingredient chip widget - converted from ingredient chips in HTML
class _IngredientChip extends StatelessWidget {
  final String label;
  final int delay;
  final VoidCallback onRemove;

  const _IngredientChip({
    required this.label,
    required this.delay,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 400 + delay),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 10 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFFF7A00),
          borderRadius: BorderRadius.circular(9999),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 4),
            Material(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                onTap: onRemove,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 20,
                  height: 20,
                  alignment: Alignment.center,
                  child: const Icon(Icons.close, size: 14, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Recipe card widget - converted from recipe cards in HTML
class _RecipeCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final String time;
  final String status;
  final Color statusColor;
  final bool isDark;
  final Color textMain;
  final Color textMuted;
  final Color surfaceColor;
  final double opacity;

  const _RecipeCard({
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.time,
    required this.status,
    required this.statusColor,
    required this.isDark,
    required this.textMain,
    required this.textMuted,
    required this.surfaceColor,
    this.opacity = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? const Color(0xFF374151) : Colors.transparent,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imageUrl,
                width: 96,
                height: 96,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 96,
                    height: 96,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image_not_supported),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textMain,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(fontSize: 14, color: textMuted),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      // Time
                      Row(
                        children: [
                          Icon(Icons.schedule, size: 14, color: textMuted),
                          const SizedBox(width: 4),
                          Text(
                            time,
                            style: TextStyle(
                              fontSize: 12,
                              color: textMuted,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      // Status badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor == Colors.green
                              ? (isDark
                                    ? Colors.green.withOpacity(0.2)
                                    : const Color(0xFFF0FDF4))
                              : (isDark
                                    ? Colors.orange.withOpacity(0.2)
                                    : const Color(0xFFFFF7ED)),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              statusColor == Colors.green
                                  ? Icons.check_circle
                                  : Icons.timelapse,
                              size: 14,
                              color: statusColor == Colors.green
                                  ? (isDark
                                        ? Colors.green[300]
                                        : Colors.green[700])
                                  : (isDark
                                        ? Colors.orange[300]
                                        : Colors.orange[700]),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              status,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: statusColor == Colors.green
                                    ? (isDark
                                          ? Colors.green[300]
                                          : Colors.green[700])
                                    : (isDark
                                          ? Colors.orange[300]
                                          : Colors.orange[700]),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Bottom navigation item widget
class _BottomNavItem extends StatelessWidget {
  final HeroIcons icon;
  final String label;
  final bool isActive;
  final bool isSpecial;
  final VoidCallback onTap;
  final bool isDark;
  final Color textMain;

  const _BottomNavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    this.isSpecial = false,
    required this.onTap,
    required this.isDark,
    required this.textMain,
  });

  @override
  Widget build(BuildContext context) {
    if (isSpecial && isActive) {
      // Special orange circle for search tab when active
      return GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Transform.translate(
              offset: const Offset(0, -32),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF7A00),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF23220f)
                        : const Color(0xFFf8f8f5),
                    width: 4,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: HeroIcon(AppIcons.search, color: Colors.white, size: 24),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: textMain,
              ),
            ),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          HeroIcon(
            icon,
            color: isActive ? textMain : const Color(0xFF9CA3AF),
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              color: isActive ? textMain : const Color(0xFF9CA3AF),
            ),
          ),
        ],
      ),
    );
  }
}
