class Inventory {
  final int? id;
  final int? productCode;
  final String? productName;
  final int availableQuantity;
  final int purchasedQuantity;
  final int soldQuantity;
  final int returnedToSupplier;
  final int returnedFromCustomer;
  final String? reorderLevel;

  Inventory({
    this.id,
    this.productCode,
    this.productName,
    this.availableQuantity = 0,
    this.purchasedQuantity = 0,
    this.soldQuantity = 0,
    this.returnedToSupplier = 0,
    this.returnedFromCustomer = 0,
    this.reorderLevel,
  });

  // Copy with method to create a new instance with updated values
  Inventory copyWith({
    int? id,
    int? productCode,
    String? productName,
    int? availableQuantity,
    int? purchasedQuantity,
    int? soldQuantity,
    int? returnedToSupplier,
    int? returnedFromCustomer,
    String? reorderLevel,
  }) {
    return Inventory(
      id: id ?? this.id,
      productCode: productCode ?? this.productCode,
      productName: productName ?? this.productName,
      availableQuantity: availableQuantity ?? this.availableQuantity,
      purchasedQuantity: purchasedQuantity ?? this.purchasedQuantity,
      soldQuantity: soldQuantity ?? this.soldQuantity,
      returnedToSupplier: returnedToSupplier ?? this.returnedToSupplier,
      returnedFromCustomer: returnedFromCustomer ?? this.returnedFromCustomer,
      reorderLevel: reorderLevel ?? this.reorderLevel,
    );
  }

  factory Inventory.fromJson(Map<String, dynamic> json) {
    return Inventory(
      id: json['id'],
      productCode: json['productCode'],
      productName: json['productName'],
      availableQuantity: json['availableQuantity'] ?? 0,
      purchasedQuantity: json['purchasedQuantity'] ?? 0,
      soldQuantity: json['soldQuantity'] ?? 0,
      returnedToSupplier: json['returnedToSupplier'] ?? 0,
      returnedFromCustomer: json['returnedFromCustomer'] ?? 0,
      reorderLevel: json['reorderLevel'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productCode': productCode,
      'productName': productName,
      'availableQuantity': availableQuantity,
      'purchasedQuantity': purchasedQuantity,
      'soldQuantity': soldQuantity,
      'returnedToSupplier': returnedToSupplier,
      'returnedFromCustomer': returnedFromCustomer,
      'reorderLevel': reorderLevel,
    };
  }
}