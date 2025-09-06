import 'dart:convert';
import 'package:ebs/model/PurchaseOrder.dart';
import 'package:ebs/model/SalesOrder.dart';
import 'package:http/http.dart' as http;
import 'package:ebs/model/ProfitAndLoss.dart';

class ProfitAndLossService {
  final String baseUrl = 'http://localhost:8080';

  Future<ProfitAndLossData> getProfitAndLossData() async {
    final purchaseResponse = await http.get(Uri.parse('$baseUrl/purchase-order'));
    final salesResponse = await http.get(Uri.parse('$baseUrl/sales-order'));

    if (purchaseResponse.statusCode == 200 && salesResponse.statusCode == 200) {
      final purchases = (json.decode(purchaseResponse.body) as List)
          .map((p) => PurchaseOrder.fromJson(p))
          .toList();
      final sales = (json.decode(salesResponse.body) as List)
          .map((s) => SalesOrder.fromJson(s))
          .toList();

      // Calculate summary data
      final totalPurchase = purchases.fold(
          0.0, (sum, p) => sum + (p.totalAmount ?? 0));
      final totalSales = sales.fold(
          0.0, (sum, s) => sum + (s.totalAmount ?? 0));
      final profitOrLoss = totalSales - totalPurchase;

      // Product-wise summary
      final productSummary = <String, ProductSummary>{};
      
      // Initialize product summary with all products from purchases
      for (final p in purchases) {
        final key = p.productName ?? 'Unknown';
        if (!productSummary.containsKey(key)) {
          productSummary[key] = ProductSummary(purchase: 0, sales: 0);
        }
        productSummary[key] = ProductSummary(
          purchase: (productSummary[key]?.purchase ?? 0) + (p.totalAmount ?? 0),
          sales: productSummary[key]?.sales ?? 0,
        );
      }
      
      // Add sales data to product summary
      for (final s in sales) {
        final key = s.productName ?? 'Unknown';
        if (!productSummary.containsKey(key)) {
          productSummary[key] = ProductSummary(purchase: 0, sales: 0);
        }
        productSummary[key] = ProductSummary(
          purchase: productSummary[key]?.purchase ?? 0,
          sales: (productSummary[key]?.sales ?? 0) + (s.totalAmount ?? 0),
        );
      }

      // Supplier-wise purchase
      final supplierWisePurchase = <String, double>{};
      for (final p in purchases) {
        final key = p.supplierName ?? p.supplierCode?.toString() ?? 'Unknown';
        supplierWisePurchase[key] =
            (supplierWisePurchase[key] ?? 0) + (p.totalAmount ?? 0);
      }

      // Customer-wise sales
      final customerWiseSales = <String, double>{};
      for (final s in sales) {
        final key = s.customerName ?? s.customerCode?.toString() ?? 'Unknown';
        customerWiseSales[key] =
            (customerWiseSales[key] ?? 0) + (s.totalAmount ?? 0);
      }

      // Count unique suppliers and customers
      final supplierCount = purchases
          .map((p) => p.supplierCode?.toString() ?? p.supplierName ?? '')
          .toSet()
          .length;
      final customerCount = sales
          .map((s) => s.customerCode?.toString() ?? s.customerName ?? '')
          .toSet()
          .length;

      return ProfitAndLossData(
        purchases: purchases,
        sales: sales,
        totalPurchase: totalPurchase,
        totalSales: totalSales,
        profitOrLoss: profitOrLoss,
        productSummary: productSummary,
        supplierWisePurchase: supplierWisePurchase,
        customerWiseSales: customerWiseSales,
        supplierCount: supplierCount,
        customerCount: customerCount,
      );
    } else {
      throw Exception('Failed to load profit and loss data');
    }
  }
}