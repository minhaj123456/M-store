import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shoe_world/model/product.dart';

class ApiService {
  static const String baseUrl = 'https://fakestoreapi.com';

  static Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/products'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  static Future<List<String>> fetchCategories() async {
  final response = await http.get(Uri.parse('$baseUrl/products/categories'));
  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((e) => e.toString()).toList();
  } else {
    throw Exception('Failed to load categories');
  }
}

static Future<List<Product>> fetchProductsByCategory(String category) async {
  final response = await http.get(Uri.parse('$baseUrl/products/category/$category'));
  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((json) => Product.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load products by category');
  }
}
 // Make these PUBLIC
  static List<String> generateRandomColors() {
    final colors = ['Red', 'Blue', 'Green', 'Black', 'White', 'Yellow'];
    colors.shuffle();
    return colors.take(3).toList();
  }

  static List<String> generateRandomSizes() {
    final sizes = ['S', 'M', 'L', 'XL', 'XXL'];
    sizes.shuffle();
    return sizes.take(3).toList();
  }

  static Future<String?> login(String username, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/auth/login"),
      body: {
        "username": username,
        "password": password,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["token"]; // return JWT token
    } else {
      return null;
    }
  }
}
