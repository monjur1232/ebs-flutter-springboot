import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ebs/model/Attendance.dart';

class AttendanceService {
  final String baseUrl = 'http://localhost:8080/attendance';

  Future<List<Attendance>> getAttendances() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((att) => Attendance.fromJson(att)).toList();
    } else {
      throw Exception('Failed to load attendances');
    }
  }

  Future<Attendance> createAttendance(Attendance attendance) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(attendance.toJson()),
    );
    if (response.statusCode == 200) {
      return Attendance.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create attendance');
    }
  }

  Future<List<Attendance>> createBulkAttendance(List<Attendance> attendances) async {
    final response = await http.post(
      Uri.parse('$baseUrl/bulk'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(attendances.map((a) => a.toJson()).toList()),
    );
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((att) => Attendance.fromJson(att)).toList();
    } else {
      throw Exception('Failed to create bulk attendance');
    }
  }

  Future<Attendance> updateAttendance(Attendance attendance) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${attendance.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(attendance.toJson()),
    );
    if (response.statusCode == 200) {
      return Attendance.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update attendance');
    }
  }

  Future<void> deleteAttendance(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete attendance');
    }
  }
}