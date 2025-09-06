import 'dart:convert';
import 'package:ebs/model/Department.dart';
import 'package:http/http.dart' as http;

class DepartmentService {
  final String baseUrl = 'http://localhost:8080/department';

  Future<List<Department>> getDepartments() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((dept) => Department.fromJson(dept)).toList();
    } else {
      throw Exception('Failed to load departments');
    }
  }

  Future<Department> createDepartment(Department department) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(department.toJson()),
    );
    if (response.statusCode == 200) {
      return Department.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create department');
    }
  }

  Future<Department> updateDepartment(Department department) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${department.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(department.toJson()),
    );
    if (response.statusCode == 200) {
      return Department.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update department');
    }
  }

  Future<void> deleteDepartment(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete department');
    }
  }
}