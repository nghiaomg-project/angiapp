import 'package:flutter/material.dart';
import '../../home/models/food.dart';
import '../../home/services/food_service.dart';

class FoodDetailScreen extends StatefulWidget {
  const FoodDetailScreen({super.key});

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  Food? _food;
  bool _isLoading = true;
  String? _errorMessage;
  final FoodService _foodService = FoodService();
  String? _foodId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is String && _foodId == null) {
      _foodId = args;
      _loadFood();
    }
  }

  Future<void> _loadFood() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final food = await _foodService.getFoodById(_foodId!);
      setState(() {
        _food = food;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleFavorite() async {
    if (_food == null) return;
    
    // Optimistic update could be done here, or wait for server.
    // Let's wait for server for consistency or do optimistic if slow.
    // Server returns updated food object.
    try {
      final updatedFood = await _foodService.toggleFavorite(_foodId!);
      setState(() {
        _food = updatedFood;
      });
    } catch (e) {
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Colors from design
    const primaryColor = Color(0xFFFF7A00);
    const backgroundLight = Color(0xFFF8F8F5);

    if (_foodId == null) {
       return const Scaffold(body: Center(child: Text('No food ID provided')));
    }
    
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_errorMessage != null) {
      return Scaffold(body: Center(child: Text('Error: $_errorMessage')));
    }

    if (_food == null) {
      return const Scaffold(body: Center(child: Text('Food not found')));
    }

    final food = _food!;
    
    return Scaffold(
      backgroundColor: backgroundLight,
      body: Stack(
            children: [
              // Header Image
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: MediaQuery.of(context).size.height * 0.45,
                child: Image.network(
                  food.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey),
                ),
              ),
              
              // Gradient Overlay on Image
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: MediaQuery.of(context).size.height * 0.45,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.black.withOpacity(0.4), Colors.transparent, Colors.black.withOpacity(0.1)],
                    ),
                  ),
                ),
              ),

              // Content Scroll
              SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.38), // Leave space for image
                    Container(
                      decoration: const BoxDecoration(
                        color: backgroundLight,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(32),
                          topRight: Radius.circular(32),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 20,
                            offset: Offset(0, -5),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Handle bar
                          Center(
                            child: Container(
                              width: 48,
                              height: 6,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Title and Meta
                          Text(
                            food.title,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1C1C0D),
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // Meta Tags
                          Wrap(
                            spacing: 12, 
                            runSpacing: 12,
                            children: [
                              if (food.time.isNotEmpty) _buildTag(Icons.schedule, food.time, primaryColor),
                              if (food.difficulty.isNotEmpty) _buildTag(Icons.local_fire_department, food.difficulty, primaryColor),
                              if (food.servings.isNotEmpty) _buildTag(Icons.restaurant, food.servings, primaryColor),
                            ],
                          ),
                          const SizedBox(height: 32),

                          // Actions
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.play_arrow),
                                  label: const Text('Bắt đầu nấu'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor,
                                    foregroundColor: Colors.white,
                                    elevation: 4,
                                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.grey[300]!),
                                  color: Colors.white,
                                ),
                                child: IconButton(
                                  icon: Icon(food.isFavorite ? Icons.favorite : Icons.favorite_border),
                                  color: food.isFavorite ? Colors.red : Colors.grey[500],
                                  iconSize: 24,
                                  onPressed: _toggleFavorite,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),

                          // Ingredients
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Nguyên liệu', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1C1C0D))),
                              Text('${food.ingredients.length} món', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey)),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: food.ingredients.length,
                            itemBuilder: (context, index) {
                              final ingredient = food.ingredients[index];
                              return _buildIngredientItem(ingredient.name, ingredient.amount, primaryColor);
                            },
                          ),
                          const SizedBox(height: 32),

                          // Instructions (Steps)
                          const Text('Cách làm', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1C1C0D))),
                          const SizedBox(height: 20),
                          ...food.steps.map((step) => _buildStep(
                            step.index, 
                            step.title, 
                            step.description, 
                            primaryColor,
                            imageUrl: step.imageUrl.isNotEmpty ? step.imageUrl : null
                          )),
                          
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Custom App Bar (Back and Share) - Moved to bottom to be on top
              Positioned(
                top: MediaQuery.of(context).padding.top + 10,
                left: 16,
                right: 16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildGlassButton(Icons.arrow_back, () => Navigator.pop(context)),
                    _buildGlassButton(Icons.share, () {}),
                  ],
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildGlassButton(IconData icon, VoidCallback onPressed) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 20),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildTag(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 6),
          Text(text, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey[800])),
        ],
      ),
    );
  }

  Widget _buildIngredientItem(String name, String amount, Color activeColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.transparent),
      ),
      child: Row(
        children: [
           Container(
             width: 24,
             height: 24,
             decoration: BoxDecoration(
               borderRadius: BorderRadius.circular(6),
               border: Border.all(color: Colors.grey[300]!, width: 2),
             ),
             child: const Icon(Icons.check, size: 16, color: Colors.transparent), 
           ),
           const SizedBox(width: 12),
           Expanded(
             child: Text(name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[800])),
           ),
           Text(amount, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildStep(int index, String title, String description, Color primaryColor, {String? imageUrl}) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: index == 1 ? primaryColor : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: index == 1 ? primaryColor : Colors.grey[300]!),
                  boxShadow: index == 1 ? [const BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0,2))] : [],
                ),
                alignment: Alignment.center,
                child: Text(
                  '$index',
                  style: TextStyle(
                    fontSize: 18, 
                    fontWeight: FontWeight.bold, 
                    color: index == 1 ? Colors.white : Colors.grey[500]
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  width: 2,
                  color: Colors.grey[200],
                  margin: const EdgeInsets.symmetric(vertical: 4),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1C1C0D))),
                  const SizedBox(height: 4),
                  Text(description, style: TextStyle(fontSize: 14, height: 1.5, color: Colors.grey[600])),
                  if (imageUrl != null) ...[
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        imageUrl, 
                        height: 120, 
                        width: double.infinity, 
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, err, stack) => const SizedBox(),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}