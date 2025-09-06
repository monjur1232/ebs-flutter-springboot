import 'dart:convert';
import 'package:ebs/model/Return.dart';
import 'package:http/http.dart' as http;

class ReturnService {
  final String baseUrl = 'http://localhost:8080/return';

  Future<List<Return>> getReturns() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((ret) => Return.fromJson(ret)).toList();
    } else {
      throw Exception('Failed to load returns');
    }
  }

  Future<Return> createReturn(Return returnData) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(returnData.toJson()),
    );
    if (response.statusCode == 200) {
      return Return.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create return');
    }
  }

  Future<Return> updateReturn(Return returnData) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${returnData.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(returnData.toJson()),
    );
    if (response.statusCode == 200) {
      return Return.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update return');
    }
  }

  Future<void> deleteReturn(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete return');
    }
  }
}