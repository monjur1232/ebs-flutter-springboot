class Return {
  final int? id;
  final int? returnCode;
  final int? purchaseOrderCode;
  final int? supplierCode;
  final String? supplierName;
  final int? productCode;
  final String? productName;
  final int? purchaseQuantity;
  final int? returnQuantity;
  final DateTime? returnDate;
  final String? reason;

  Return({
    this.id,
    this.returnCode,
    this.purchaseOrderCode,
    this.supplierCode,
    this.supplierName,
    this.productCode,
    this.productName,
    this.purchaseQuantity,
    this.returnQuantity,
    this.returnDate,
    this.reason,
  });

  factory Return.fromJson(Map<String, dynamic> json) {
    return Return(
      id: json['id'],
      returnCode: json['returnCode'],
      purchaseOrderCode: json['purchaseOrderCode'],
      supplierCode: json['supplierCode'],
      supplierName: json['supplierName'],
      productCode: json['productCode'],
      productName: json['productName'],
      purchaseQuantity: json['purchaseQuantity'],
      returnQuantity: json['returnQuantity'],
      returnDate: json['returnDate'] != null ? DateTime.parse(json['returnDate']) : null,
      reason: json['reason'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'returnCode': returnCode,
      'purchaseOrderCode': purchaseOrderCode,
      'supplierCode': supplierCode,
      'supplierName': supplierName,
      'productCode': productCode,
      'productName': productName,
      'purchaseQuantity': purchaseQuantity,
      'returnQuantity': returnQuantity,
      'returnDate': returnDate?.toIso8601String(),
      'reason': reason,
    };
  }
}