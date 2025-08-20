import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ebs/model/Attendance.dart';
// import 'package:ebs/model/Employee.dart';
import 'package:ebs/provider/AttendanceProvider.dart';
import 'package:ebs/provider/EmployeeProvider.dart';
import 'package:intl/intl.dart';

class AttendancePage extends StatefulWidget {
  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  // final _formKey = GlobalKey<FormState>();
  final _bulkFormKey = GlobalKey<FormState>();
  final _updateFormKey = GlobalKey<FormState>();

  // For single attendance
  // final _attendanceCodeCtrl = TextEditingController();
  // final _employeeCodeCtrl = TextEditingController();
  // final _employeeNameCtrl = TextEditingController();
  // final _dateCtrl = TextEditingController();
  final _inTimeCtrl = TextEditingController();
  final _outTimeCtrl = TextEditingController();
  final _statusCtrl = TextEditingController();

  // For bulk attendance
  DateTime _bulkDate = DateTime.now();
  final _bulkAttendanceCodeCtrl = TextEditingController();
  Map<int, Map<String, String>> _employeeAttendanceMap = {};

  // For update
  Attendance? _selectedAttendance;
  final _updateAttendanceCodeCtrl = TextEditingController();
  final _updateEmployeeCodeCtrl = TextEditingController();
  final _updateEmployeeNameCtrl = TextEditingController();
  final _updateDateCtrl = TextEditingController();
  final _updateInTimeCtrl = TextEditingController();
  final _updateOutTimeCtrl = TextEditingController();
  final _updateStatusCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _inTimeCtrl.text = '09:00';
    _outTimeCtrl.text = '17:00';
    _statusCtrl.text = 'Present';
    
