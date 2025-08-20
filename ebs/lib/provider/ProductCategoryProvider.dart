import 'package:ebs/model/ProductCategory.dart';
import 'package:ebs/service/ProductCategoryService.dart';
import 'package:flutter/foundation.dart';

class ProductCategoryProvider with ChangeNotifier {
  final ProductCategoryService _productCategoryService = ProductCategoryService();
  List<ProductCategory> _productCategories = [];

  List<ProductCategory> get productCategories => _productCategories;

  Future<void> fetchProductCategories() async {
    try {
      _productCategories = await _productCategoryService.getProductCategories();
      notifyListeners();
    } catch (e) {
      print('Error fetching product categories: $e');
    }
  }

  Future<void> addProductCategory(ProductCategory category) async {
    try {
      final newCategory = await _productCategoryService.createProductCategory(category);
      _productCategories.add(newCategory);
      notifyListeners();
    } catch (e) {
      print('Error adding product category: $e');
    }
  }

  Future<void> updateProductCategory(ProductCategory category) async {
    try {
      final updatedCategory = await _productCategoryService.updateProductCategory(category);
      final index = _productCategories.indexWhere((c) => c.id == updatedCategory.id);
      if (index != -1) {
        _productCategories[index] = updatedCategory;
        notifyListeners();
      }
    } catch (e) {
      print('Error updating product category: $e');
    }
  }

  Future<void> deleteProductCategory(int id) async {
    try {
      await _productCategoryService.deleteProductCategory(id);
      _productCategories.removeWhere((category) => category.id == id);
      notifyListeners();
    } catch (e) {
      print('Error deleting product category: $e');
    }
  }
}