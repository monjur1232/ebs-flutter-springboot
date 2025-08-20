import 'dart:convert';
import 'package:ebs/model/Payment.dart';
import 'package:http/http.dart' as http;

class PaymentService {
  final String baseUrl = 'http://localhost:8080/payment';

  Future<List<Payment>> getPayments() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((payment) => Payment.fromJson(payment)).toList();
    } else {
      throw Exception('Failed to load payments');
    }
  }

  Future<Payment> createPayment(Payment payment) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(payment.toJson()),
    );
    if (response.statusCode == 200) {
      return Payment.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create payment');
    }
  }

  Future<Payment> updatePayment(Payment payment) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${payment.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(payment.toJson()),
    );
    if (response.statusCode == 200) {
      return Payment.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update payment');
    }
  }

  Future<void> deletePayment(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete payment');
    }
  }
}