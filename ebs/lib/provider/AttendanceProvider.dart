import 'package:flutter/foundation.dart';
import 'package:ebs/model/Attendance.dart';
import 'package:ebs/service/AttendanceService.dart';
import 'package:intl/intl.dart';

class AttendanceProvider with ChangeNotifier {
  final AttendanceService _attendanceService = AttendanceService();
  List<Attendance> _attendances = [];
  List<Attendance> _filteredAttendances = [];
  String _searchText = '';
  String _filterDate = '';

  List<Attendance> get attendances => _attendances;
  List<Attendance> get filteredAttendances => _filteredAttendances;
  String get filterDate => _filterDate; // Added getter for filterDate

  Future<void> fetchAttendances() async {
    try {
      _attendances = await _attendanceService.getAttendances();
      _filterAttendances();
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching attendances: $e');
      rethrow;
    }
  }

  Future<Attendance> addAttendance(Attendance attendance) async {
    try {
      final newAttendance = await _attendanceService.createAttendance(attendance);
      _attendances.add(newAttendance);
      _filterAttendances();
      notifyListeners();
      return newAttendance;
    } catch (e) {
      debugPrint('Error adding attendance: $e');
      rethrow;
    }
  }

  Future<List<Attendance>> addBulkAttendance(List<Attendance> attendances) async {
    try {
      final newAttendances = await _attendanceService.createBulkAttendance(attendances);
      _attendances.addAll(newAttendances);
      _filterAttendances();
      notifyListeners();
      return newAttendances;
    } catch (e) {
      debugPrint('Error adding bulk attendance: $e');
      rethrow;
    }
  }

  Future<Attendance> updateAttendance(Attendance attendance) async {
    try {
      final updatedAttendance = await _attendanceService.updateAttendance(attendance);
      final index = _attendances.indexWhere((a) => a.id == updatedAttendance.id);
      if (index != -1) {
        _attendances[index] = updatedAttendance;
        _filterAttendances();
        notifyListeners();
      }
      return updatedAttendance;
    } catch (e) {
      debugPrint('Error updating attendance: $e');
      rethrow;
    }
  }

  Future<void> deleteAttendance(int id) async {
    try {
      await _attendanceService.deleteAttendance(id);
      _attendances.removeWhere((attendance) => attendance.id == id);
      _filterAttendances();
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting attendance: $e');
      rethrow;
    }
  }

  void setSearchText(String text) {
    _searchText = text.trim();
    _filterAttendances();
    notifyListeners();
  }

  void setFilterDate(String date) {
    _filterDate = date.trim();
    _filterAttendances();
    notifyListeners();
  }

  void clearFilters() {
    _searchText = '';
    _filterDate = '';
    _filterAttendances();
    notifyListeners();
  }

  void _filterAttendances() {
    _filteredAttendances = _attendances.where((att) {
      // Search filter
      final matchesSearch = _searchText.isEmpty || 
          (att.employeeName?.toLowerCase().contains(_searchText.toLowerCase()) ?? false) ||
          att.employeeCode.toString().contains(_searchText) ||
          (att.attendanceCode?.toString().contains(_searchText) ?? false) ||
          (att.status?.toLowerCase().contains(_searchText.toLowerCase()) ?? false);
      
      // Date filter
      final matchesDate = _filterDate.isEmpty || 
          (att.date != null && 
           DateFormat('yyyy-MM-dd').format(att.date!) == _filterDate);
      
      return matchesSearch && matchesDate;
    }).toList();
  }
}