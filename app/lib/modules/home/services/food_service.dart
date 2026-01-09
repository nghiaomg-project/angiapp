import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/food.dart';

class FoodService {
  Future<List<Food>> getFoods() async {
    try {
      final baseUrl = dotenv.env['BASE_URL'];
      if (baseUrl == null) throw Exception('BASE_URL not found in .env');

      final response = await http.get(Uri.parse('$baseUrl/foods'));
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['data'] != null) {
           final List<dynamic> foodsJson = data['data'];
           return foodsJson.map((json) => Food.fromJson(json)).toList();
        }
        return [];
      } else {
        throw Exception('Failed to load foods: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching foods: $e');
      throw Exception('Failed to load foods');
    }
  }

  Future<Food> getFoodById(String id) async {
    try {
      final baseUrl = dotenv.env['BASE_URL'];
      if (baseUrl == null) throw Exception('BASE_URL not found in .env');

      final response = await http.get(Uri.parse('$baseUrl/foods/$id'));
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['data'] != null) {
           return Food.fromJson(data['data']);
        }
        throw Exception('Food data empty');
      } else {
        throw Exception('Failed to load food: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching food detail: $e');
      throw Exception('Failed to load food');
    }
  }

  Future<Food> toggleFavorite(String id) async {
    try {
      final baseUrl = dotenv.env['BASE_URL'];
      if (baseUrl == null) throw Exception('BASE_URL not found in .env');

      final response = await http.post(
        Uri.parse('$baseUrl/foods/$id/favorite'),
        headers: {'Content-Type': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['data'] != null) {
           return Food.fromJson(data['data']);
        }
        throw Exception('Food data empty');
      } else {
        throw Exception('Failed to toggle favorite: ${response.statusCode}');
      }
    } catch (e) {
      print('Error toggling favorite: $e');
      rethrow;
    }
  }
}
