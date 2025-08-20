class Product {
  final int? id;
  final int? productCode;
  final String? productName;
  final int? productCategoryCode;
  final String? productCategoryName;
  final String? description;
  final String? reorderLevel;
  final String? status;

  Product({
    this.id,
    this.productCode,
    this.productName,
    this.productCategoryCode,
    this.productCategoryName,
    this.description,
    this.reorderLevel,
    this.status,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      productCode: json['productCode'],
      productName: json['productName'],
      productCategoryCode: json['productCategoryCode'],
      productCategoryName: json['productCategoryName'],
      description: json['description'],
      reorderLevel: json['reorderLevel'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productCode': productCode,
      'productName': productName,
      'productCategoryCode': productCategoryCode,
      'productCategoryName': productCategoryName,
      'description': description,
      'reorderLevel': reorderLevel,
      'status': status,
    };
  }
}