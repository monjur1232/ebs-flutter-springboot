class SalesReturn {
  final int? id;
  final int? salesReturnCode;
  final int? salesOrderCode;
  final int? customerCode;
  final String? customerName;
  final int? productCode;
  final String? productName;
  final int? salesQuantity;
  final int? returnQuantity;
  final DateTime? returnDate;
  final String? reason;

  SalesReturn({
    this.id,
    this.salesReturnCode,
    this.salesOrderCode,
    this.customerCode,
    this.customerName,
    this.productCode,
    this.productName,
    this.salesQuantity,
    this.returnQuantity,
    this.returnDate,
    this.reason,
  });

  factory SalesReturn.fromJson(Map<String, dynamic> json) {
    return SalesReturn(
      id: json['id'],
      salesReturnCode: json['salesReturnCode'],
      salesOrderCode: json['salesOrderCode'],
      customerCode: json['customerCode'],
      customerName: json['customerName'],
      productCode: json['productCode'],
      productName: json['productName'],
      salesQuantity: json['salesQuantity'],
      returnQuantity: json['returnQuantity'],
      returnDate: json['returnDate'] != null ? DateTime.parse(json['returnDate']) : null,
      reason: json['reason'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'salesReturnCode': salesReturnCode,
      'salesOrderCode': salesOrderCode,
      'customerCode': customerCode,
      'customerName': customerName,
      'productCode': productCode,
      'productName': productName,
      'salesQuantity': salesQuantity,
      'returnQuantity': returnQuantity,
      'returnDate': returnDate?.toIso8601String(),
      'reason': reason,
    };
  }
}