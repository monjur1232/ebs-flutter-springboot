import 'package:ebs/model/SalesOrder.dart';
import 'package:ebs/provider/SalesOrderProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SalesOrderPage extends StatefulWidget {
  @override
  State<SalesOrderPage> createState() => _SalesOrderPageState();
}

class _SalesOrderPageState extends State<SalesOrderPage> {
  final _addFormKey = GlobalKey<FormState>();
  final _updateFormKey = GlobalKey<FormState>();

  // Controllers for Add Form
  final soCodeCtrl = TextEditingController();
  final customerCodeCtrl = TextEditingController();
  final customerNameCtrl = TextEditingController();
  final orderDateCtrl = TextEditingController();
  final deliveryDateCtrl = TextEditingController();
  final productCodeCtrl = TextEditingController();
  final productNameCtrl = TextEditingController();
  final unitPriceCtrl = TextEditingController();
  final quantityCtrl = TextEditingController();
  final totalAmountCtrl = TextEditingController();
  final paymentStatusCtrl = TextEditingController();
  final statusCtrl = TextEditingController();

  // Update Form
  SalesOrder? selectedSO;
  final uSoCodeCtrl = TextEditingController();
  final uCustomerCodeCtrl = TextEditingController();
  final uCustomerNameCtrl = TextEditingController();
  final uOrderDateCtrl = TextEditingController();
  final uDeliveryDateCtrl = TextEditingController();
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
        () => context.read<SalesOrderProvider>().fetchSalesOrders());
  }

  @override
  Widget build(BuildContext context) {
    final soProvider = context.watch<SalesOrderProvider>();

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 240, 240),
      appBar: AppBar(
        title: Text("Sales Order Management"),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ---------------- Add Section ----------------
            _sectionTitle("➕  Add New Sales Order"),
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
                      _buildField("Sales Order Code", soCodeCtrl, TextInputType.number),
                      _buildField("Customer Code", customerCodeCtrl, TextInputType.number),
                      _buildField("Customer Name", customerNameCtrl),
                      _buildDateField("Order Date (yyyy-mm-dd)", orderDateCtrl),
                      _buildDateField("Delivery Date (yyyy-mm-dd)", deliveryDateCtrl),
                      _buildField("Product Code", productCodeCtrl, TextInputType.number),
                      _buildField("Product Name", productNameCtrl),
                      _buildField("Unit Price", unitPriceCtrl, 
                          TextInputType.numberWithOptions(decimal: true)),
                      _buildField("Sales Quantity", quantityCtrl, TextInputType.number),
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
                            final so = SalesOrder(
                              salesOrderCode: int.tryParse(soCodeCtrl.text),
                              customerCode: int.tryParse(customerCodeCtrl.text),
                              customerName: customerNameCtrl.text.isNotEmpty ? customerNameCtrl.text : null,
                              orderDate: orderDateCtrl.text.isNotEmpty ? DateTime.parse(orderDateCtrl.text) : null,
                              deliveryDate: deliveryDateCtrl.text.isNotEmpty ? DateTime.parse(deliveryDateCtrl.text) : null,
                              productCode: int.tryParse(productCodeCtrl.text),
                              productName: productNameCtrl.text.isNotEmpty ? productNameCtrl.text : null,
                              unitPrice: unitPriceCtrl.text.isNotEmpty ? double.tryParse(unitPriceCtrl.text) : null,
                              salesQuantity: quantityCtrl.text.isNotEmpty ? int.tryParse(quantityCtrl.text) : null,
                              totalAmount: totalAmountCtrl.text.isNotEmpty ? double.tryParse(totalAmountCtrl.text) : null,
                              paymentStatus: paymentStatusCtrl.text.isNotEmpty ? paymentStatusCtrl.text : null,
                              status: statusCtrl.text.isNotEmpty ? statusCtrl.text : null,
                            );
                            context.read<SalesOrderProvider>().addSalesOrder(so);
                            _clearAddForm();
                            setState(() {
                              selectedSO = null;
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
            _sectionTitle("📋  Sales Order List"),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: soProvider.salesOrders.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Center(child: Text("No sales orders found")),
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
                            label: Text("Order Date", 
                                style: TextStyle(fontWeight: FontWeight.bold,
                                color: Colors.white)),
                          ),
                          DataColumn(
                            label: Text("Delivery Date", 
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
                            label: Text("Sales Quantity", 
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
                        rows: soProvider.salesOrders.asMap().entries.map((entry) {
                          int index = entry.key;
                          SalesOrder so = entry.value;

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
                              DataCell(Text(so.salesOrderCode?.toString() ?? '')),
                              DataCell(Text(so.customerCode?.toString() ?? '')),
                              DataCell(Text(so.customerName ?? '')),
                              DataCell(Text(so.orderDate?.toIso8601String().split('T')[0] ?? '')),
                              DataCell(Text(so.deliveryDate?.toIso8601String().split('T')[0] ?? '')),
                              DataCell(Text(so.productCode?.toString() ?? '')),
                              DataCell(Text(so.productName ?? '')),
                              DataCell(Text(so.unitPrice?.toStringAsFixed(2) ?? '')),
                              DataCell(Text(so.salesQuantity?.toString() ?? '')),                              
                              DataCell(Text(so.totalAmount?.toStringAsFixed(2) ?? '')),
                              DataCell(Text(so.paymentStatus ?? '')),
                              DataCell(Text(so.status ?? '')),
                              DataCell(
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () {
                                    setState(() {
                                      selectedSO = so;
                                      _loadUpdateForm(so);
                                    });
                                  },
                                ),
                              ),
                              DataCell(
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    soProvider.deleteSalesOrder(so.id!);
                                    setState(() {
                                      selectedSO = null;
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
            if (selectedSO != null) ...[
              SizedBox(height: 20),
              _sectionTitle("✏️  Update Sales Order"),
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
                        _buildField("Sales Order Code", uSoCodeCtrl, TextInputType.number),
                        _buildField("Customer Code", uCustomerCodeCtrl, TextInputType.number),
                        _buildField("Customer Name", uCustomerNameCtrl),
                        _buildDateField("Order Date (yyyy-mm-dd)", uOrderDateCtrl),
                        _buildDateField("Delivery Date (yyyy-mm-dd)", uDeliveryDateCtrl),
                        _buildField("Product Code", uProductCodeCtrl, TextInputType.number),
                        _buildField("Product Name", uProductNameCtrl),
                        _buildField("Unit Price", uUnitPriceCtrl, 
                            TextInputType.numberWithOptions(decimal: true)),
                        _buildField("Sales Quantity", uQuantityCtrl, TextInputType.number),
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
                              final so = SalesOrder(
                                id: selectedSO!.id,
                                salesOrderCode: int.tryParse(uSoCodeCtrl.text),
                                customerCode: int.tryParse(uCustomerCodeCtrl.text),
                                customerName: uCustomerNameCtrl.text.isNotEmpty ? uCustomerNameCtrl.text : null,
                                orderDate: uOrderDateCtrl.text.isNotEmpty ? DateTime.parse(uOrderDateCtrl.text) : null,
                                deliveryDate: uDeliveryDateCtrl.text.isNotEmpty ? DateTime.parse(uDeliveryDateCtrl.text) : null,
                                productCode: int.tryParse(uProductCodeCtrl.text),
                                productName: uProductNameCtrl.text.isNotEmpty ? uProductNameCtrl.text : null,
                                unitPrice: uUnitPriceCtrl.text.isNotEmpty ? double.tryParse(uUnitPriceCtrl.text) : null,
                                salesQuantity: uQuantityCtrl.text.isNotEmpty ? int.tryParse(uQuantityCtrl.text) : null,
                                totalAmount: uTotalAmountCtrl.text.isNotEmpty ? double.tryParse(uTotalAmountCtrl.text) : null,
                                paymentStatus: uPaymentStatusCtrl.text.isNotEmpty ? uPaymentStatusCtrl.text : null,
                                status: uStatusCtrl.text.isNotEmpty ? uStatusCtrl.text : null,
                              );
                              soProvider.updateSalesOrder(so);
                              setState(() {
                                selectedSO = null;
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
    soCodeCtrl.clear();
    customerCodeCtrl.clear();
    customerNameCtrl.clear();
    orderDateCtrl.clear();
    deliveryDateCtrl.clear();
    productCodeCtrl.clear();
    productNameCtrl.clear();
    unitPriceCtrl.clear();
    quantityCtrl.clear();
    totalAmountCtrl.clear();
    paymentStatusCtrl.clear();
    statusCtrl.clear();
  }

  void _loadUpdateForm(SalesOrder so) {
    uSoCodeCtrl.text = so.salesOrderCode?.toString() ?? '';
    uCustomerCodeCtrl.text = so.customerCode?.toString() ?? '';
    uCustomerNameCtrl.text = so.customerName ?? '';
    uOrderDateCtrl.text = so.orderDate?.toIso8601String().split('T')[0] ?? '';
    uDeliveryDateCtrl.text = so.deliveryDate?.toIso8601String().split('T')[0] ?? '';
    uProductCodeCtrl.text = so.productCode?.toString() ?? '';
    uProductNameCtrl.text = so.productName ?? '';
    uUnitPriceCtrl.text = so.unitPrice?.toString() ?? '';
    uQuantityCtrl.text = so.salesQuantity?.toString() ?? '';
    uTotalAmountCtrl.text = so.totalAmount?.toString() ?? '';
    uPaymentStatusCtrl.text = so.paymentStatus ?? '';
    uStatusCtrl.text = so.status ?? '';
  }
}