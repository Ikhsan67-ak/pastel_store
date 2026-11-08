
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.1.4:8085';

  // READ: Mengambil semua produk
  Future<List<Product>> fetchProducts() async {
    final response = await http.get(
      Uri.parse('$baseUrl/products?limit=0'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List productsJson = data['products'];

      return productsJson
          .map((json) => Product.fromJson(json))
          .toList();
    } else {
      throw Exception('Gagal mengambil data produk');
    }
  }

  // SEARCH: Mencari produk
  Future<List<Product>> searchProducts(String query) async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/products?q=${Uri.encodeQueryComponent(query)}&limit=0',
      ),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List productsJson = data['products'];

      return productsJson
          .map((json) => Product.fromJson(json))
          .toList();
    } else {
      throw Exception('Gagal mencari produk');
    }
  }

  // DETAIL: Mengambil satu produk
  Future<Product> fetchProductDetail(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/products/$id'),
    );

    if (response.statusCode == 200) {
      return Product.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal mengambil detail produk');
    }
  }

  // CREATE: Menambahkan produk
  Future<Product> createProduct({
    required String title,
    required String description,
    required String category,
    required double price,
    required int stock,
    required String brand,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/products/add'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': title,
        'description': description,
        'category': category,
        'price': price,
        'stock': stock,
        'brand': brand,
      }),
    );

    if (response.statusCode == 201) {
      return Product.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal menambahkan produk: ${response.body}');
    }
  }

  // UPDATE: Mengubah produk
  Future<Product> updateProduct({
    required int id,
    required String title,
    required String description,
    required String category,
    required double price,
    required int stock,
    required String brand,
  }) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/products/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': title,
        'description': description,
        'category': category,
        'price': price,
        'stock': stock,
        'brand': brand,
      }),
    );

    if (response.statusCode == 200) {
      return Product.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal mengubah produk: ${response.body}');
    }
  }

  // DELETE: Menghapus produk
  Future<void> deleteProduct(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/products/$id'),
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus produk: ${response.body}');
    }
  }
}
