import 'package:ebs/model/PurchaseOrder.dart';
import 'package:ebs/provider/PurchaseOrderProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PurchaseOrderPage extends StatefulWidget {
  @override
  State<PurchaseOrderPage> createState() => _PurchaseOrderPageState();
}

class _PurchaseOrderPageState extends State<PurchaseOrderPage> {
  final _addFormKey = GlobalKey<FormState>();
  final _updateFormKey = GlobalKey<FormState>();

  // Controllers for Add Form
  final poCodeCtrl = TextEditingController();
  final supplierCodeCtrl = TextEditingController();
  final supplierNameCtrl = TextEditingController();
  final orderDateCtrl = TextEditingController();
  final receivedDateCtrl = TextEditingController();
  final productCodeCtrl = TextEditingController();
  final productNameCtrl = TextEditingController();
  final unitPriceCtrl = TextEditingController();
  final quantityCtrl = TextEditingController();
  final totalAmountCtrl = TextEditingController();
  final paymentStatusCtrl = TextEditingController();
  final statusCtrl = TextEditingController();

  // Update Form
  PurchaseOrder? selectedPO;
  final uPoCodeCtrl = TextEditingController();
  final uSupplierCodeCtrl = TextEditingController();
  final uSupplierNameCtrl = TextEditingController();
  final uOrderDateCtrl = TextEditingController();
  final uReceivedDateCtrl = TextEditingController();
  final uProductCodeCtrl = TextEditingController();
  final uProductNameCtrl = TextEditingController();
  final uUnitPriceCtrl = TextEditingController();
  final uQuantityCtrl = TextEditingController();
  final uTotalAmountCtrl = TextEditingController();
  final uPaymentStatusCtrl = TextEditingController();
  final uStatusCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => context.read<PurchaseOrderProvider>().fetchPurchaseOrders());
  }

  @override
  Widget build(BuildContext context) {
    final poProvider = context.watch<PurchaseOrderProvider>();

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 240, 240),
      appBar: AppBar(
        title: Text("Purchase Order Management"),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ---------------- Add Section ----------------
            _sectionTitle("➕  Add New Purchase Order"),
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
                      _buildField("Purchase Order Code", poCodeCtrl, TextInputType.number),
                      _buildField("Supplier Code", supplierCodeCtrl, TextInputType.number),
                      _buildField("Supplier Name", supplierNameCtrl),
                      _buildDateField("Order Date (yyyy-mm-dd)", orderDateCtrl),
                      _buildDateField("Received Date (yyyy-mm-dd)", receivedDateCtrl),
                      _buildField("Product Code", productCodeCtrl, TextInputType.number),
                      _buildField("Product Name", productNameCtrl),
                      _buildField("Unit Price", unitPriceCtrl, 
                          TextInputType.numberWithOptions(decimal: true)),
                      _buildField("Purchase Quantity", quantityCtrl, TextInputType.number),
                      _buildField("Total Amount", totalAmountCtrl, 
                          TextInputType.numberWithOptions(decimal: true)),
                      _buildField("Payment Status", paymentStatusCtrl),
                      _buildField("Status", statusCtrl),
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
                            final po = PurchaseOrder(
                              purchaseOrderCode: int.tryParse(poCodeCtrl.text),
                              supplierCode: int.tryParse(supplierCodeCtrl.text),
                              supplierName: supplierNameCtrl.text.isNotEmpty ? supplierNameCtrl.text : null,
                              orderDate: orderDateCtrl.text.isNotEmpty ? DateTime.parse(orderDateCtrl.text) : null,
                              receivedDate: receivedDateCtrl.text.isNotEmpty ? DateTime.parse(receivedDateCtrl.text) : null,
                              productCode: int.tryParse(productCodeCtrl.text),
                              productName: productNameCtrl.text.isNotEmpty ? productNameCtrl.text : null,
                              unitPrice: unitPriceCtrl.text.isNotEmpty ? double.tryParse(unitPriceCtrl.text) : null,
                              purchaseQuantity: quantityCtrl.text.isNotEmpty ? int.tryParse(quantityCtrl.text) : null,
                              totalAmount: totalAmountCtrl.text.isNotEmpty ? double.tryParse(totalAmountCtrl.text) : null,
                              paymentStatus: paymentStatusCtrl.text.isNotEmpty ? paymentStatusCtrl.text : null,
                              status: statusCtrl.text.isNotEmpty ? statusCtrl.text : null,
                            );
                            context.read<PurchaseOrderProvider>().addPurchaseOrder(po);
                            _clearAddForm();
                            setState(() {
                              selectedPO = null;
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
            _sectionTitle("📋  Purchase Order List"),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: poProvider.purchaseOrders.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Center(child: Text("No purchase orders found")),
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
                            label: Text("Order Date", 
                                style: TextStyle(fontWeight: FontWeight.bold,
                                color: Colors.white)),
                          ),
                          DataColumn(
                            label: Text("Received Date", 
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
                            label: Text("Unit Price", 
                                style: TextStyle(fontWeight: FontWeight.bold,
                                color: Colors.white)),
                          ),
                          DataColumn(
                            label: Text("Purchase Quantity", 
                                style: TextStyle(fontWeight: FontWeight.bold,
                                color: Colors.white)),
                          ),
                          DataColumn(
                            label: Text("Total Amount", 
                                style: TextStyle(fontWeight: FontWeight.bold,
                                color: Colors.white)),
                          ),
                          DataColumn(
                            label: Text("Payment Status", 
                                style: TextStyle(fontWeight: FontWeight.bold,
                                color: Colors.white)),
                          ),
                          DataColumn(
                            label: Text("Status", 
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
                        rows: poProvider.purchaseOrders.asMap().entries.map((entry) {
                          int index = entry.key;
                          PurchaseOrder po = entry.value;

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
                              DataCell(Text(po.purchaseOrderCode?.toString() ?? '')),
                              DataCell(Text(po.supplierCode?.toString() ?? '')),
                              DataCell(Text(po.supplierName ?? '')),
                              DataCell(Text(po.orderDate?.toIso8601String().split('T')[0] ?? '')),
                              DataCell(Text(po.receivedDate?.toIso8601String().split('T')[0] ?? '')),
                              DataCell(Text(po.productCode?.toString() ?? '')),
                              DataCell(Text(po.productName ?? '')),
                              DataCell(Text(po.unitPrice?.toStringAsFixed(2) ?? '')),
                              DataCell(Text(po.purchaseQuantity?.toString() ?? '')),                              
                              DataCell(Text(po.totalAmount?.toStringAsFixed(2) ?? '')),
                              DataCell(Text(po.paymentStatus ?? '')),
                              DataCell(Text(po.status ?? '')),
                              DataCell(
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () {
                                    setState(() {
                                      selectedPO = po;
                                      _loadUpdateForm(po);
                                    });
                                  },
                                ),
                              ),
                              DataCell(
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    poProvider.deletePurchaseOrder(po.id!);
                                    setState(() {
                                      selectedPO = null;
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
            if (selectedPO != null) ...[
              SizedBox(height: 20),
              _sectionTitle("✏️  Update Purchase Order"),
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
                        _buildField("Purchase Order Code", uPoCodeCtrl, TextInputType.number),
                        _buildField("Supplier Code", uSupplierCodeCtrl, TextInputType.number),
                        _buildField("Supplier Name", uSupplierNameCtrl),
                        _buildDateField("Order Date (yyyy-mm-dd)", uOrderDateCtrl),
                        _buildDateField("Received Date (yyyy-mm-dd)", uReceivedDateCtrl),
                        _buildField("Product Code", uProductCodeCtrl, TextInputType.number),
                        _buildField("Product Name", uProductNameCtrl),
                        _buildField("Unit Price", uUnitPriceCtrl, 
                            TextInputType.numberWithOptions(decimal: true)),
                        _buildField("Purchase Quantity", uQuantityCtrl, TextInputType.number),
                        _buildField("Total Amount", uTotalAmountCtrl, 
                            TextInputType.numberWithOptions(decimal: true)),
                        _buildField("Payment Status", uPaymentStatusCtrl),
                        _buildField("Status", uStatusCtrl),
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
                              final po = PurchaseOrder(
                                id: selectedPO!.id,
                                purchaseOrderCode: int.tryParse(uPoCodeCtrl.text),
                                supplierCode: int.tryParse(uSupplierCodeCtrl.text),
                                supplierName: uSupplierNameCtrl.text.isNotEmpty ? uSupplierNameCtrl.text : null,
                                orderDate: uOrderDateCtrl.text.isNotEmpty ? DateTime.parse(uOrderDateCtrl.text) : null,
                                receivedDate: uReceivedDateCtrl.text.isNotEmpty ? DateTime.parse(uReceivedDateCtrl.text) : null,
                                productCode: int.tryParse(uProductCodeCtrl.text),
                                productName: uProductNameCtrl.text.isNotEmpty ? uProductNameCtrl.text : null,
                                unitPrice: uUnitPriceCtrl.text.isNotEmpty ? double.tryParse(uUnitPriceCtrl.text) : null,
                                purchaseQuantity: uQuantityCtrl.text.isNotEmpty ? int.tryParse(uQuantityCtrl.text) : null,
                                totalAmount: uTotalAmountCtrl.text.isNotEmpty ? double.tryParse(uTotalAmountCtrl.text) : null,
                                paymentStatus: uPaymentStatusCtrl.text.isNotEmpty ? uPaymentStatusCtrl.text : null,
                                status: uStatusCtrl.text.isNotEmpty ? uStatusCtrl.text : null,
                              );
                              poProvider.updatePurchaseOrder(po);
                              setState(() {
                                selectedPO = null;
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
    poCodeCtrl.clear();
    supplierCodeCtrl.clear();
    supplierNameCtrl.clear();
    orderDateCtrl.clear();
    receivedDateCtrl.clear();
    productCodeCtrl.clear();
    productNameCtrl.clear();
    unitPriceCtrl.clear();
    quantityCtrl.clear();
    totalAmountCtrl.clear();
    paymentStatusCtrl.clear();
    statusCtrl.clear();
  }

  void _loadUpdateForm(PurchaseOrder po) {
    uPoCodeCtrl.text = po.purchaseOrderCode?.toString() ?? '';
    uSupplierCodeCtrl.text = po.supplierCode?.toString() ?? '';
    uSupplierNameCtrl.text = po.supplierName ?? '';
    uOrderDateCtrl.text = po.orderDate?.toIso8601String().split('T')[0] ?? '';
    uReceivedDateCtrl.text = po.receivedDate?.toIso8601String().split('T')[0] ?? '';
    uProductCodeCtrl.text = po.productCode?.toString() ?? '';
    uProductNameCtrl.text = po.productName ?? '';
    uUnitPriceCtrl.text = po.unitPrice?.toString() ?? '';
    uQuantityCtrl.text = po.purchaseQuantity?.toString() ?? '';
    uTotalAmountCtrl.text = po.totalAmount?.toString() ?? '';
    uPaymentStatusCtrl.text = po.paymentStatus ?? '';
    uStatusCtrl.text = po.status ?? '';
  }
}