import 'dart:convert';
import 'package:ebs/model/SalesReturn.dart';
import 'package:http/http.dart' as http;

class SalesReturnService {
  final String baseUrl = 'http://localhost:8080/sales-return';

  Future<List<SalesReturn>> getSalesReturns() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((sr) => SalesReturn.fromJson(sr)).toList();
    } else {
      throw Exception('Failed to load sales returns');
    }
  }

  Future<SalesReturn> createSalesReturn(SalesReturn salesReturn) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(salesReturn.toJson()),
    );
    if (response.statusCode == 200) {
      return SalesReturn.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create sales return');
    }
  }

  Future<SalesReturn> updateSalesReturn(SalesReturn salesReturn) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${salesReturn.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(salesReturn.toJson()),
    );
    if (response.statusCode == 200) {
      return SalesReturn.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update sales return');
    }
  }

  Future<void> deleteSalesReturn(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete sales return');
    }
  }
}