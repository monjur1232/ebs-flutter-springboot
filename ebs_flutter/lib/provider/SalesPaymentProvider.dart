import 'package:ebs/model/SalesPayment.dart';
import 'package:ebs/service/SalesPaymentService.dart';
import 'package:flutter/foundation.dart';

class SalesPaymentProvider with ChangeNotifier {
  final SalesPaymentService _salesPaymentService = SalesPaymentService();
  List<SalesPayment> _salesPayments = [];

  List<SalesPayment> get salesPayments => _salesPayments;

  Future<void> fetchSalesPayments() async {
    try {
      _salesPayments = await _salesPaymentService.getSalesPayments();
      notifyListeners();
    } catch (e) {
      print('Error fetching sales payments: $e');
    }
  }

  Future<void> addSalesPayment(SalesPayment salesPayment) async {
    try {
      final newSP = await _salesPaymentService.createSalesPayment(salesPayment);
      _salesPayments.add(newSP);
      notifyListeners();
    } catch (e) {
      print('Error adding sales payment: $e');
    }
  }

  Future<void> updateSalesPayment(SalesPayment salesPayment) async {
    try {
      final updatedSP = await _salesPaymentService.updateSalesPayment(salesPayment);
      final index = _salesPayments.indexWhere((t) => t.id == updatedSP.id);
      if (index != -1) {
        _salesPayments[index] = updatedSP;
        notifyListeners();
      }
    } catch (e) {
      print('Error updating sales payment: $e');
    }
  }

  Future<void> deleteSalesPayment(int id) async {
    try {
      await _salesPaymentService.deleteSalesPayment(id);
      _salesPayments.removeWhere((sp) => sp.id == id);
      notifyListeners();
    } catch (e) {
      print('Error deleting sales payment: $e');
    }
  }
}