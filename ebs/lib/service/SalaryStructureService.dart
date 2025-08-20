import 'dart:convert';
import 'package:ebs/model/SalaryStructure.dart';
import 'package:http/http.dart' as http;

class SalaryStructureService {
  final String baseUrl = 'http://localhost:8080/salary-structure';

  Future<List<SalaryStructure>> getSalaryStructures() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((ss) => SalaryStructure.fromJson(ss)).toList();
    } else {
      throw Exception('Failed to load salary structures');
    }
  }

  Future<SalaryStructure> createSalaryStructure(SalaryStructure salaryStructure) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(salaryStructure.toJson()),
    );
    if (response.statusCode == 200) {
      return SalaryStructure.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create salary structure');
    }
  }

  Future<SalaryStructure> updateSalaryStructure(SalaryStructure salaryStructure) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${salaryStructure.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(salaryStructure.toJson()),
    );
    if (response.statusCode == 200) {
      return SalaryStructure.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update salary structure');
    }
  }

  Future<void> deleteSalaryStructure(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete salary structure');
    }
  }
}