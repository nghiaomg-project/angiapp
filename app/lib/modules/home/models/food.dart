class Ingredient {
  final String name;
  final String amount;

  Ingredient({required this.name, required this.amount});

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      name: json['name'] ?? '',
      amount: json['amount'] ?? '',
    );
  }
}

class StepItem {
  final int index;
  final String title;
  final String description;
  final String imageUrl;

  StepItem({
    required this.index,
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  factory StepItem.fromJson(Map<String, dynamic> json) {
    return StepItem(
      index: json['index'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['image_url'] ?? '',
    );
  }
}

class Food {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String imageAlt;
  final bool isFavorite;
  final String time;
  final String difficulty;
  final String servings;
  final List<Ingredient> ingredients;
  final List<StepItem> steps;

  Food({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.imageAlt,
    required this.isFavorite,
    required this.time,
    required this.difficulty,
    required this.servings,
    required this.ingredients,
    required this.steps,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['image_url'] ?? '',
      imageAlt: json['image_alt'] ?? '',
      isFavorite: json['is_favorite'] ?? false,
      time: json['time'] ?? '',
      difficulty: json['difficulty'] ?? '',
      servings: json['servings'] ?? '',
      ingredients: (json['ingredients'] as List<dynamic>?)
              ?.map((e) => Ingredient.fromJson(e))
              .toList() ??
          [],
      steps: (json['steps'] as List<dynamic>?)
              ?.map((e) => StepItem.fromJson(e))
              .toList() ??
          [],
    );
  }
}