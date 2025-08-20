import 'package:ebs/model/Supplier.dart';
import 'package:ebs/service/SupplierService.dart';
import 'package:flutter/foundation.dart';

class SupplierProvider with ChangeNotifier {
  final SupplierService _supplierService = SupplierService();
  List<Supplier> _suppliers = [];

  List<Supplier> get suppliers => _suppliers;

  Future<void> fetchSuppliers() async {
    try {
      _suppliers = await _supplierService.getSuppliers();
      notifyListeners();
    } catch (e) {
      print('Error fetching suppliers: $e');
    }
  }

  Future<void> addSupplier(Supplier supplier) async {
    try {
      final newSupplier = await _supplierService.createSupplier(supplier);
      _suppliers.add(newSupplier);
      notifyListeners();
    } catch (e) {
      print('Error adding supplier: $e');
    }
  }

  Future<void> updateSupplier(Supplier supplier) async {
    try {
      final updatedSupplier = await _supplierService.updateSupplier(supplier);
      final index = _suppliers.indexWhere((t) => t.id == updatedSupplier.id);
      if (index != -1) {
        _suppliers[index] = updatedSupplier;
        notifyListeners();
      }
    } catch (e) {
      print('Error updating supplier: $e');
    }
  }

  Future<void> deleteSupplier(int id) async {
    try {
      await _supplierService.deleteSupplier(id);
      _suppliers.removeWhere((supplier) => supplier.id == id);
      notifyListeners();
    } catch (e) {
      print('Error deleting supplier: $e');
    }
  }
}