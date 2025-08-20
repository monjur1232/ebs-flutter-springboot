import 'package:ebs/model/Employee.dart';
import 'package:ebs/provider/EmployeeProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmployeePage extends StatefulWidget {
  @override
  State<EmployeePage> createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
  final _addFormKey = GlobalKey<FormState>();
  final _updateFormKey = GlobalKey<FormState>();

  // Controllers for Add Form
  final codeCtrl = TextEditingController();
  final firstCtrl = TextEditingController();
  final lastCtrl = TextEditingController();
  final genderCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final dobCtrl = TextEditingController();
  final hireCtrl = TextEditingController();
  final salaryCtrl = TextEditingController();
  final deptCodeCtrl = TextEditingController();
  final deptNameCtrl = TextEditingController();
  final desigCodeCtrl = TextEditingController();
  final desigNameCtrl = TextEditingController();
  final statusCtrl = TextEditingController();

  // Update Form
  Employee? selectedEmployee;
  final uCodeCtrl = TextEditingController();
  final uFirstCtrl = TextEditingController();
  final uLastCtrl = TextEditingController();
  final uGenderCtrl = TextEditingController();
  final uPhoneCtrl = TextEditingController();
  final uEmailCtrl = TextEditingController();
  final uAddressCtrl = TextEditingController();
  final uDobCtrl = TextEditingController();
  final uHireCtrl = TextEditingController();
  final uSalaryCtrl = TextEditingController();
  final uDeptCodeCtrl = TextEditingController();
  final uDeptNameCtrl = TextEditingController();
  final uDesigCodeCtrl = TextEditingController();
  final uDesigNameCtrl = TextEditingController();
  final uStatusCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => context.read<EmployeeProvider>().fetchEmployees()); // Load data once
  }

  @override
  Widget build(BuildContext context) {
    final employeeProvider = context.watch<EmployeeProvider>();

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 240, 240),
      appBar: AppBar(
        title: Text("Employee Management"),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ---------------- Add Section ----------------
            _sectionTitle("➕  Add a New Employee"),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _addFormKey,
                  child: Column(
                    children: [
                      _buildField("Employee Code", codeCtrl, TextInputType.number),
                      _buildField("First Name", firstCtrl),
                      _buildField("Last Name", lastCtrl),
                      _buildField("Gender", genderCtrl),
                      _buildField("Phone", phoneCtrl, TextInputType.phone),
                      _buildField("Email", emailCtrl, TextInputType.emailAddress),
                      _buildField("Address", addressCtrl),
                      _buildDateField("Date of Birth (yyyy-mm-dd)", dobCtrl),
                      _buildDateField("Hire Date (yyyy-mm-dd)", hireCtrl),
                      _buildField("Salary", salaryCtrl,
                          TextInputType.numberWithOptions(decimal: true)),
                      _buildField("Department Code", deptCodeCtrl, TextInputType.number),
                      _buildField("Department Name", deptNameCtrl),
                      _buildField("Designation Code", desigCodeCtrl, TextInputType.number),
                      _buildField("Designation Name", desigNameCtrl),
                      _buildField("Status", statusCtrl),
                      SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity, // full width
                        child: ElevatedButton.icon(
                          icon: Icon(Icons.save, color: const Color.fromARGB(255, 255, 255, 255)),
                          label: Text(
                            "Save",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 2, 111, 9),
                            padding: EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () {
                            final emp = Employee(
                              employeeCode: int.tryParse(codeCtrl.text),
                              firstName: firstCtrl.text.isNotEmpty ? firstCtrl.text : null,
                              lastName: lastCtrl.text.isNotEmpty ? lastCtrl.text : null,
                              gender: genderCtrl.text.isNotEmpty ? genderCtrl.text : null,
                              phone: phoneCtrl.text.isNotEmpty ? phoneCtrl.text : null,
                              email: emailCtrl.text.isNotEmpty ? emailCtrl.text : null,
                              address:
                                  addressCtrl.text.isNotEmpty ? addressCtrl.text : null,
                              dateOfBirth: dobCtrl.text.isNotEmpty
                                  ? DateTime.tryParse(dobCtrl.text)
                                  : null,
                              hireDate: hireCtrl.text.isNotEmpty
                                  ? DateTime.tryParse(hireCtrl.text)
                                  : null,
                              salary: salaryCtrl.text.isNotEmpty
                                  ? double.tryParse(salaryCtrl.text)
                                  : null,
                              departmentCode: deptCodeCtrl.text.isNotEmpty
                                  ? int.tryParse(deptCodeCtrl.text)
                                  : null,
                              departmentName:
                                  deptNameCtrl.text.isNotEmpty ? deptNameCtrl.text : null,
                              designationCode: desigCodeCtrl.text.isNotEmpty
                                  ? int.tryParse(desigCodeCtrl.text)
                                  : null,
                              designationName:
                                  desigNameCtrl.text.isNotEmpty ? desigNameCtrl.text : null,
                              status: statusCtrl.text.isNotEmpty ? statusCtrl.text : null,
                            );
                            context.read<EmployeeProvider>().addEmployee(emp);
                            _clearAddForm();
                            setState(() {
                              selectedEmployee = null;
                            });                            
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),

            /// ---------------- Table Section ----------------
            _sectionTitle("📋  Employee List"),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: employeeProvider.employees.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Center(child: Text("No employees found")),
                    )
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        headingRowColor: MaterialStateProperty.all(
                            const Color.fromARGB(255, 203, 17, 17)),
                        columnSpacing: 12, // Reduced spacing
                        dividerThickness: 1,
                        border: TableBorder.all(color: const Color.fromARGB(255, 189, 189, 189), width: 1),
                        columns: const [
                          DataColumn(
                            label: Text("Employee Code", 
                                style: TextStyle(fontWeight: FontWeight.bold,
                                color: Colors.white)
                                ),
                          ),
                          DataColumn(
                            label: Text("Name",
                                style: TextStyle(fontWeight: FontWeight.bold,
                                color: Colors.white)
                                ),
                          ),
                          DataColumn(
                            label: Text("Gender",
                                style: TextStyle(fontWeight: FontWeight.bold,
                                color: Colors.white)
                                ),
                          ),
                          DataColumn(
                            label: Text("Phone",
                                style: TextStyle(fontWeight: FontWeight.bold,
                                color: Colors.white)
                                ),
                          ),
                          DataColumn(
                            label: Text("Email",
                                style: TextStyle(fontWeight: FontWeight.bold,
                                color: Colors.white)
                                ),
                          ),
                          DataColumn(
                            label: Text("Address",
                                style: TextStyle(fontWeight: FontWeight.bold,
                                color: Colors.white)
                                ),
                          ),
                          DataColumn(
                            label: Text("Date of Birth",
                                style: TextStyle(fontWeight: FontWeight.bold,
                                color: Colors.white)
                                ),
                          ),
                          DataColumn(
                            label: Text("Hire Date",
                                style: TextStyle(fontWeight: FontWeight.bold,
                                color: Colors.white)
                                ),
                          ),
                          DataColumn(
                            label: Text("Salary",
                                style: TextStyle(fontWeight: FontWeight.bold,
                                color: Colors.white)
                                ),
                          ),
                          DataColumn(
                            label: Text("Department Code",
                                style: TextStyle(fontWeight: FontWeight.bold,
                                color: Colors.white)
                                ),
                          ),
                          DataColumn(
                            label: Text("Department Name",
                                style: TextStyle(fontWeight: FontWeight.bold,
                                color: Colors.white)
                                ),
                          ),
                          DataColumn(
                            label: Text("Designation Code",
                                style: TextStyle(fontWeight: FontWeight.bold,
                                color: Colors.white)
                                ),
                          ),
                          DataColumn(
                            label: Text("Designation Name",
                                style: TextStyle(fontWeight: FontWeight.bold,
                                color: Colors.white)
                                ),
                          ),
                          DataColumn(
                            label: Text("Status",
                                style: TextStyle(fontWeight: FontWeight.bold,
                                color: Colors.white)
                                ),
                          ),
                          DataColumn(
                            label: Text("Edit",
                                style: TextStyle(fontWeight: FontWeight.bold,
                                color: Colors.white)
                                ),
                          ),
                          DataColumn(
                            label: Text("Delete",
                                style: TextStyle(fontWeight: FontWeight.bold,
                                color: Colors.white)
                                ),
                          ),
                        ],
                        rows: employeeProvider.employees.asMap().entries.map((entry) {
                          int index = entry.key;
                          Employee emp = entry.value;

                          return DataRow(
                            color: MaterialStateProperty.resolveWith<Color?>(
                              (Set<MaterialState> states) {
                                if (index % 2 == 0) {
                                  return const Color.fromARGB(255, 238, 236, 236);
                                }
                                return null;
                              },
                            ),
                            cells: [
                              DataCell(Text(emp.employeeCode?.toString() ?? '')),
                              DataCell(Text("${emp.firstName ?? ''} ${emp.lastName ?? ''}")),
                              DataCell(Text(emp.gender ?? '')),
                              DataCell(Text(emp.phone ?? '')),
                              DataCell(Text(emp.email ?? '')),
                              DataCell(Text(emp.address ?? '')),
                              DataCell(Text(emp.dateOfBirth?.toIso8601String().split('T')[0] ?? '')),
                              DataCell(Text(emp.hireDate?.toIso8601String().split('T')[0] ?? '')),
                              DataCell(Text(emp.salary?.toString() ?? '')),
                              DataCell(Text(emp.departmentCode?.toString() ?? '')),
                              DataCell(Text(emp.departmentName ?? '')),
                              DataCell(Text(emp.designationCode?.toString() ?? '')),
                              DataCell(Text(emp.designationName ?? '')),
                              DataCell(Text(emp.status ?? '')),
                              DataCell(
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                  tooltip: "Edit",
                                  onPressed: () {
                                    setState(() {
                                      selectedEmployee = emp;
                                      _loadUpdateForm(emp);
                                    });
                                  },
                                ),
                              ),
                              DataCell(
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  tooltip: "Delete",
                                  onPressed: () {
                                    context.read<EmployeeProvider>().deleteEmployee(emp.id!);
                                    setState(() {
                                      selectedEmployee = null;
                                    });                                    
                                  },
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
            ),

            /// ---------------- Update Section ----------------
            if (selectedEmployee != null) ...[
              SizedBox(height: 20),
              _sectionTitle("✏️  Update Employee"),
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
                        _buildField("Employee Code", uCodeCtrl, TextInputType.number),
                        _buildField("First Name", uFirstCtrl),
                        _buildField("Last Name", uLastCtrl),
                        _buildField("Gender", uGenderCtrl),
                        _buildField("Phone", uPhoneCtrl, TextInputType.phone),
                        _buildField("Email", uEmailCtrl, TextInputType.emailAddress),
                        _buildField("Address", uAddressCtrl),
                        _buildDateField("Date of Birth (yyyy-mm-dd)", uDobCtrl),
                        _buildDateField("Hire Date (yyyy-mm-dd)", uHireCtrl),
                        _buildField("Salary", uSalaryCtrl,
                            TextInputType.numberWithOptions(decimal: true)),
                        _buildField("Department Code", uDeptCodeCtrl, TextInputType.number),
                        _buildField("Department Name", uDeptNameCtrl),
                        _buildField("Designation Code", uDesigCodeCtrl, TextInputType.number),
                        _buildField("Designation Name", uDesigNameCtrl),
                        _buildField("Status", uStatusCtrl),
                        SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity, // full width
                          child: ElevatedButton.icon(
                            icon: Icon(Icons.update, color: const Color.fromARGB(255, 255, 255, 255)),
                            label: Text(
                              "Update",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 4, 8, 125),
                              padding: EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: () {
                              final emp = Employee(
                                id: selectedEmployee!.id,
                                employeeCode: int.tryParse(uCodeCtrl.text),
                                firstName: uFirstCtrl.text.isNotEmpty ? uFirstCtrl.text : null,
                                lastName: uLastCtrl.text.isNotEmpty ? uLastCtrl.text : null,
                                gender: uGenderCtrl.text.isNotEmpty ? uGenderCtrl.text : null,
                                phone: uPhoneCtrl.text.isNotEmpty ? uPhoneCtrl.text : null,
                                email: uEmailCtrl.text.isNotEmpty ? uEmailCtrl.text : null,
                                address: uAddressCtrl.text.isNotEmpty ? uAddressCtrl.text : null,
                                dateOfBirth: uDobCtrl.text.isNotEmpty ? DateTime.tryParse(uDobCtrl.text) : null,
                                hireDate: uHireCtrl.text.isNotEmpty ? DateTime.tryParse(uHireCtrl.text) : null,
                                salary: uSalaryCtrl.text.isNotEmpty ? double.tryParse(uSalaryCtrl.text) : null,
                                departmentCode: uDeptCodeCtrl.text.isNotEmpty ? int.tryParse(uDeptCodeCtrl.text) : null,
                                departmentName: uDeptNameCtrl.text.isNotEmpty ? uDeptNameCtrl.text : null,
                                designationCode: uDesigCodeCtrl.text.isNotEmpty ? int.tryParse(uDesigCodeCtrl.text) : null,
                                designationName: uDesigNameCtrl.text.isNotEmpty ? uDesigNameCtrl.text : null,
                                status: uStatusCtrl.text.isNotEmpty ? uStatusCtrl.text : null,
                              );
                              context.read<EmployeeProvider>().updateEmployee(emp);
                              setState(() {
                                selectedEmployee = null;
                              });
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  /// ---------------- Helpers ----------------
  Widget _buildField(String label, TextEditingController controller,
      [TextInputType type = TextInputType.text]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey.shade100,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueAccent, width: 2),
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
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueAccent, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(2100),
          );
          if (pickedDate != null) {
            controller.text = pickedDate.toIso8601String().split("T")[0];
          }
        },
      ),
    );
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

  void _clearAddForm() {
    codeCtrl.clear();
    firstCtrl.clear();
    lastCtrl.clear();
    genderCtrl.clear();
    phoneCtrl.clear();
    emailCtrl.clear();
    addressCtrl.clear();
    dobCtrl.clear();
    hireCtrl.clear();
    salaryCtrl.clear();
    deptCodeCtrl.clear();
    deptNameCtrl.clear();
    desigCodeCtrl.clear();
    desigNameCtrl.clear();
    statusCtrl.clear();
  }

  void _loadUpdateForm(Employee emp) {
    uCodeCtrl.text = emp.employeeCode?.toString() ?? '';
    uFirstCtrl.text = emp.firstName ?? '';
    uLastCtrl.text = emp.lastName ?? '';
    uGenderCtrl.text = emp.gender ?? '';
    uPhoneCtrl.text = emp.phone ?? '';
    uEmailCtrl.text = emp.email ?? '';
    uAddressCtrl.text = emp.address ?? '';
    uDobCtrl.text = emp.dateOfBirth?.toIso8601String().split("T")[0] ?? '';
    uHireCtrl.text = emp.hireDate?.toIso8601String().split("T")[0] ?? '';
    uSalaryCtrl.text = emp.salary?.toString() ?? '';
    uDeptCodeCtrl.text = emp.departmentCode?.toString() ?? '';
    uDeptNameCtrl.text = emp.departmentName ?? '';
    uDesigCodeCtrl.text = emp.designationCode?.toString() ?? '';
    uDesigNameCtrl.text = emp.designationName ?? '';
    uStatusCtrl.text = emp.status ?? '';
  }
}
