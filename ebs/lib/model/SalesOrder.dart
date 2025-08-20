class SalesOrder {
  final int? id;
  final int? salesOrderCode;
  final int? customerCode;
  final String? customerName;
  final DateTime? orderDate;
  final DateTime? deliveryDate;
  final int? productCode;
  final String? productName;
  final double? unitPrice;
  final int? salesQuantity;
  final double? totalAmount;
  final String? paymentStatus;
  final String? status;

  SalesOrder({
    this.id,
    this.salesOrderCode,
    this.customerCode,
    this.customerName,
    this.orderDate,
    this.deliveryDate,
    this.productCode,
    this.productName,
    this.unitPrice,
    this.salesQuantity,
    this.totalAmount,
    this.paymentStatus,
    this.status,
  });

  factory SalesOrder.fromJson(Map<String, dynamic> json) {
    return SalesOrder(
      id: json['id'],
      salesOrderCode: json['salesOrderCode'],
      customerCode: json['customerCode'],
      customerName: json['customerName'],
      orderDate: json['orderDate'] != null ? DateTime.parse(json['orderDate']) : null,
      deliveryDate: json['deliveryDate'] != null ? DateTime.parse(json['deliveryDate']) : null,
      productCode: json['productCode'],
      productName: json['productName'],
      unitPrice: json['unitPrice'] != null ? (json['unitPrice'] as num).toDouble() : null,
      salesQuantity: json['salesQuantity'],
      totalAmount: json['totalAmount'] != null ? (json['totalAmount'] as num).toDouble() : null,
      paymentStatus: json['paymentStatus'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'salesOrderCode': salesOrderCode,
      'customerCode': customerCode,
      'customerName': customerName,
      'orderDate': orderDate?.toIso8601String(),
      'deliveryDate': deliveryDate?.toIso8601String(),
      'productCode': productCode,
      'productName': productName,
      'unitPrice': unitPrice,
      'salesQuantity': salesQuantity,
      'totalAmount': totalAmount,
      'paymentStatus': paymentStatus,
      'status': status,
    };
  }
}