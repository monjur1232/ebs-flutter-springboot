import 'package:ebs/model/Employee.dart';
import 'package:ebs/service/EmployeeService.dart';
import 'package:flutter/foundation.dart';

class EmployeeProvider with ChangeNotifier {
  final EmployeeService _employeeService = EmployeeService();
  List<Employee> _employees = [];

  List<Employee> get employees => _employees;

  Future<void> fetchEmployees() async {
    try {
      _employees = await _employeeService.getEmployees();
      notifyListeners();
    } catch (e) {
      print('Error fetching employees: $e');
    }
  }

  Future<void> addEmployee(Employee employee) async {
    try {
      final newEmployee = await _employeeService.createEmployee(employee);
      _employees.add(newEmployee);
      notifyListeners();
    } catch (e) {
      print('Error adding employee: $e');
    }
  }

  Future<void> updateEmployee(Employee employee) async {
    try {
      final updatedEmployee = await _employeeService.updateEmployee(employee);
      final index = _employees.indexWhere((t) => t.id == updatedEmployee.id);
      if (index != -1) {
        _employees[index] = updatedEmployee;
        notifyListeners();
      }
    } catch (e) {
      print('Error updating employee: $e');
    }
  }

  Future<void> deleteEmployee(int id) async {
    try {
      await _employeeService.deleteEmployee(id);
      _employees.removeWhere((employee) => employee.id == id);
      notifyListeners();
    } catch (e) {
      print('Error deleting employee: $e');
    }
  }
}