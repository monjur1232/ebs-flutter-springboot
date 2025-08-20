import 'package:ebs/model/SalaryStructure.dart';
import 'package:ebs/provider/SalaryStructureProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SalaryStructurePage extends StatefulWidget {
  @override
  State<SalaryStructurePage> createState() => _SalaryStructurePageState();
}

class _SalaryStructurePageState extends State<SalaryStructurePage> {
  final _addFormKey = GlobalKey<FormState>();
  final _updateFormKey = GlobalKey<FormState>();

  // Controllers for Add Form
  final ssCodeCtrl = TextEditingController();
  final desigCodeCtrl = TextEditingController();
  final desigNameCtrl = TextEditingController();
  final basicCtrl = TextEditingController();
  final houseRentCtrl = TextEditingController();
  final medicalCtrl = TextEditingController();
  final transportCtrl = TextEditingController();
  final othersCtrl = TextEditingController();
  final grossCtrl = TextEditingController();

  // Update Form
  SalaryStructure? selectedSS;
  final uSsCodeCtrl = TextEditingController();
  final uDesigCodeCtrl = TextEditingController();
  final uDesigNameCtrl = TextEditingController();
  final uBasicCtrl = TextEditingController();
  final uHouseRentCtrl = TextEditingController();
  final uMedicalCtrl = TextEditingController();
  final uTransportCtrl = TextEditingController();
  final uOthersCtrl = TextEditingController();
  final uGrossCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<SalaryStructureProvider>().fetchSalaryStructures());
  }

  @override
  Widget build(BuildContext context) {
    final ssProvider = context.watch<SalaryStructureProvider>();

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 240, 240),
      appBar: AppBar(
        title: Text("Salary Structure Management"),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ---------------- Add Section ----------------
            _sectionTitle("➕  Add New Salary Structure"),
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
                      _buildField("Salary Structure Code", ssCodeCtrl, TextInputType.number),
                      _buildField("Designation Code", desigCodeCtrl, TextInputType.number),
                      _buildField("Designation Name", desigNameCtrl),
                      _buildField("Basic Salary", basicCtrl, 
                          TextInputType.numberWithOptions(decimal: true)),
                      _buildField("House Rent", houseRentCtrl, 
                          TextInputType.numberWithOptions(decimal: true)),
                      _buildField("Medical Allowance", medicalCtrl, 
                          TextInputType.numberWithOptions(decimal: true)),
                      _buildField("Transport Allowance", transportCtrl, 
                          TextInputType.numberWithOptions(decimal: true)),
                      _buildField("Others", othersCtrl, 
                          TextInputType.numberWithOptions(decimal: true)),
                      _buildField("Gross Salary", grossCtrl, 
                          TextInputType.numberWithOptions(decimal: true)),
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
                            final salaryStructure = SalaryStructure(
                              salaryStructureCode: int.tryParse(ssCodeCtrl.text),
                              designationCode: int.tryParse(desigCodeCtrl.text),
                              designationName: desigNameCtrl.text.isNotEmpty ? desigNameCtrl.text : null,
                              basicSalary: basicCtrl.text.isNotEmpty ? double.tryParse(basicCtrl.text) : null,
                              houseRent: houseRentCtrl.text.isNotEmpty ? double.tryParse(houseRentCtrl.text) : null,
                              medicalAllowance: medicalCtrl.text.isNotEmpty ? double.tryParse(medicalCtrl.text) : null,
                              transportAllowance: transportCtrl.text.isNotEmpty ? double.tryParse(transportCtrl.text) : null,
                              others: othersCtrl.text.isNotEmpty ? double.tryParse(othersCtrl.text) : null,
                              grossSalary: grossCtrl.text.isNotEmpty ? double.tryParse(grossCtrl.text) : null,
                            );
                            ssProvider.addSalaryStructure(salaryStructure);
                            _clearAddForm();
                            setState(() {
                              selectedSS = null;
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
            _sectionTitle("📋  Salary Structure List"),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: ssProvider.salaryStructures.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Center(child: Text("No salary structures found")),
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
                            label: Text("Salary Structure Code", 
                                style: TextStyle(fontWeight: FontWeight.bold,
                                color: Colors.white)),
                          ),
                          DataColumn(
                            label: Text("Designation Code", 
                                style: TextStyle(fontWeight: FontWeight.bold,
                                color: Colors.white)),
                          ),
                          DataColumn(
                            label: Text("Designation Name", 
                                style: TextStyle(fontWeight: FontWeight.bold,
                                color: Colors.white)),
                          ),
                          DataColumn(
                            label: Text("Basic Salary", 
                                style: TextStyle(fontWeight: FontWeight.bold,
                                color: Colors.white)),
                          ),
                          DataColumn(
                            label: Text("House Rent", 
                                style: TextStyle(fontWeight: FontWeight.bold,
                                color: Colors.white)),
                          ),
                          DataColumn(
                            label: Text("Medical Allowance", 
                                style: TextStyle(fontWeight: FontWeight.bold,
                                color: Colors.white)),
                          ),
                          DataColumn(
                            label: Text("Transport Allowance", 
                                style: TextStyle(fontWeight: FontWeight.bold,
                                color: Colors.white)),
                          ),
                          DataColumn(
                            label: Text("Others", 
                                style: TextStyle(fontWeight: FontWeight.bold,
                                color: Colors.white)),
                          ),
                          DataColumn(
                            label: Text("Gross Salary", 
                                style: TextStyle(fontWeight: FontWeight.bold,
                                color: Colors.white)),
                          ),
                          DataColumn(
                            label: Text("Edit", 
                                style: TextStyle(fontWeight: FontWeight.bold,
                                color: Colors.white)),
                          ),
                          DataColumn(
                            label: Text("Delete", 
                                style: TextStyle(fontWeight: FontWeight.bold,
                                color: Colors.white)),
                          ),
                        ],
                        rows: ssProvider.salaryStructures.asMap().entries.map((entry) {
                          int index = entry.key;
                          SalaryStructure ss = entry.value;

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
                              DataCell(Text(ss.salaryStructureCode?.toString() ?? '')),
                              DataCell(Text(ss.designationCode?.toString() ?? '')),
                              DataCell(Text(ss.designationName ?? '')),
                              DataCell(Text(ss.basicSalary?.toStringAsFixed(2) ?? '')),
                              DataCell(Text(ss.houseRent?.toStringAsFixed(2) ?? '')),
                              DataCell(Text(ss.medicalAllowance?.toStringAsFixed(2) ?? '')),
                              DataCell(Text(ss.transportAllowance?.toStringAsFixed(2) ?? '')),
                              DataCell(Text(ss.others?.toStringAsFixed(2) ?? '')),
                              DataCell(Text(ss.grossSalary?.toStringAsFixed(2) ?? '')),
                              DataCell(
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () {
                                    setState(() {
                                      selectedSS = ss;
                                      _loadUpdateForm(ss);
                                    });
                                  },
                                ),
                              ),
                              DataCell(
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    ssProvider.deleteSalaryStructure(ss.id!);
                                    setState(() {
                                      selectedSS = null;
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
            if (selectedSS != null) ...[
              SizedBox(height: 20),
              _sectionTitle("✏️  Update Salary Structure"),
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
                        _buildField("Salary Structure Code", uSsCodeCtrl, TextInputType.number),
                        _buildField("Designation Code", uDesigCodeCtrl, TextInputType.number),
                        _buildField("Designation Name", uDesigNameCtrl),
                        _buildField("Basic Salary", uBasicCtrl, 
                            TextInputType.numberWithOptions(decimal: true)),
                        _buildField("House Rent", uHouseRentCtrl, 
                            TextInputType.numberWithOptions(decimal: true)),
                        _buildField("Medical Allowance", uMedicalCtrl, 
                            TextInputType.numberWithOptions(decimal: true)),
                        _buildField("Transport Allowance", uTransportCtrl, 
                            TextInputType.numberWithOptions(decimal: true)),
                        _buildField("Others", uOthersCtrl, 
                            TextInputType.numberWithOptions(decimal: true)),
                        _buildField("Gross Salary", uGrossCtrl, 
                            TextInputType.numberWithOptions(decimal: true)),
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
                              final salaryStructure = SalaryStructure(
                                id: selectedSS!.id,
                                salaryStructureCode: int.tryParse(uSsCodeCtrl.text),
                                designationCode: int.tryParse(uDesigCodeCtrl.text),
                                designationName: uDesigNameCtrl.text.isNotEmpty ? uDesigNameCtrl.text : null,
                                basicSalary: uBasicCtrl.text.isNotEmpty ? double.tryParse(uBasicCtrl.text) : null,
                                houseRent: uHouseRentCtrl.text.isNotEmpty ? double.tryParse(uHouseRentCtrl.text) : null,
                                medicalAllowance: uMedicalCtrl.text.isNotEmpty ? double.tryParse(uMedicalCtrl.text) : null,
                                transportAllowance: uTransportCtrl.text.isNotEmpty ? double.tryParse(uTransportCtrl.text) : null,
                                others: uOthersCtrl.text.isNotEmpty ? double.tryParse(uOthersCtrl.text) : null,
                                grossSalary: uGrossCtrl.text.isNotEmpty ? double.tryParse(uGrossCtrl.text) : null,
                              );
                              ssProvider.updateSalaryStructure(salaryStructure);
                              setState(() {
                                selectedSS = null;
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
    ssCodeCtrl.clear();
    desigCodeCtrl.clear();
    desigNameCtrl.clear();
    basicCtrl.clear();
    houseRentCtrl.clear();
    medicalCtrl.clear();
    transportCtrl.clear();
    othersCtrl.clear();
    grossCtrl.clear();
  }

  void _loadUpdateForm(SalaryStructure ss) {
    uSsCodeCtrl.text = ss.salaryStructureCode?.toString() ?? '';
    uDesigCodeCtrl.text = ss.designationCode?.toString() ?? '';
    uDesigNameCtrl.text = ss.designationName ?? '';
    uBasicCtrl.text = ss.basicSalary?.toString() ?? '';
    uHouseRentCtrl.text = ss.houseRent?.toString() ?? '';
    uMedicalCtrl.text = ss.medicalAllowance?.toString() ?? '';
    uTransportCtrl.text = ss.transportAllowance?.toString() ?? '';
    uOthersCtrl.text = ss.others?.toString() ?? '';
    uGrossCtrl.text = ss.grossSalary?.toString() ?? '';
  }
}