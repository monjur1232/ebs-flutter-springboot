class Payment {
  final int? id;
  final int? paymentCode;
  final int? supplierCode;
  final String? supplierName;
  final int? purchaseOrderCode;
  final double? amountPaid;
  final DateTime? payDate;
  final String? paymentMode;
  final String? paymentRef;

  Payment({
    this.id,
    this.paymentCode,
    this.supplierCode,
    this.supplierName,
    this.purchaseOrderCode,
    this.amountPaid,
    this.payDate,
    this.paymentMode,
    this.paymentRef,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'],
      paymentCode: json['paymentCode'],
      supplierCode: json['supplierCode'],
      supplierName: json['supplierName'],
      purchaseOrderCode: json['purchaseOrderCode'],
      amountPaid: json['amountPaid'] != null ? (json['amountPaid'] as num).toDouble() : null,
      payDate: json['payDate'] != null ? DateTime.parse(json['payDate']) : null,
      paymentMode: json['paymentMode'],
      paymentRef: json['paymentRef'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'paymentCode': paymentCode,
      'supplierCode': supplierCode,
      'supplierName': supplierName,
      'purchaseOrderCode': purchaseOrderCode,
      'amountPaid': amountPaid,
      'payDate': payDate?.toIso8601String(),
      'paymentMode': paymentMode,
      'paymentRef': paymentRef,
    };
  }
}