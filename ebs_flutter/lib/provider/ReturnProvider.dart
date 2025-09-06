import 'package:ebs/model/Return.dart';
import 'package:ebs/service/ReturnService.dart';
import 'package:flutter/foundation.dart';

class ReturnProvider with ChangeNotifier {
  final ReturnService _returnService = ReturnService();
  List<Return> _returns = [];

  List<Return> get returns => _returns;

  Future<void> fetchReturns() async {
    try {
      _returns = await _returnService.getReturns();
      notifyListeners();
    } catch (e) {
      print('Error fetching returns: $e');
    }
  }

  Future<void> addReturn(Return returnData) async {
    try {
      final newReturn = await _returnService.createReturn(returnData);
      _returns.add(newReturn);
      notifyListeners();
    } catch (e) {
      print('Error adding return: $e');
    }
  }

  Future<void> updateReturn(Return returnData) async {
    try {
      final updatedReturn = await _returnService.updateReturn(returnData);
      final index = _returns.indexWhere((t) => t.id == updatedReturn.id);
      if (index != -1) {
        _returns[index] = updatedReturn;
        notifyListeners();
      }
    } catch (e) {
      print('Error updating return: $e');
    }
  }

  Future<void> deleteReturn(int id) async {
    try {
      await _returnService.deleteReturn(id);
      _returns.removeWhere((ret) => ret.id == id);
      notifyListeners();
    } catch (e) {
      print('Error deleting return: $e');
    }
  }
}