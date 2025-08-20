import 'package:ebs/model/Customer.dart';
import 'package:ebs/service/CustomerService.dart';
import 'package:flutter/foundation.dart';

class CustomerProvider with ChangeNotifier {
  final CustomerService _customerService = CustomerService();
  List<Customer> _customers = [];

  List<Customer> get customers => _customers;

  Future<void> fetchCustomers() async {
    try {
      _customers = await _customerService.getCustomers();
      notifyListeners();
    } catch (e) {
      print('Error fetching customers: $e');
    }
  }

  Future<void> addCustomer(Customer customer) async {
    try {
      final newCustomer = await _customerService.createCustomer(customer);
      _customers.add(newCustomer);
      notifyListeners();
    } catch (e) {
      print('Error adding customer: $e');
    }
  }

  Future<void> updateCustomer(Customer customer) async {
    try {
      final updatedCustomer = await _customerService.updateCustomer(customer);
      final index = _customers.indexWhere((t) => t.id == updatedCustomer.id);
      if (index != -1) {
        _customers[index] = updatedCustomer;
        notifyListeners();
      }
    } catch (e) {
      print('Error updating customer: $e');
    }
  }

  Future<void> deleteCustomer(int id) async {
    try {
      await _customerService.deleteCustomer(id);
      _customers.removeWhere((customer) => customer.id == id);
      notifyListeners();
    } catch (e) {
      print('Error deleting customer: $e');
    }
  }
}