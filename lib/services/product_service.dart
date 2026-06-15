import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ProductService {
  static const String _baseUrl = 'https://dummyjson.com';

  // GET — all products
  Future<List<ProductModel>> getProducts() async {
    final res = await http.get(Uri.parse('$_baseUrl/products'));
    final data = jsonDecode(res.body);
    return (data['products'] as List)
        .map((e) => ProductModel.fromJson(e))
        .toList();
  }

  // GET — single product by id
  Future<ProductModel> getProduct(int id) async {
    final res = await http.get(Uri.parse('$_baseUrl/products/$id'));
    return ProductModel.fromJson(jsonDecode(res.body));
  }

  // GET — search products
  Future<List<ProductModel>> searchProducts(String query) async {
    final res = await http
        .get(Uri.parse('$_baseUrl/products/search?q=$query'));
    final data = jsonDecode(res.body);
    return (data['products'] as List)
        .map((e) => ProductModel.fromJson(e))
        .toList();
  }

  // POST — add new product
  Future<ProductModel> addProduct({
    required String title,
    required double price,
    required String category,
  }) async {
    final res = await http.post(
      Uri.parse('$_baseUrl/products/add'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': title,
        'price': price,
        'category': category,
      }),
    );
    return ProductModel.fromJson(jsonDecode(res.body));
  }

  // PUT — update product
  Future<ProductModel> updateProduct({
    required int id,
    required String title,
    required double price,
    required String category,
  }) async {
    final res = await http.put(
      Uri.parse('$_baseUrl/products/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': title,
        'price': price,
        'category': category,
      }),
    );
    return ProductModel.fromJson(jsonDecode(res.body));
  }

  // DELETE — remove product
  Future<void> deleteProduct(int id) async {
    await http.delete(Uri.parse('$_baseUrl/products/$id'));
  }
}