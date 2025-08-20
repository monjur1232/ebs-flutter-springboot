class Customer {
  final int? id;
  final int? customerCode;
  final String? customerName;
  final String? contactPerson;
  final String? phone;
  final String? email;
  final String? address;
  final int? taxId;
  final String? status;

  Customer({
    this.id,
    this.customerCode,
    this.customerName,
    this.contactPerson,
    this.phone,
    this.email,
    this.address,
    this.taxId,
    this.status,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      customerCode: json['customerCode'],
      customerName: json['customerName'],
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
      'customerCode': customerCode,
      'customerName': customerName,
      'contactPerson': contactPerson,
      'phone': phone,
      'email': email,
      'address': address,
      'taxId': taxId,
      'status': status,
    };
  }
}