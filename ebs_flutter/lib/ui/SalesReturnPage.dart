import 'package:ebs/model/SalesReturn.dart';
import 'package:ebs/provider/SalesReturnProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SalesReturnPage extends StatefulWidget {
  @override
  State<SalesReturnPage> createState() => _SalesReturnPageState();
}

class _SalesReturnPageState extends State<SalesReturnPage> {
  final _addFormKey = GlobalKey<FormState>();
  final _updateFormKey = GlobalKey<FormState>();

  // Controllers for Add Form
  final srCodeCtrl = TextEditingController();
  final soCodeCtrl = TextEditingController();
  final customerCodeCtrl = TextEditingController();
  final customerNameCtrl = TextEditingController();
  final productCodeCtrl = TextEditingController();
  final productNameCtrl = TextEditingController();
  final salesQtyCtrl = TextEditingController();
  final returnQtyCtrl = TextEditingController();
  final returnDateCtrl = TextEditingController();
  final reasonCtrl = TextEditingController();

  // Update Form
  SalesReturn? selectedSR;
  final uSrCodeCtrl = TextEditingController();
  final uSoCodeCtrl = TextEditingController();
  final uCustomerCodeCtrl = TextEditingController();
  final uCustomerNameCtrl = TextEditingController();
  final uProductCodeCtrl = TextEditingController();
  final uProductNameCtrl = TextEditingController();
  final uSalesQtyCtrl = TextEditingController();
  final uReturnQtyCtrl = TextEditingController();
  final uReturnDateCtrl = TextEditingController();
  final uReasonCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<SalesReturnProvider>().fetchSalesReturns());
  }

  @override
  Widget build(BuildContext context) {
    final srProvider = context.watch<SalesReturnProvider>();

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 240, 240),
      appBar: AppBar(
        title: Text("Sales Return Management"),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ---------------- Add Section ----------------
            _sectionTitle("➕  Add New Sales Return"),
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
                      _buildField("Sales Return Code", srCodeCtrl, TextInputType.number),
                      _buildField("Sales Order Code", soCodeCtrl, TextInputType.number),
                      _buildField("Customer Code", customerCodeCtrl, TextInputType.number),
                      _buildField("Customer Name", customerNameCtrl),
                      _buildField("Product Code", productCodeCtrl, TextInputType.number),
                      _buildField("Product Name", productNameCtrl),
                      _buildField("Sales Quantity", salesQtyCtrl, TextInputType.number),
                      _buildField("Return Quantity", returnQtyCtrl, TextInputType.number),
                      _buildDateField("Return Date (yyyy-mm-dd)", returnDateCtrl),
                      _buildField("Reason", reasonCtrl),
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
                            final sr = SalesReturn(
                              salesReturnCode: int.tryParse(srCodeCtrl.text),
                              salesOrderCode: int.tryParse(soCodeCtrl.text),
                              customerCode: int.tryParse(customerCodeCtrl.text),
                              customerName: customerNameCtrl.text.isNotEmpty ? customerNameCtrl.text : null,
                              productCode: int.tryParse(productCodeCtrl.text),
                              productName: productNameCtrl.text.isNotEmpty ? productNameCtrl.text : null,
                              salesQuantity: salesQtyCtrl.text.isNotEmpty ? int.tryParse(salesQtyCtrl.text) : null,
                              returnQuantity: returnQtyCtrl.text.isNotEmpty ? int.tryParse(returnQtyCtrl.text) : null,
                              returnDate: returnDateCtrl.text.isNotEmpty ? DateTime.parse(returnDateCtrl.text) : null,
                              reason: reasonCtrl.text.isNotEmpty ? reasonCtrl.text : null,
                            );
                            context.read<SalesReturnProvider>().addSalesReturn(sr);
                            _clearAddForm();
                            setState(() {
                              selectedSR = null;
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
            _sectionTitle("📋  Sales Return List"),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: srProvider.salesReturns.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Center(child: Text("No sales returns found")),
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
                          // DataColumn(
                          //   label: Text("Sales Return Code", 
                          //       style: TextStyle(fontWeight: FontWeight.bold,
                          //       color: Colors.white)),
                          // ),
                          DataColumn(
                            label: Text("Sales Order Code", 
                                style: TextStyle(fontWeight: FontWeight.bold,
                                color: Colors.white)),
                          ),
                          DataColumn(
                            label: Text("Customer Code", 
                                style: TextStyle(fontWeight: FontWeight.bold,
                                color: Colors.white)),
                          ),
                          DataColumn(
                            label: Text("Customer Name", 
                                style: TextStyle(fontWeight: FontWeight.bold,
                                color: Colors.white)),
                          ),
                          DataColumn(
                            label: Text("Product Code", 
                                style: TextStyle(fontWeight: FontWeight.bold,
                                color: Colors.white)),
                          ),
                          DataColumn(
                            label: Text("Product Name", 
                                style: TextStyle(fontWeight: FontWeight.bold,
                                color: Colors.white)),
                          ),
                          DataColumn(
                            label: Text("Sales Quantity", 
                                style: TextStyle(fontWeight: FontWeight.bold,
                                color: Colors.white)),
                          ),
                          DataColumn(
                            label: Text("Return Quantity", 
                                style: TextStyle(fontWeight: FontWeight.bold,
                                color: Colors.white)),
                          ),
                          DataColumn(
                            label: Text("Return Date", 
                                style: TextStyle(fontWeight: FontWeight.bold,
                                color: Colors.white)),
                          ),
                          DataColumn(
                            label: Text("Reason", 
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
                        rows: srProvider.salesReturns.asMap().entries.map((entry) {
                          int index = entry.key;
                          SalesReturn sr = entry.value;

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
                              // DataCell(Text(sr.salesReturnCode?.toString() ?? '')),
                              DataCell(Text(sr.salesOrderCode?.toString() ?? '')),
                              DataCell(Text(sr.customerCode?.toString() ?? '')),
                              DataCell(Text(sr.customerName ?? '')),
                              DataCell(Text(sr.productCode?.toString() ?? '')),
                              DataCell(Text(sr.productName ?? '')),
                              DataCell(Text(sr.salesQuantity?.toString() ?? '')),
                              DataCell(Text(sr.returnQuantity?.toString() ?? '')),
                              DataCell(Text(sr.returnDate?.toIso8601String().split('T')[0] ?? '')),
                              DataCell(Text(sr.reason ?? '')),
                              DataCell(
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () {
                                    setState(() {
                                      selectedSR = sr;
                                      _loadUpdateForm(sr);
                                    });
                                  },
                                ),
                              ),
                              DataCell(
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    srProvider.deleteSalesReturn(sr.id!);
                                    setState(() {
                                      selectedSR = null;
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
            if (selectedSR != null) ...[
              SizedBox(height: 20),
              _sectionTitle("✏️  Update Sales Return"),
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
                        _buildField("Sales Return Code", uSrCodeCtrl, TextInputType.number),
                        _buildField("Sales Order Code", uSoCodeCtrl, TextInputType.number),
                        _buildField("Customer Code", uCustomerCodeCtrl, TextInputType.number),
                        _buildField("Customer Name", uCustomerNameCtrl),
                        _buildField("Product Code", uProductCodeCtrl, TextInputType.number),
                        _buildField("Product Name", uProductNameCtrl),
                        _buildField("Sales Quantity", uSalesQtyCtrl, TextInputType.number),
                        _buildField("Return Quantity", uReturnQtyCtrl, TextInputType.number),
                        _buildDateField("Return Date (yyyy-mm-dd)", uReturnDateCtrl),
                        _buildField("Reason", uReasonCtrl),
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
                              final sr = SalesReturn(
                                id: selectedSR!.id,
                                salesReturnCode: int.tryParse(uSrCodeCtrl.text),
                                salesOrderCode: int.tryParse(uSoCodeCtrl.text),
                                customerCode: int.tryParse(uCustomerCodeCtrl.text),
                                customerName: uCustomerNameCtrl.text.isNotEmpty ? uCustomerNameCtrl.text : null,
                                productCode: int.tryParse(uProductCodeCtrl.text),
                                productName: uProductNameCtrl.text.isNotEmpty ? uProductNameCtrl.text : null,
                                salesQuantity: uSalesQtyCtrl.text.isNotEmpty ? int.tryParse(uSalesQtyCtrl.text) : null,
                                returnQuantity: uReturnQtyCtrl.text.isNotEmpty ? int.tryParse(uReturnQtyCtrl.text) : null,
                                returnDate: uReturnDateCtrl.text.isNotEmpty ? DateTime.parse(uReturnDateCtrl.text) : null,
                                reason: uReasonCtrl.text.isNotEmpty ? uReasonCtrl.text : null,
                              );
                              srProvider.updateSalesReturn(sr);
                              setState(() {
                                selectedSR = null;
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
    srCodeCtrl.clear();
    soCodeCtrl.clear();
    customerCodeCtrl.clear();
    customerNameCtrl.clear();
    productCodeCtrl.clear();
    productNameCtrl.clear();
    salesQtyCtrl.clear();
    returnQtyCtrl.clear();
    returnDateCtrl.clear();
    reasonCtrl.clear();
  }

  void _loadUpdateForm(SalesReturn sr) {
    uSrCodeCtrl.text = sr.salesReturnCode?.toString() ?? '';
    uSoCodeCtrl.text = sr.salesOrderCode?.toString() ?? '';
    uCustomerCodeCtrl.text = sr.customerCode?.toString() ?? '';
    uCustomerNameCtrl.text = sr.customerName ?? '';
    uProductCodeCtrl.text = sr.productCode?.toString() ?? '';
    uProductNameCtrl.text = sr.productName ?? '';
    uSalesQtyCtrl.text = sr.salesQuantity?.toString() ?? '';
    uReturnQtyCtrl.text = sr.returnQuantity?.toString() ?? '';
    uReturnDateCtrl.text = sr.returnDate?.toIso8601String().split('T')[0] ?? '';
    uReasonCtrl.text = sr.reason ?? '';
  }
}