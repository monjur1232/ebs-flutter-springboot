import 'package:ebs/model/Return.dart';
import 'package:ebs/provider/ReturnProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReturnPage extends StatefulWidget {
  @override
  State<ReturnPage> createState() => _ReturnPageState();
}

class _ReturnPageState extends State<ReturnPage> {
  final _addFormKey = GlobalKey<FormState>();
  final _updateFormKey = GlobalKey<FormState>();

  // Controllers for Add Form
  final returnCodeCtrl = TextEditingController();
  final poCodeCtrl = TextEditingController();
  final supplierCodeCtrl = TextEditingController();
  final supplierNameCtrl = TextEditingController();
  final productCodeCtrl = TextEditingController();
  final productNameCtrl = TextEditingController();
  final purchaseQtyCtrl = TextEditingController();
  final returnQtyCtrl = TextEditingController();
  final returnDateCtrl = TextEditingController();
  final reasonCtrl = TextEditingController();

  // Update Form
  Return? selectedReturn;
  final uReturnCodeCtrl = TextEditingController();
  final uPoCodeCtrl = TextEditingController();
  final uSupplierCodeCtrl = TextEditingController();
  final uSupplierNameCtrl = TextEditingController();
  final uProductCodeCtrl = TextEditingController();
  final uProductNameCtrl = TextEditingController();
  final uPurchaseQtyCtrl = TextEditingController();
  final uReturnQtyCtrl = TextEditingController();
  final uReturnDateCtrl = TextEditingController();
  final uReasonCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<ReturnProvider>().fetchReturns());
  }

  @override
  Widget build(BuildContext context) {
    final returnProvider = context.watch<ReturnProvider>();

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 240, 240),
      appBar: AppBar(
        title: Text("Return Management"),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ---------------- Add Section ----------------
            _sectionTitle("➕  Add New Return"),
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
                      _buildField("Return Code", returnCodeCtrl, TextInputType.number),
                      _buildField("Purchase Order Code", poCodeCtrl, TextInputType.number),
                      _buildField("Supplier Code", supplierCodeCtrl, TextInputType.number),
                      _buildField("Supplier Name", supplierNameCtrl),
                      _buildField("Product Code", productCodeCtrl, TextInputType.number),
                      _buildField("Product Name", productNameCtrl),
                      _buildField("Purchase Quantity", purchaseQtyCtrl, TextInputType.number),
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
                            final returnData = Return(
                              returnCode: int.tryParse(returnCodeCtrl.text),
                              purchaseOrderCode: int.tryParse(poCodeCtrl.text),
                              supplierCode: int.tryParse(supplierCodeCtrl.text),
                              supplierName: supplierNameCtrl.text.isNotEmpty ? supplierNameCtrl.text : null,
                              productCode: int.tryParse(productCodeCtrl.text),
                              productName: productNameCtrl.text.isNotEmpty ? productNameCtrl.text : null,
                              purchaseQuantity: purchaseQtyCtrl.text.isNotEmpty ? int.tryParse(purchaseQtyCtrl.text) : null,
                              returnQuantity: returnQtyCtrl.text.isNotEmpty ? int.tryParse(returnQtyCtrl.text) : null,
                              returnDate: returnDateCtrl.text.isNotEmpty ? DateTime.parse(returnDateCtrl.text) : null,
                              reason: reasonCtrl.text.isNotEmpty ? reasonCtrl.text : null,
                            );
                            context.read<ReturnProvider>().addReturn(returnData);
                            _clearAddForm();
                            setState(() {
                              selectedReturn = null;
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
            _sectionTitle("📋  Return List"),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: returnProvider.returns.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Center(child: Text("No returns found")),
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
                          //   label: Text("Return Code", 
                          //       style: TextStyle(fontWeight: FontWeight.bold,
                          //       color: Colors.white)),
                          // ),
                          DataColumn(
                            label: Text("Purchase Order Code", 
                                style: TextStyle(fontWeight: FontWeight.bold,
                                color: Colors.white)),
                          ),
                          DataColumn(
                            label: Text("Supplier Code", 
                                style: TextStyle(fontWeight: FontWeight.bold,
                                color: Colors.white)),
                          ),
                          DataColumn(
                            label: Text("Supplier Name", 
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
                            label: Text("Purchase Quantity", 
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
                        rows: returnProvider.returns.asMap().entries.map((entry) {
                          int index = entry.key;
                          Return ret = entry.value;

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
                              // DataCell(Text(ret.returnCode?.toString() ?? '')),
                              DataCell(Text(ret.purchaseOrderCode?.toString() ?? '')),
                              DataCell(Text(ret.supplierCode?.toString() ?? '')),
                              DataCell(Text(ret.supplierName ?? '')),
                              DataCell(Text(ret.productCode?.toString() ?? '')),
                              DataCell(Text(ret.productName ?? '')),
                              DataCell(Text(ret.purchaseQuantity?.toString() ?? '')),
                              DataCell(Text(ret.returnQuantity?.toString() ?? '')),
                              DataCell(Text(ret.returnDate?.toIso8601String().split('T')[0] ?? '')),
                              DataCell(Text(ret.reason ?? '')),
                              DataCell(
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () {
                                    setState(() {
                                      selectedReturn = ret;
                                      _loadUpdateForm(ret);
                                    });
                                  },
                                ),
                              ),
                              DataCell(
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    returnProvider.deleteReturn(ret.id!);
                                    setState(() {
                                      selectedReturn = null;
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
            if (selectedReturn != null) ...[
              SizedBox(height: 20),
              _sectionTitle("✏️  Update Return"),
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
                        _buildField("Return Code", uReturnCodeCtrl, TextInputType.number),
                        _buildField("Purchase Order Code", uPoCodeCtrl, TextInputType.number),
                        _buildField("Supplier Code", uSupplierCodeCtrl, TextInputType.number),
                        _buildField("Supplier Name", uSupplierNameCtrl),
                        _buildField("Product Code", uProductCodeCtrl, TextInputType.number),
                        _buildField("Product Name", uProductNameCtrl),
                        _buildField("Purchase Quantity", uPurchaseQtyCtrl, TextInputType.number),
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
                              final returnData = Return(
                                id: selectedReturn!.id,
                                returnCode: int.tryParse(uReturnCodeCtrl.text),
                                purchaseOrderCode: int.tryParse(uPoCodeCtrl.text),
                                supplierCode: int.tryParse(uSupplierCodeCtrl.text),
                                supplierName: uSupplierNameCtrl.text.isNotEmpty ? uSupplierNameCtrl.text : null,
                                productCode: int.tryParse(uProductCodeCtrl.text),
                                productName: uProductNameCtrl.text.isNotEmpty ? uProductNameCtrl.text : null,
                                purchaseQuantity: uPurchaseQtyCtrl.text.isNotEmpty ? int.tryParse(uPurchaseQtyCtrl.text) : null,
                                returnQuantity: uReturnQtyCtrl.text.isNotEmpty ? int.tryParse(uReturnQtyCtrl.text) : null,
                                returnDate: uReturnDateCtrl.text.isNotEmpty ? DateTime.parse(uReturnDateCtrl.text) : null,
                                reason: uReasonCtrl.text.isNotEmpty ? uReasonCtrl.text : null,
                              );
                              returnProvider.updateReturn(returnData);
                              setState(() {
                                selectedReturn = null;
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
    returnCodeCtrl.clear();
    poCodeCtrl.clear();
    supplierCodeCtrl.clear();
    supplierNameCtrl.clear();
    productCodeCtrl.clear();
    productNameCtrl.clear();
    purchaseQtyCtrl.clear();
    returnQtyCtrl.clear();
    returnDateCtrl.clear();
    reasonCtrl.clear();
  }

  void _loadUpdateForm(Return ret) {
    uReturnCodeCtrl.text = ret.returnCode?.toString() ?? '';
    uPoCodeCtrl.text = ret.purchaseOrderCode?.toString() ?? '';
    uSupplierCodeCtrl.text = ret.supplierCode?.toString() ?? '';
    uSupplierNameCtrl.text = ret.supplierName ?? '';
    uProductCodeCtrl.text = ret.productCode?.toString() ?? '';
    uProductNameCtrl.text = ret.productName ?? '';
    uPurchaseQtyCtrl.text = ret.purchaseQuantity?.toString() ?? '';
    uReturnQtyCtrl.text = ret.returnQuantity?.toString() ?? '';
    uReturnDateCtrl.text = ret.returnDate?.toIso8601String().split('T')[0] ?? '';
    uReasonCtrl.text = ret.reason ?? '';
  }
}