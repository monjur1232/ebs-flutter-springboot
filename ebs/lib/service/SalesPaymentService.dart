import 'dart:convert';
import 'package:ebs/model/SalesPayment.dart';
import 'package:http/http.dart' as http;

class SalesPaymentService {
  final String baseUrl = 'http://localhost:8080/sales-payment';

  Future<List<SalesPayment>> getSalesPayments() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((sp) => SalesPayment.fromJson(sp)).toList();
    } else {
      throw Exception('Failed to load sales payments');
    }
  }

  Future<SalesPayment> createSalesPayment(SalesPayment salesPayment) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(salesPayment.toJson()),
    );
    if (response.statusCode == 200) {
      return SalesPayment.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create sales payment');
    }
  }

  Future<SalesPayment> updateSalesPayment(SalesPayment salesPayment) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${salesPayment.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(salesPayment.toJson()),
    );
    if (response.statusCode == 200) {
      return SalesPayment.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update sales payment');
    }
  }

  Future<void> deleteSalesPayment(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete sales payment');
    }
  }
}