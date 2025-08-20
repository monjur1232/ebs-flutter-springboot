import 'package:ebs/model/Designation.dart';
import 'package:ebs/service/DesignationService.dart';
import 'package:flutter/foundation.dart';

class DesignationProvider with ChangeNotifier {
  final DesignationService _designationService = DesignationService();
  List<Designation> _designations = [];

  List<Designation> get designations => _designations;

  Future<void> fetchDesignations() async {
    try {
      _designations = await _designationService.getDesignations();
      notifyListeners();
    } catch (e) {
      print('Error fetching designations: $e');
    }
  }

  Future<void> addDesignation(Designation designation) async {
    try {
      final newDesignation = await _designationService.createDesignation(designation);
      _designations.add(newDesignation);
      notifyListeners();
    } catch (e) {
      print('Error adding designation: $e');
    }
  }

  Future<void> updateDesignation(Designation designation) async {
    try {
      final updatedDesignation = await _designationService.updateDesignation(designation);
      final index = _designations.indexWhere((d) => d.id == updatedDesignation.id);
      if (index != -1) {
        _designations[index] = updatedDesignation;
        notifyListeners();
      }
    } catch (e) {
      print('Error updating designation: $e');
    }
  }

  Future<void> deleteDesignation(int id) async {
    try {
      await _designationService.deleteDesignation(id);
      _designations.removeWhere((designation) => designation.id == id);
      notifyListeners();
    } catch (e) {
      print('Error deleting designation: $e');
    }
  }
}