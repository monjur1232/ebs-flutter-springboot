import 'package:ebs/model/Payment.dart';
import 'package:ebs/provider/PaymentProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaymentPage extends StatefulWidget {
  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _addFormKey = GlobalKey<FormState>();
  final _updateFormKey = GlobalKey<FormState>();

  // Controllers for Add Form
  final paymentCodeCtrl = TextEditingController();
  final supplierCodeCtrl = TextEditingController();
  final supplierNameCtrl = TextEditingController();
  final poCodeCtrl = TextEditingController();
  final amountCtrl = TextEditingController();
  final payDateCtrl = TextEditingController();
  final modeCtrl = TextEditingController();
  final refCtrl = TextEditingController();

  // Update Form
  Payment? selectedPayment;
  final uPaymentCodeCtrl = TextEditingController();
  final uSupplierCodeCtrl = TextEditingController();
  final uSupplierNameCtrl = TextEditingController();
  final uPoCodeCtrl = TextEditingController();
  final uAmountCtrl = TextEditingController();
  final uPayDateCtrl = TextEditingController();
  final uModeCtrl = TextEditingController();
  final uRefCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<PaymentProvider>().fetchPayments());
  }

  @override
  Widget build(BuildContext context) {
    final paymentProvider = context.watch<PaymentProvider>();

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 240, 240),
      appBar: AppBar(
        title: Text("Payment Management"),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ---------------- Add Section ----------------
            _sectionTitle("➕  Add New Payment"),
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
                      _buildField("Payment Code", paymentCodeCtrl, TextInputType.number),
                      _buildField("Supplier Code", supplierCodeCtrl, TextInputType.number),
                      _buildField("Supplier Name", supplierNameCtrl),
                      _buildField("Purchase Order Code", poCodeCtrl, TextInputType.number),
                      _buildField("Amount Paid", amountCtrl, 
                          TextInputType.numberWithOptions(decimal: true)),
                      _buildDateField("Pay Date (yyyy-mm-dd)", payDateCtrl),
                      _buildField("Payment Mode", modeCtrl),
                      _buildField("Payment Ref", refCtrl),
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
                            final payment = Payment(
                              paymentCode: int.tryParse(paymentCodeCtrl.text),
                              supplierCode: int.tryParse(supplierCodeCtrl.text),
                              supplierName: supplierNameCtrl.text.isNotEmpty ? supplierNameCtrl.text : null,
                              purchaseOrderCode: int.tryParse(poCodeCtrl.text),
                              amountPaid: amountCtrl.text.isNotEmpty ? double.tryParse(amountCtrl.text) : null,
                              payDate: payDateCtrl.text.isNotEmpty ? DateTime.parse(payDateCtrl.text) : null,
                              paymentMode: modeCtrl.text.isNotEmpty ? modeCtrl.text : null,
                              paymentRef: refCtrl.text.isNotEmpty ? refCtrl.text : null,
                            );
                            paymentProvider.addPayment(payment);
                            _clearAddForm();
                            setState(() {
                              selectedPayment = null;
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
            _sectionTitle("📋  Payment List"),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: paymentProvider.payments.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Center(child: Text("No payments found")),
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
                            label: Text("Payment Code", 
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
                            label: Text("Purchase Order Code", 
                                style: TextStyle(fontWeight: FontWeight.bold,
                                color: Colors.white)),
                          ),
                          DataColumn(
                            label: Text("Amount Paid", 
                                style: TextStyle(fontWeight: FontWeight.bold,
                                color: Colors.white)),
                          ),
                          DataColumn(
                            label: Text("Pay Date", 
                                style: TextStyle(fontWeight: FontWeight.bold,
                                color: Colors.white)),
                          ),
                          DataColumn(
                            label: Text("Payment Mode", 
                                style: TextStyle(fontWeight: FontWeight.bold,
                                color: Colors.white)),
                          ),
                          DataColumn(
                            label: Text("Payment Ref", 
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
                        rows: paymentProvider.payments.asMap().entries.map((entry) {
                          int index = entry.key;
                          Payment payment = entry.value;

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
                              DataCell(Text(payment.paymentCode?.toString() ?? '')),
                              DataCell(Text(payment.supplierCode?.toString() ?? '')),
                              DataCell(Text(payment.supplierName ?? '')),
                              DataCell(Text(payment.purchaseOrderCode?.toString() ?? '')),
                              DataCell(Text(payment.amountPaid?.toStringAsFixed(2) ?? '')),
                              DataCell(Text(payment.payDate?.toIso8601String().split('T')[0] ?? '')),
                              DataCell(Text(payment.paymentMode ?? '')),
                              DataCell(Text(payment.paymentRef ?? '')),
                              DataCell(
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () {
                                    setState(() {
                                      selectedPayment = payment;
                                      _loadUpdateForm(payment);
                                    });
                                  },
                                ),
                              ),
                              DataCell(
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    paymentProvider.deletePayment(payment.id!);
                                    setState(() {
                                      selectedPayment = null;
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
            if (selectedPayment != null) ...[
              SizedBox(height: 20),
              _sectionTitle("✏️  Update Payment"),
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
                        _buildField("Payment Code", uPaymentCodeCtrl, TextInputType.number),
                        _buildField("Supplier Code", uSupplierCodeCtrl, TextInputType.number),
                        _buildField("Supplier Name", uSupplierNameCtrl),
                        _buildField("Purchase Order Code", uPoCodeCtrl, TextInputType.number),
                        _buildField("Amount Paid", uAmountCtrl, 
                            TextInputType.numberWithOptions(decimal: true)),
                        _buildDateField("Pay Date (yyyy-mm-dd)", uPayDateCtrl),
                        _buildField("Payment Mode", uModeCtrl),
                        _buildField("Payment Ref", uRefCtrl),
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
                              final payment = Payment(
                                id: selectedPayment!.id,
                                paymentCode: int.tryParse(uPaymentCodeCtrl.text),
                                supplierCode: int.tryParse(uSupplierCodeCtrl.text),
                                supplierName: uSupplierNameCtrl.text.isNotEmpty ? uSupplierNameCtrl.text : null,
                                purchaseOrderCode: int.tryParse(uPoCodeCtrl.text),
                                amountPaid: uAmountCtrl.text.isNotEmpty ? double.tryParse(uAmountCtrl.text) : null,
                                payDate: uPayDateCtrl.text.isNotEmpty ? DateTime.parse(uPayDateCtrl.text) : null,
                                paymentMode: uModeCtrl.text.isNotEmpty ? uModeCtrl.text : null,
                                paymentRef: uRefCtrl.text.isNotEmpty ? uRefCtrl.text : null,
                              );
                              paymentProvider.updatePayment(payment);
                              setState(() {
                                selectedPayment = null;
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
    paymentCodeCtrl.clear();
    supplierCodeCtrl.clear();
    supplierNameCtrl.clear();
    poCodeCtrl.clear();
    amountCtrl.clear();
    payDateCtrl.clear();
    modeCtrl.clear();
    refCtrl.clear();
  }

  void _loadUpdateForm(Payment payment) {
    uPaymentCodeCtrl.text = payment.paymentCode?.toString() ?? '';
    uSupplierCodeCtrl.text = payment.supplierCode?.toString() ?? '';
    uSupplierNameCtrl.text = payment.supplierName ?? '';
    uPoCodeCtrl.text = payment.purchaseOrderCode?.toString() ?? '';
    uAmountCtrl.text = payment.amountPaid?.toString() ?? '';
    uPayDateCtrl.text = payment.payDate?.toIso8601String().split('T')[0] ?? '';
    uModeCtrl.text = payment.paymentMode ?? '';
    uRefCtrl.text = payment.paymentRef ?? '';
  }
}