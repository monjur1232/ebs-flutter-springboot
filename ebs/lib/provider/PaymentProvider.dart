import 'package:ebs/model/Payment.dart';
import 'package:ebs/service/PaymentService.dart';
import 'package:flutter/foundation.dart';

class PaymentProvider with ChangeNotifier {
  final PaymentService _paymentService = PaymentService();
  List<Payment> _payments = [];

  List<Payment> get payments => _payments;

  Future<void> fetchPayments() async {
    try {
      _payments = await _paymentService.getPayments();
      notifyListeners();
    } catch (e) {
      print('Error fetching payments: $e');
    }
  }

  Future<void> addPayment(Payment payment) async {
    try {
      final newPayment = await _paymentService.createPayment(payment);
      _payments.add(newPayment);
      notifyListeners();
    } catch (e) {
      print('Error adding payment: $e');
    }
  }

  Future<void> updatePayment(Payment payment) async {
    try {
      final updatedPayment = await _paymentService.updatePayment(payment);
      final index = _payments.indexWhere((t) => t.id == updatedPayment.id);
      if (index != -1) {
        _payments[index] = updatedPayment;
        notifyListeners();
      }
    } catch (e) {
      print('Error updating payment: $e');
    }
  }

  Future<void> deletePayment(int id) async {
    try {
      await _paymentService.deletePayment(id);
      _payments.removeWhere((payment) => payment.id == id);
      notifyListeners();
    } catch (e) {
      print('Error deleting payment: $e');
    }
  }
}