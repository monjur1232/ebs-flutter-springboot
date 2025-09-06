class SalesPayment {
  final int? id;
  final int? salesPaymentCode;
  final int? customerCode;
  final String? customerName;
  final int? salesOrderCode;
  final double? amountPaid;
  final DateTime? payDate;
  final String? paymentMode;
  final String? paymentRef;

  SalesPayment({
    this.id,
    this.salesPaymentCode,
    this.customerCode,
    this.customerName,
    this.salesOrderCode,
    this.amountPaid,
    this.payDate,
    this.paymentMode,
    this.paymentRef,
  });

  factory SalesPayment.fromJson(Map<String, dynamic> json) {
    return SalesPayment(
      id: json['id'],
      salesPaymentCode: json['salesPaymentCode'],
      customerCode: json['customerCode'],
      customerName: json['customerName'],
      salesOrderCode: json['salesOrderCode'],
      amountPaid: json['amountPaid'] != null ? (json['amountPaid'] as num).toDouble() : null,
      payDate: json['payDate'] != null ? DateTime.parse(json['payDate']) : null,
      paymentMode: json['paymentMode'],
      paymentRef: json['paymentRef'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'salesPaymentCode': salesPaymentCode,
      'customerCode': customerCode,
      'customerName': customerName,
      'salesOrderCode': salesOrderCode,
      'amountPaid': amountPaid,
      'payDate': payDate?.toIso8601String(),
      'paymentMode': paymentMode,
      'paymentRef': paymentRef,
    };
  }
}