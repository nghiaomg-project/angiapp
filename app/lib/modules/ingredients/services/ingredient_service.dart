import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../home/models/food.dart';

class IngredientService {
  Future<List<Food>> searchFoodsByIngredients(List<String> ingredients) async {
    try {
      final baseUrl = dotenv.env['BASE_URL'];
      if (baseUrl == null) throw Exception('BASE_URL not found in .env');

      final response = await http.post(
        Uri.parse('$baseUrl/foods/search/ingredients'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'ingredients': ingredients}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['data'] != null) {
          final List<dynamic> foodsJson = data['data'];
          return foodsJson.map((json) => Food.fromJson(json)).toList();
        }
        return [];
      } else {
        throw Exception('Failed to search foods: ${response.statusCode}');
      }
    } catch (e) {
      print('Error searching foods: $e');
      throw Exception('Failed to search foods');
    }
  }
}
