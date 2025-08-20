import 'dart:convert';
import 'package:ebs/model/SalesOrder.dart';
import 'package:http/http.dart' as http;

class SalesOrderService {
  final String baseUrl = 'http://localhost:8080/sales-order';

  Future<List<SalesOrder>> getSalesOrders() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((so) => SalesOrder.fromJson(so)).toList();
    } else {
      throw Exception('Failed to load sales orders');
    }
  }

  Future<SalesOrder> createSalesOrder(SalesOrder salesOrder) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(salesOrder.toJson()),
    );
    if (response.statusCode == 200) {
      return SalesOrder.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create sales order');
    }
  }

  Future<SalesOrder> updateSalesOrder(SalesOrder salesOrder) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${salesOrder.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(salesOrder.toJson()),
    );
    if (response.statusCode == 200) {
      return SalesOrder.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update sales order');
    }
  }

  Future<void> deleteSalesOrder(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete sales order');
    }
  }
}