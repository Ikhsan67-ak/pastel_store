import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  static const String baseUrl = 'https://dummyjson.com';

  Future<List<Product>> fetchProducts() async {
    final response = await http.get(
      Uri.parse('$baseUrl/products'),
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

  Future<List<Product>> searchProducts(String query) async {
    final response = await http.get(
      Uri.parse('$baseUrl/products/search?q=$query'),
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

  Future<Product> fetchProductDetail(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/products/$id'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Product.fromJson(data);
    } else {
      throw Exception('Gagal mengambil detail produk');
    }
  }
}