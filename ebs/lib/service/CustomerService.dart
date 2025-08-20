import 'dart:convert';
import 'package:ebs/model/Customer.dart';
import 'package:http/http.dart' as http;

class CustomerService {
  final String baseUrl = 'http://localhost:8080/customer';

  Future<List<Customer>> getCustomers() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((customer) => Customer.fromJson(customer)).toList();
    } else {
      throw Exception('Failed to load customers');
    }
  }

  Future<Customer> createCustomer(Customer customer) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(customer.toJson()),
    );
    if (response.statusCode == 200) {
      return Customer.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create customer');
    }
  }

  Future<Customer> updateCustomer(Customer customer) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${customer.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(customer.toJson()),
    );
    if (response.statusCode == 200) {
      return Customer.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update customer');
    }
  }

  Future<void> deleteCustomer(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete customer');
    }
  }
}