import 'package:flutter/foundation.dart';
import 'package:ebs/model/Inventory.dart';
import 'package:ebs/service/InventoryService.dart';

class InventoryProvider with ChangeNotifier {
  final InventoryService _inventoryService = InventoryService();
  List<Inventory> _inventories = [];

  List<Inventory> get inventories => _inventories;

  Future<void> fetchInventory() async {
    try {
      _inventories = await _inventoryService.getInventory();
      notifyListeners();
    } catch (e) {
      print('Error fetching inventory: $e');
    }
  }
}