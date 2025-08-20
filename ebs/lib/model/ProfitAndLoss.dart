import 'package:ebs/model/PurchaseOrder.dart';
import 'package:ebs/model/SalesOrder.dart';

class ProfitAndLossData {
  final List<PurchaseOrder> purchases;
  final List<SalesOrder> sales;
  final double totalPurchase;
  final double totalSales;
  final double profitOrLoss;
  final Map<String, ProductSummary> productSummary;
  final Map<String, double> supplierWisePurchase;
  final Map<String, double> customerWiseSales;
  final int supplierCount;
  final int customerCount;

  ProfitAndLossData({
    required this.purchases,
    required this.sales,
    required this.totalPurchase,
    required this.totalSales,
    required this.profitOrLoss,
    required this.productSummary,
    required this.supplierWisePurchase,
    required this.customerWiseSales,
    required this.supplierCount,
    required this.customerCount,
  });

  factory ProfitAndLossData.fromJson(Map<String, dynamic> json) {
    return ProfitAndLossData(
      purchases: (json['purchases'] as List)
          .map((p) => PurchaseOrder.fromJson(p))
          .toList(),
      sales: (json['sales'] as List).map((s) => SalesOrder.fromJson(s)).toList(),
      totalPurchase: (json['totalPurchase'] as num).toDouble(),
      totalSales: (json['totalSales'] as num).toDouble(),
      profitOrLoss: (json['profitOrLoss'] as num).toDouble(),
      productSummary: (json['productSummary'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(
          key,
          ProductSummary.fromJson(value),
        ),
      ),
      supplierWisePurchase: (json['supplierWisePurchase'] as Map<String, dynamic>)
          .map((key, value) => MapEntry(key, (value as num).toDouble())),
      customerWiseSales: (json['customerWiseSales'] as Map<String, dynamic>)
          .map((key, value) => MapEntry(key, (value as num).toDouble())),
      supplierCount: json['supplierCount'],
      customerCount: json['customerCount'],
    );
  }
}

class ProductSummary {
  final double purchase;
  final double sales;

  ProductSummary({required this.purchase, required this.sales});

  factory ProductSummary.fromJson(Map<String, dynamic> json) {
    return ProductSummary(
      purchase: (json['purchase'] as num).toDouble(),
      sales: (json['sales'] as num).toDouble(),
    );
  }
}