    Future.microtask(() {
      context.read<AttendanceProvider>().fetchAttendances();
      context.read<EmployeeProvider>().fetchEmployees().then((_) {
        _initializeEmployeeAttendanceMap();
      });
    });
  }

  void _initializeEmployeeAttendanceMap() {
    final employees = context.read<EmployeeProvider>().employees;
    setState(() {
      _employeeAttendanceMap = {
        for (var emp in employees)
          emp.employeeCode ?? 0: {
            'inTime': '09:00',
            'outTime': '17:00',
            'status': 'Present'
          }
      };
    });
  }

  void _markAllAsPresent() {
    setState(() {
      _employeeAttendanceMap = _employeeAttendanceMap.map((key, value) => 
        MapEntry(key, {'inTime': '09:00', 'outTime': '17:00', 'status': 'Present'}));
    });
  }

  void _markAllAsAbsent() {
    setState(() {
      _employeeAttendanceMap = _employeeAttendanceMap.map((key, value) => 
        MapEntry(key, {'inTime': '', 'outTime': '', 'status': 'Absent'}));
    });
  }

  void _resetAllTimes() {
    setState(() {
      _employeeAttendanceMap = _employeeAttendanceMap.map((key, value) {
        if (value['status'] != 'Absent') {
          return MapEntry(key, {'inTime': '09:00', 'outTime': '17:00', 'status': value['status']!});
        }
        return MapEntry(key, value);
      });
    });
  }

  void _clearEmployeeAttendance(int empCode) {
    setState(() {
      _employeeAttendanceMap[empCode] = {'inTime': '09:00', 'outTime': '17:00', 'status': 'Present'};
    });
  }

  void _setStatus(int empCode, String status) {
    setState(() {
      _employeeAttendanceMap[empCode]?['status'] = status;
      if (status == 'Absent') {
        _employeeAttendanceMap[empCode]?['inTime'] = '';
        _employeeAttendanceMap[empCode]?['outTime'] = '';
      } else {
        _employeeAttendanceMap[empCode]?['inTime'] = '09:00';
        _employeeAttendanceMap[empCode]?['outTime'] = '17:00';
      }
    });
  }

  Future<void> _saveBulkAttendance() async {
    final employees = context.read<EmployeeProvider>().employees;
    final attendances = employees.map((emp) {
      final attData = _employeeAttendanceMap[emp.employeeCode]!;
      return Attendance(
        attendanceCode: int.tryParse(_bulkAttendanceCodeCtrl.text),
        employeeCode: emp.employeeCode ?? 0,
        employeeName: '${emp.firstName} ${emp.lastName}',
        date: _bulkDate,
        inTime: attData['inTime'],
        outTime: attData['outTime'],
        status: attData['status'],
      );
    }).toList();

    try {
      await context.read<AttendanceProvider>().addBulkAttendance(attendances);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bulk attendance saved successfully!')),
      );
      _initializeEmployeeAttendanceMap();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save bulk attendance: $e')),
      );
    }
  }

  void _loadUpdateForm(Attendance att) {
    _selectedAttendance = att;
    _updateAttendanceCodeCtrl.text = att.attendanceCode?.toString() ?? '';
    _updateEmployeeCodeCtrl.text = att.employeeCode.toString();
    _updateEmployeeNameCtrl.text = att.employeeName ?? '';
    _updateDateCtrl.text = att.date?.toIso8601String().split('T')[0] ?? '';
    _updateInTimeCtrl.text = att.inTime ?? '';
    _updateOutTimeCtrl.text = att.outTime ?? '';
    _updateStatusCtrl.text = att.status ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final attendanceProvider = context.watch<AttendanceProvider>();
    final employeeProvider = context.watch<EmployeeProvider>();
    final filterDate = attendanceProvider.filterDate;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 240, 240),
      appBar: AppBar(
        title: Text("Attendance Management"),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bulk Attendance Section
            _sectionTitle("📝 Bulk Attendance Entry"),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _bulkFormKey,
                  child: Column(
                    children: [
                      Column(
                        children: [
                          _buildDatePickerField(
                            "Date", 
                            _bulkDate, 
                            (date) {
                              if (date != null) {
                                setState(() {
                                  _bulkDate = date;
                                });
                              }
                            }
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _markAllAsPresent,
                              child: Text("All as Present"),
                              style:ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(255, 16, 116, 19),
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _markAllAsAbsent,
                              child: Text("All as Absent"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(255, 178, 25, 25),
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _resetAllTimes,
                              child: Text("Reset All Times"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(255, 37, 21, 140),
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DataTable(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            headingRowColor: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) => const Color.fromARGB(255, 215, 236, 139),
                            ),
                            columns: [
                              DataColumn(
                                label: Text("Employee Code", style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(
                                label: Text("Employee Name", style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(
                                label: Text("In Time", style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(
                                label: Text("Out Time", style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(
                                label: Text("Status", style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(
                                label: Text("Action", style: TextStyle(fontWeight: FontWeight.bold))),
                            ],
                            rows: employeeProvider.employees.asMap().entries.map((entry) {
                              final index = entry.key;
                              final emp = entry.value;
                              final attData = _employeeAttendanceMap[emp.employeeCode] ?? 
                                  {'inTime': '', 'outTime': '', 'status': 'Present'};
                              
                              return DataRow(
                                color: MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) => index.isEven 
                                      ? Colors.grey.shade50 
                                      : Colors.white,
                                ),
                                cells: [
                                  DataCell(Text(emp.employeeCode?.toString() ?? '')),
                                  DataCell(Text("${emp.firstName} ${emp.lastName}")),
                                  DataCell(
                                    SizedBox(
                                      width: 100,
                                      child: TextFormField(
                                        controller: TextEditingController(text: attData['inTime']),
                                        enabled: attData['status'] != 'Absent',
                                        onChanged: (value) {
                                          _employeeAttendanceMap[emp.employeeCode]?['inTime'] = value;
                                        },
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          contentPadding: EdgeInsets.symmetric(horizontal: 8),
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    SizedBox(
                                      width: 100,
                                      child: TextFormField(
                                        controller: TextEditingController(text: attData['outTime']),
                                        enabled: attData['status'] != 'Absent',
                                        onChanged: (value) {
                                          _employeeAttendanceMap[emp.employeeCode]?['outTime'] = value;
                                        },
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          contentPadding: EdgeInsets.symmetric(horizontal: 8),
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Container(
                                      constraints: BoxConstraints(minWidth: 260), // নূন্যতম প্রস্থ নির্ধারণ
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            ChoiceChip(
                                              label: Text('Present'),
                                              selected: attData['status'] == 'Present',
                                              onSelected: (_) => _setStatus(emp.employeeCode ?? 0, 'Present'),
                                              selectedColor: Colors.green,
                                              labelPadding: EdgeInsets.symmetric(horizontal: 8), // লেবেল প্যাডিং কমিয়ে দিন
                                            ),
                                            SizedBox(width: 4),
                                            ChoiceChip(
                                              label: Text('Late'),
                                              selected: attData['status'] == 'Late',
                                              onSelected: (_) => _setStatus(emp.employeeCode ?? 0, 'Late'),
                                              selectedColor: Colors.orange,
                                              labelPadding: EdgeInsets.symmetric(horizontal: 8),
                                            ),
                                            SizedBox(width: 4),
                                            ChoiceChip(
                                              label: Text('Absent'),
                                              selected: attData['status'] == 'Absent',
                                              onSelected: (_) => _setStatus(emp.employeeCode ?? 0, 'Absent'),
                                              selectedColor: Colors.red,
                                              labelPadding: EdgeInsets.symmetric(horizontal: 8),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    IconButton(
                                      icon: Icon(Icons.clear, color: Colors.red),
                                      onPressed: () => _clearEmployeeAttendance(emp.employeeCode ?? 0),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _saveBulkAttendance,
                        child: Text("Save All Attendance"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 117, 6, 117),
                          foregroundColor: Colors.white,
                          minimumSize: Size(double.infinity, 50),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Attendance Records Section
            _sectionTitle("📋 Attendance Records"),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: "Search",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      attendanceProvider.setSearchText(value);
                    },
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildDatePickerField(
                    "Filter by Date",
                    filterDate.isNotEmpty ? DateTime.parse(filterDate) : null,
                    (date) {
                      attendanceProvider.setFilterDate(date?.toIso8601String().split('T')[0] ?? '');
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: attendanceProvider.filteredAttendances.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Center(child: Text("No attendance records found")),
                    )
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                          headingRowColor: MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              return const Color.fromARGB(255, 235, 182, 226);
                            },
                          ),
                        columns: [
                          DataColumn(label: Text("Employee Code")),
                          DataColumn(label: Text("Employee Name")),
                          DataColumn(label: Text("Date")),
                          DataColumn(label: Text("In Time")),
                          DataColumn(label: Text("Out Time")),
                          DataColumn(label: Text("Status")),
                          DataColumn(label: Text("Edit")),
                          DataColumn(label: Text("Delete")),
                        ],
                        rows: attendanceProvider.filteredAttendances.map((att) {
                          return DataRow(cells: [
                            DataCell(Text(att.employeeCode.toString())),
                            DataCell(Text(att.employeeName ?? '')),
                            DataCell(Text(att.date != null 
                                ? DateFormat('yyyy-MM-dd').format(att.date!) 
                                : '')),
                            DataCell(Text(att.inTime ?? '')),
                            DataCell(Text(att.outTime ?? '')),
                            DataCell(
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(att.status),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  att.status ?? '',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            DataCell(
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  setState(() {
                                    _loadUpdateForm(att);
                                  });
                                },
                              ),
                            ),
                            DataCell(
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  _deleteAttendance(att);
                                },
                              ),
                            ),
                          ]);
                        }).toList(),
                      ),
                    ),
            ),

            // Update Attendance Section
            if (_selectedAttendance != null) ...[
              SizedBox(height: 20),
              _sectionTitle("✏️ Update Attendance"),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _updateFormKey,
                    child: Column(
                      children: [
                        _buildField("Attendance Code", _updateAttendanceCodeCtrl, TextInputType.number),
                        _buildField("Employee Code", _updateEmployeeCodeCtrl, TextInputType.number),
                        _buildField("Employee Name", _updateEmployeeNameCtrl),
                        _buildDateField("Date", _updateDateCtrl),
                        _buildTimeField("In Time", _updateInTimeCtrl),
                        _buildTimeField("Out Time", _updateOutTimeCtrl),
                        DropdownButtonFormField<String>(
                          value: _updateStatusCtrl.text.isEmpty ? 'Present' : _updateStatusCtrl.text,
                          items: ['Present', 'Late', 'Absent']
                              .map((status) => DropdownMenuItem(
                                    value: status,
                                    child: Text(status),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            _updateStatusCtrl.text = value ?? 'Present';
                          },
                          decoration: InputDecoration(labelText: "Status"),
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _updateAttendance,
                                child: Text("Update"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  padding: EdgeInsets.symmetric(vertical: 14),
                                ),
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _selectedAttendance = null;
                                  });
                                },
                                child: Text("Cancel"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey,
                                  padding: EdgeInsets.symmetric(vertical: 14),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'Present':
        return Colors.green;
      case 'Late':
        return Colors.orange;
      case 'Absent':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Future<void> _deleteAttendance(Attendance att) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirm Delete"),
        content: Text("Are you sure you want to delete this attendance record?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await context.read<AttendanceProvider>().deleteAttendance(att.id!);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Attendance record deleted successfully!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete attendance record: $e')),
        );
      }
    }
  }

  Future<void> _updateAttendance() async {
    if (_selectedAttendance == null) return;

    final updatedAttendance = Attendance(
      id: _selectedAttendance!.id,
      attendanceCode: int.tryParse(_updateAttendanceCodeCtrl.text),
      employeeCode: int.tryParse(_updateEmployeeCodeCtrl.text) ?? 0,
      employeeName: _updateEmployeeNameCtrl.text,
      date: _updateDateCtrl.text.isNotEmpty 
          ? DateTime.tryParse(_updateDateCtrl.text) 
          : null,
      inTime: _updateInTimeCtrl.text,
      outTime: _updateOutTimeCtrl.text,
      status: _updateStatusCtrl.text,
    );

    try {
      await context.read<AttendanceProvider>().updateAttendance(updatedAttendance);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Attendance updated successfully!')),
      );
      setState(() {
        _selectedAttendance = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update attendance: $e')),
      );
    }
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        text,
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blueGrey[800]),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, [TextInputType type = TextInputType.text]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildDateField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey.shade100,
          suffixIcon: Icon(Icons.calendar_today),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
          );
          if (pickedDate != null) {
            controller.text = pickedDate.toIso8601String().split("T")[0];
          }
        },
      ),
    );
  }

  Widget _buildDatePickerField(String label, DateTime? initialDate, Function(DateTime?) onDateSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: initialDate ?? DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
          );
          onDateSelected(pickedDate);
        },
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            filled: true,
            fillColor: Colors.grey.shade100,
            suffixIcon: Icon(Icons.calendar_today),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            initialDate != null 
                ? DateFormat('yyyy-MM-dd').format(initialDate)
                : 'Select date',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey.shade100,
          suffixIcon: Icon(Icons.access_time),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onTap: () async {
          TimeOfDay? pickedTime = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
          );
          if (pickedTime != null) {
            controller.text = pickedTime.format(context);
          }
        },
      ),
    );
  }
}