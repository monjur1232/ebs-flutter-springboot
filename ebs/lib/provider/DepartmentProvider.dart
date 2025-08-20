import 'package:ebs/model/Department.dart';
import 'package:ebs/service/DepartmentService.dart';
import 'package:flutter/foundation.dart';

class DepartmentProvider with ChangeNotifier {
  final DepartmentService _departmentService = DepartmentService();
  List<Department> _departments = [];

  List<Department> get departments => _departments;

  Future<void> fetchDepartments() async {
    try {
      _departments = await _departmentService.getDepartments();
      notifyListeners();
    } catch (e) {
      print('Error fetching departments: $e');
    }
  }

  Future<void> addDepartment(Department department) async {
    try {
      final newDepartment = await _departmentService.createDepartment(department);
      _departments.add(newDepartment);
      notifyListeners();
    } catch (e) {
      print('Error adding department: $e');
    }
  }

  Future<void> updateDepartment(Department department) async {
    try {
      final updatedDepartment = await _departmentService.updateDepartment(department);
      final index = _departments.indexWhere((d) => d.id == updatedDepartment.id);
      if (index != -1) {
        _departments[index] = updatedDepartment;
        notifyListeners();
      }
    } catch (e) {
      print('Error updating department: $e');
    }
  }

  Future<void> deleteDepartment(int id) async {
    try {
      await _departmentService.deleteDepartment(id);
      _departments.removeWhere((department) => department.id == id);
      notifyListeners();
    } catch (e) {
      print('Error deleting department: $e');
    }
  }
}