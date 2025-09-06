import 'dart:convert';
import 'package:ebs/model/Designation.dart';
import 'package:http/http.dart' as http;

class DesignationService {
  final String baseUrl = 'http://localhost:8080/designation';

  Future<List<Designation>> getDesignations() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((desig) => Designation.fromJson(desig)).toList();
    } else {
      throw Exception('Failed to load designations');
    }
  }

  Future<Designation> createDesignation(Designation designation) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(designation.toJson()),
    );
    if (response.statusCode == 200) {
      return Designation.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create designation');
    }
  }

  Future<Designation> updateDesignation(Designation designation) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${designation.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(designation.toJson()),
    );
    if (response.statusCode == 200) {
      return Designation.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update designation');
    }
  }

  Future<void> deleteDesignation(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete designation');
    }
  }
}