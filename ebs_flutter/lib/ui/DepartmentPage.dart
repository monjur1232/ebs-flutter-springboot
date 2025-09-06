import 'package:ebs/model/Department.dart';
import 'package:ebs/provider/DepartmentProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DepartmentPage extends StatefulWidget {
  @override
  State<DepartmentPage> createState() => _DepartmentPageState();
}

class _DepartmentPageState extends State<DepartmentPage> {
  final _addFormKey = GlobalKey<FormState>();
  final _updateFormKey = GlobalKey<FormState>();

  // Controllers for Add Form
  final codeCtrl = TextEditingController();
  final nameCtrl = TextEditingController();

  // Update Form
  Department? selectedDepartment;
  final uCodeCtrl = TextEditingController();
  final uNameCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => context.read<DepartmentProvider>().fetchDepartments());
  }

  @override
  Widget build(BuildContext context) {
    final departmentProvider = context.watch<DepartmentProvider>();

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 240, 240),
      appBar: AppBar(
        title: Text("Department Management"),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ---------------- Add Section ----------------
            _sectionTitle("➕  Add a New Department"),
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
                      _buildField("Department Code", codeCtrl, TextInputType.number),
                      _buildField("Department Name", nameCtrl),
                      SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: Icon(Icons.save, color: Colors.white),
                          label: Text(
                            "Save",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 2, 111, 9),
                            padding: EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () {
                            final dept = Department(
                              departmentCode: int.tryParse(codeCtrl.text),
                              departmentName: nameCtrl.text.isNotEmpty ? nameCtrl.text : null,
                            );
                            context.read<DepartmentProvider>().addDepartment(dept);
                            _clearAddForm();
                            setState(() {
                              selectedDepartment = null;
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
            _sectionTitle("📋  Department List"),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: departmentProvider.departments.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Center(child: Text("No departments found")),
                    )
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        headingRowColor: MaterialStateProperty.all(
                            Color.fromARGB(255, 203, 17, 17)),
                        columnSpacing: 12,
                        dividerThickness: 1,
                        border: TableBorder.all(color: Color.fromARGB(255, 189, 189, 189), width: 1),
                        columns: const [
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
                        rows: departmentProvider.departments.asMap().entries.map((entry) {
                          int index = entry.key;
                          Department dept = entry.value;

                          return DataRow(
                            color: MaterialStateProperty.resolveWith<Color?>(
                              (Set<MaterialState> states) {
                                if (index % 2 == 0) {
                                  return Color.fromARGB(255, 238, 236, 236);
                                }
                                return null;
                              },
                            ),
                            cells: [
                              DataCell(Text(dept.departmentCode?.toString() ?? '')),
                              DataCell(Text(dept.departmentName ?? '')),
                              DataCell(
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                  tooltip: "Edit",
                                  onPressed: () {
                                    setState(() {
                                      selectedDepartment = dept;
                                      _loadUpdateForm(dept);
                                    });
                                  },
                                ),
                              ),
                              DataCell(
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  tooltip: "Delete",
                                  onPressed: () {
                                    context.read<DepartmentProvider>().deleteDepartment(dept.id!);
                                    setState(() {
                                      selectedDepartment = null;
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
            if (selectedDepartment != null) ...[
              SizedBox(height: 20),
              _sectionTitle("✏️  Update Department"),
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
                        _buildField("Department Code", uCodeCtrl, TextInputType.number),
                        _buildField("Department Name", uNameCtrl),
                        SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: Icon(Icons.update, color: Colors.white),
                            label: Text(
                              "Update",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 4, 8, 125),
                              padding: EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: () {
                              final dept = Department(
                                id: selectedDepartment!.id,
                                departmentCode: int.tryParse(uCodeCtrl.text),
                                departmentName: uNameCtrl.text.isNotEmpty ? uNameCtrl.text : null,
                              );
                              context.read<DepartmentProvider>().updateDepartment(dept);
                              setState(() {
                                selectedDepartment = null;
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
    nameCtrl.clear();
  }

  void _loadUpdateForm(Department dept) {
    uCodeCtrl.text = dept.departmentCode?.toString() ?? '';
    uNameCtrl.text = dept.departmentName ?? '';
  }
}