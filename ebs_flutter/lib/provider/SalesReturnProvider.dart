import 'package:ebs/model/SalesReturn.dart';
import 'package:ebs/service/SalesReturnService.dart';
import 'package:flutter/foundation.dart';

class SalesReturnProvider with ChangeNotifier {
  final SalesReturnService _salesReturnService = SalesReturnService();
  List<SalesReturn> _salesReturns = [];

  List<SalesReturn> get salesReturns => _salesReturns;

  Future<void> fetchSalesReturns() async {
    try {
      _salesReturns = await _salesReturnService.getSalesReturns();
      notifyListeners();
    } catch (e) {
      print('Error fetching sales returns: $e');
    }
  }

  Future<void> addSalesReturn(SalesReturn salesReturn) async {
    try {
      final newSR = await _salesReturnService.createSalesReturn(salesReturn);
      _salesReturns.add(newSR);
      notifyListeners();
    } catch (e) {
      print('Error adding sales return: $e');
    }
  }

  Future<void> updateSalesReturn(SalesReturn salesReturn) async {
    try {
      final updatedSR = await _salesReturnService.updateSalesReturn(salesReturn);
      final index = _salesReturns.indexWhere((t) => t.id == updatedSR.id);
      if (index != -1) {
        _salesReturns[index] = updatedSR;
        notifyListeners();
      }
    } catch (e) {
      print('Error updating sales return: $e');
    }
  }

  Future<void> deleteSalesReturn(int id) async {
    try {
      await _salesReturnService.deleteSalesReturn(id);
      _salesReturns.removeWhere((sr) => sr.id == id);
      notifyListeners();
    } catch (e) {
      print('Error deleting sales return: $e');
    }
  }
}