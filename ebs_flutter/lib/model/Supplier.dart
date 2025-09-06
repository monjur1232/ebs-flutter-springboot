class Supplier {
  final int? id;
  final int? supplierCode;
  final String? supplierName;
  final String? contactPerson;
  final String? phone;
  final String? email;
  final String? address;
  final int? taxId;
  final String? status;

  Supplier({
    this.id,
    this.supplierCode,
    this.supplierName,
    this.contactPerson,
    this.phone,
    this.email,
    this.address,
    this.taxId,
    this.status,
  });

  factory Supplier.fromJson(Map<String, dynamic> json) {
    return Supplier(
      id: json['id'],
      supplierCode: json['supplierCode'],
      supplierName: json['supplierName'],
      contactPerson: json['contactPerson'],
      phone: json['phone'],
      email: json['email'],
      address: json['address'],
      taxId: json['taxId'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'supplierCode': supplierCode,
      'supplierName': supplierName,
      'contactPerson': contactPerson,
      'phone': phone,
      'email': email,
      'address': address,
      'taxId': taxId,
      'status': status,
    };
  }
}