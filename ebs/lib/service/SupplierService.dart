import 'dart:convert';
import 'package:ebs/model/Supplier.dart';
import 'package:http/http.dart' as http;

class SupplierService {
  final String baseUrl = 'http://localhost:8080/supplier';

  Future<List<Supplier>> getSuppliers() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((supplier) => Supplier.fromJson(supplier)).toList();
    } else {
      throw Exception('Failed to load suppliers');
    }
  }

  Future<Supplier> createSupplier(Supplier supplier) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(supplier.toJson()),
    );
    if (response.statusCode == 200) {
      return Supplier.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create supplier');
    }
  }

  Future<Supplier> updateSupplier(Supplier supplier) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${supplier.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(supplier.toJson()),
    );
    if (response.statusCode == 200) {
      return Supplier.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update supplier');
    }
  }

  Future<void> deleteSupplier(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete supplier');
    }
  }
}