import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ebs/model/Inventory.dart';
import 'package:ebs/model/Product.dart';
import 'package:ebs/model/PurchaseOrder.dart';
import 'package:ebs/model/Return.dart';
import 'package:ebs/model/SalesOrder.dart';
import 'package:ebs/model/SalesReturn.dart';

class InventoryService {
  final String productUrl = 'http://localhost:8080/product';
  final String poUrl = 'http://localhost:8080/purchase-order';
  final String returnUrl = 'http://localhost:8080/return';
  final String soUrl = 'http://localhost:8080/sales-order';
  final String srUrl = 'http://localhost:8080/sales-return';

  Future<List<Inventory>> getInventory() async {
    try {
      final responses = await Future.wait([
        http.get(Uri.parse(productUrl)),
        http.get(Uri.parse(poUrl)),
        http.get(Uri.parse(returnUrl)),
        http.get(Uri.parse(soUrl)),
        http.get(Uri.parse(srUrl)),
      ]);

      final products = (jsonDecode(responses[0].body) as List)
          .map((p) => Product.fromJson(p))
          .toList();
      final purchaseOrders = (jsonDecode(responses[1].body) as List)
          .map((po) => PurchaseOrder.fromJson(po))
          .toList();
      final returns = (jsonDecode(responses[2].body) as List)
          .map((r) => Return.fromJson(r))
          .toList();
      final salesOrders = (jsonDecode(responses[3].body) as List)
          .map((so) => SalesOrder.fromJson(so))
          .toList();
      final salesReturns = (jsonDecode(responses[4].body) as List)
          .map((sr) => SalesReturn.fromJson(sr))
          .toList();

      return products.map((product) {
        // Calculate quantities
        final purchasedQty = purchaseOrders
            .where((po) => po.productCode == product.productCode)
            .fold(0, (sum, po) => sum + (po.purchaseQuantity ?? 0));

        final returnedToSupplierQty = returns
            .where((ret) => ret.productCode == product.productCode)
            .fold(0, (sum, ret) => sum + (ret.returnQuantity ?? 0));

        final soldQty = salesOrders
            .where((so) => so.productCode == product.productCode)
            .fold(0, (sum, so) => sum + (so.salesQuantity ?? 0));

        final returnedFromCustomerQty = salesReturns
            .where((sr) => sr.productCode == product.productCode)
            .fold(0, (sum, sr) => sum + (sr.returnQuantity ?? 0));

        // Calculate available quantity
        final availableQty = 
            (purchasedQty - returnedToSupplierQty) - 
            (soldQty - returnedFromCustomerQty);

        return Inventory(
          id: product.id,
          productCode: product.productCode,
          productName: product.productName,
          reorderLevel: product.reorderLevel,
          purchasedQuantity: purchasedQty,
          returnedToSupplier: returnedToSupplierQty,
          soldQuantity: soldQty,
          returnedFromCustomer: returnedFromCustomerQty,
          availableQuantity: availableQty,
        );
      }).toList();
    } catch (e) {
      print('Error fetching inventory: $e');
      throw Exception('Failed to load inventory');
    }
  }
}