import 'package:ebs/model/PurchaseOrder.dart';
import 'package:ebs/service/PurchaseOrderService.dart';
import 'package:flutter/foundation.dart';

class PurchaseOrderProvider with ChangeNotifier {
  final PurchaseOrderService _purchaseOrderService = PurchaseOrderService();
  List<PurchaseOrder> _purchaseOrders = [];

  List<PurchaseOrder> get purchaseOrders => _purchaseOrders;

  Future<void> fetchPurchaseOrders() async {
    try {
      _purchaseOrders = await _purchaseOrderService.getPurchaseOrders();
      notifyListeners();
    } catch (e) {
      print('Error fetching purchase orders: $e');
    }
  }

  Future<void> addPurchaseOrder(PurchaseOrder purchaseOrder) async {
    try {
      final newPO = await _purchaseOrderService.createPurchaseOrder(purchaseOrder);
      _purchaseOrders.add(newPO);
      notifyListeners();
    } catch (e) {
      print('Error adding purchase order: $e');
    }
  }

  Future<void> updatePurchaseOrder(PurchaseOrder purchaseOrder) async {
    try {
      final updatedPO = await _purchaseOrderService.updatePurchaseOrder(purchaseOrder);
      final index = _purchaseOrders.indexWhere((t) => t.id == updatedPO.id);
      if (index != -1) {
        _purchaseOrders[index] = updatedPO;
        notifyListeners();
      }
    } catch (e) {
      print('Error updating purchase order: $e');
    }
  }

  Future<void> deletePurchaseOrder(int id) async {
    try {
      await _purchaseOrderService.deletePurchaseOrder(id);
      _purchaseOrders.removeWhere((po) => po.id == id);
      notifyListeners();
    } catch (e) {
      print('Error deleting purchase order: $e');
    }
  }
}