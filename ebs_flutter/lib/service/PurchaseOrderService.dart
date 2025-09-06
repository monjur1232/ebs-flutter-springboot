import 'dart:convert';
import 'package:ebs/model/PurchaseOrder.dart';
import 'package:http/http.dart' as http;

class PurchaseOrderService {
  final String baseUrl = 'http://localhost:8080/purchase-order';

  Future<List<PurchaseOrder>> getPurchaseOrders() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((po) => PurchaseOrder.fromJson(po)).toList();
    } else {
      throw Exception('Failed to load purchase orders');
    }
  }

  Future<PurchaseOrder> createPurchaseOrder(PurchaseOrder purchaseOrder) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(purchaseOrder.toJson()),
    );
    if (response.statusCode == 200) {
      return PurchaseOrder.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create purchase order');
    }
  }

  Future<PurchaseOrder> updatePurchaseOrder(PurchaseOrder purchaseOrder) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${purchaseOrder.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(purchaseOrder.toJson()),
    );
    if (response.statusCode == 200) {
      return PurchaseOrder.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update purchase order');
    }
  }

  Future<void> deletePurchaseOrder(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete purchase order');
    }
  }
}