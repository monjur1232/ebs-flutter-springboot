import 'dart:convert';
import 'package:ebs/model/ProductCategory.dart';
import 'package:http/http.dart' as http;

class ProductCategoryService {
  final String baseUrl = 'http://localhost:8080/product-category';

  Future<List<ProductCategory>> getProductCategories() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((cat) => ProductCategory.fromJson(cat)).toList();
    } else {
      throw Exception('Failed to load product categories');
    }
  }

  Future<ProductCategory> createProductCategory(ProductCategory category) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(category.toJson()),
    );
    if (response.statusCode == 200) {
      return ProductCategory.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create product category');
    }
  }

  Future<ProductCategory> updateProductCategory(ProductCategory category) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${category.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(category.toJson()),
    );
    if (response.statusCode == 200) {
      return ProductCategory.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update product category');
    }
  }

  Future<void> deleteProductCategory(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete product category');
    }
  }
}