class PurchaseOrder {
  final int? id;
  final int? purchaseOrderCode;
  final int? supplierCode;
  final String? supplierName;
  final DateTime? orderDate;
  final DateTime? receivedDate;
  final int? productCode;
  final String? productName;
  final double? unitPrice;
  final int? purchaseQuantity;
  final double? totalAmount;
  final String? paymentStatus;
  final String? status;

  PurchaseOrder({
    this.id,
    this.purchaseOrderCode,
    this.supplierCode,
    this.supplierName,
    this.orderDate,
    this.receivedDate,
    this.productCode,
    this.productName,
    this.unitPrice,
    this.purchaseQuantity,
    this.totalAmount,
    this.paymentStatus,
    this.status,
  });

  factory PurchaseOrder.fromJson(Map<String, dynamic> json) {
    return PurchaseOrder(
      id: json['id'],
      purchaseOrderCode: json['purchaseOrderCode'],
      supplierCode: json['supplierCode'],
      supplierName: json['supplierName'],
      orderDate: json['orderDate'] != null ? DateTime.parse(json['orderDate']) : null,
      receivedDate: json['receivedDate'] != null ? DateTime.parse(json['receivedDate']) : null,
      productCode: json['productCode'],
      productName: json['productName'],
      unitPrice: json['unitPrice'] != null ? (json['unitPrice'] as num).toDouble() : null,
      purchaseQuantity: json['purchaseQuantity'],
      totalAmount: json['totalAmount'] != null ? (json['totalAmount'] as num).toDouble() : null,
      paymentStatus: json['paymentStatus'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'purchaseOrderCode': purchaseOrderCode,
      'supplierCode': supplierCode,
      'supplierName': supplierName,
      'orderDate': orderDate?.toIso8601String(),
      'receivedDate': receivedDate?.toIso8601String(),
      'productCode': productCode,
      'productName': productName,
      'unitPrice': unitPrice,
      'purchaseQuantity': purchaseQuantity,
      'totalAmount': totalAmount,
      'paymentStatus': paymentStatus,
      'status': status,
    };
  }
}