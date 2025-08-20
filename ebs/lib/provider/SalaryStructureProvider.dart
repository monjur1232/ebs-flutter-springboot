import 'package:ebs/model/SalaryStructure.dart';
import 'package:ebs/service/SalaryStructureService.dart';
import 'package:flutter/foundation.dart';

class SalaryStructureProvider with ChangeNotifier {
  final SalaryStructureService _salaryStructureService = SalaryStructureService();
  List<SalaryStructure> _salaryStructures = [];

  List<SalaryStructure> get salaryStructures => _salaryStructures;

  Future<void> fetchSalaryStructures() async {
    try {
      _salaryStructures = await _salaryStructureService.getSalaryStructures();
      notifyListeners();
    } catch (e) {
      print('Error fetching salary structures: $e');
    }
  }

  Future<void> addSalaryStructure(SalaryStructure salaryStructure) async {
    try {
      final newSS = await _salaryStructureService.createSalaryStructure(salaryStructure);
      _salaryStructures.add(newSS);
      notifyListeners();
    } catch (e) {
      print('Error adding salary structure: $e');
    }
  }

  Future<void> updateSalaryStructure(SalaryStructure salaryStructure) async {
    try {
      final updatedSS = await _salaryStructureService.updateSalaryStructure(salaryStructure);
      final index = _salaryStructures.indexWhere((t) => t.id == updatedSS.id);
      if (index != -1) {
        _salaryStructures[index] = updatedSS;
        notifyListeners();
      }
    } catch (e) {
      print('Error updating salary structure: $e');
    }
  }

  Future<void> deleteSalaryStructure(int id) async {
    try {
      await _salaryStructureService.deleteSalaryStructure(id);
      _salaryStructures.removeWhere((ss) => ss.id == id);
      notifyListeners();
    } catch (e) {
      print('Error deleting salary structure: $e');
    }
  }
}