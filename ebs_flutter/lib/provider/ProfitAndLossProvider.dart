import 'package:ebs/model/PurchaseOrder.dart';
import 'package:ebs/model/SalesOrder.dart';
import 'package:flutter/foundation.dart';
import 'package:ebs/model/ProfitAndLoss.dart';
import 'package:ebs/service/ProfitAndLossService.dart';

class ProfitAndLossProvider with ChangeNotifier {
  final ProfitAndLossService _service = ProfitAndLossService();
  ProfitAndLossData? _profitAndLossData;
  String _purchaseSearchTerm = '';
  String _salesSearchTerm = '';

  ProfitAndLossData? get profitAndLossData => _profitAndLossData;
  String get purchaseSearchTerm => _purchaseSearchTerm;
  String get salesSearchTerm => _salesSearchTerm;

  List<PurchaseOrder> get filteredPurchases {
    if (_profitAndLossData == null) return [];
    if (_purchaseSearchTerm.isEmpty) return _profitAndLossData!.purchases;
    
    return _profitAndLossData!.purchases.where((p) {
      return p.productName?.toLowerCase().contains(_purchaseSearchTerm.toLowerCase()) == true ||
          p.supplierName?.toLowerCase().contains(_purchaseSearchTerm.toLowerCase()) == true ||
          p.unitPrice?.toString().contains(_purchaseSearchTerm) == true ||
          p.purchaseQuantity?.toString().contains(_purchaseSearchTerm) == true ||
          p.totalAmount?.toString().contains(_purchaseSearchTerm) == true;
    }).toList();
  }

  List<SalesOrder> get filteredSales {
    if (_profitAndLossData == null) return [];
    if (_salesSearchTerm.isEmpty) return _profitAndLossData!.sales;
    
    return _profitAndLossData!.sales.where((s) {
      return s.productName?.toLowerCase().contains(_salesSearchTerm.toLowerCase()) == true ||
          s.customerName?.toLowerCase().contains(_salesSearchTerm.toLowerCase()) == true ||
          s.unitPrice?.toString().contains(_salesSearchTerm) == true ||
          s.salesQuantity?.toString().contains(_salesSearchTerm) == true ||
          s.totalAmount?.toString().contains(_salesSearchTerm) == true;
    }).toList();
  }

  Future<void> fetchProfitAndLossData() async {
    try {
      _profitAndLossData = await _service.getProfitAndLossData();
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching profit and loss data: $e');
    }
  }

  void setPurchaseSearchTerm(String term) {
    _purchaseSearchTerm = term;
    notifyListeners();
  }

  void setSalesSearchTerm(String term) {
    _salesSearchTerm = term;
    notifyListeners();
  }
}