import 'package:ebs/model/SalesOrder.dart';
import 'package:ebs/service/SalesOrderService.dart';
import 'package:flutter/foundation.dart';

class SalesOrderProvider with ChangeNotifier {
  final SalesOrderService _salesOrderService = SalesOrderService();
  List<SalesOrder> _salesOrders = [];

  List<SalesOrder> get salesOrders => _salesOrders;

  Future<void> fetchSalesOrders() async {
    try {
      _salesOrders = await _salesOrderService.getSalesOrders();
      notifyListeners();
    } catch (e) {
      print('Error fetching sales orders: $e');
    }
  }

  Future<void> addSalesOrder(SalesOrder salesOrder) async {
    try {
      final newSO = await _salesOrderService.createSalesOrder(salesOrder);
      _salesOrders.add(newSO);
      notifyListeners();
    } catch (e) {
      print('Error adding sales order: $e');
    }
  }

  Future<void> updateSalesOrder(SalesOrder salesOrder) async {
    try {
      final updatedSO = await _salesOrderService.updateSalesOrder(salesOrder);
      final index = _salesOrders.indexWhere((t) => t.id == updatedSO.id);
      if (index != -1) {
        _salesOrders[index] = updatedSO;
        notifyListeners();
      }
    } catch (e) {
      print('Error updating sales order: $e');
    }
  }

  Future<void> deleteSalesOrder(int id) async {
    try {
      await _salesOrderService.deleteSalesOrder(id);
      _salesOrders.removeWhere((so) => so.id == id);
      notifyListeners();
    } catch (e) {
      print('Error deleting sales order: $e');
    }
  }
}