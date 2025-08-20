class ProductCategory {
  final int? id;
  final int? productCategoryCode;
  final String? productCategoryName;
  final String? description;

  ProductCategory({
    this.id,
    this.productCategoryCode,
    this.productCategoryName,
    this.description,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      id: json['id'],
      productCategoryCode: json['productCategoryCode'],
      productCategoryName: json['productCategoryName'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productCategoryCode': productCategoryCode,
      'productCategoryName': productCategoryName,
      'description': description,
    };
  }
}