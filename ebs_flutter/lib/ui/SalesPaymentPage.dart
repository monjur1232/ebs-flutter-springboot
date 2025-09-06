import 'package:ebs/model/SalesPayment.dart';
import 'package:ebs/provider/SalesPaymentProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SalesPaymentPage extends StatefulWidget {
  @override
  State<SalesPaymentPage> createState() => _SalesPaymentPageState();
}

class _SalesPaymentPageState extends State<SalesPaymentPage> {
  final _addFormKey = GlobalKey<FormState>();
  final _updateFormKey = GlobalKey<FormState>();

  // Controllers for Add Form
  final spCodeCtrl = TextEditingController();
  final customerCodeCtrl = TextEditingController();
  final customerNameCtrl = TextEditingController();
  final soCodeCtrl = TextEditingController();
  final amountCtrl = TextEditingController();
  final payDateCtrl = TextEditingController();
  final modeCtrl = TextEditingController();
  final refCtrl = TextEditingController();

  // Update Form
  SalesPayment? selectedSP;
  final uSpCodeCtrl = TextEditingController();
  final uCustomerCodeCtrl = TextEditingController();
  final uCustomerNameCtrl = TextEditingController();
  final uSoCodeCtrl = TextEditingController();
  final uAmountCtrl = TextEditingController();
  final uPayDateCtrl = TextEditingController();
  final uModeCtrl = TextEditingController();
  final uRefCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<SalesPaymentProvider>().fetchSalesPayments());
  }

  @override
  Widget build(BuildContext context) {
    final spProvider = context.watch<SalesPaymentProvider>();

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 240, 240),
      appBar: AppBar(
        title: Text("Sales Payment Management"),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ---------------- Add Section ----------------
            _sectionTitle("➕  Add New Sales Payment"),
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
                      _buildField("Sales Payment Code", spCodeCtrl, TextInputType.number),
                      _buildField("Customer Code", customerCodeCtrl, TextInputType.number),
                      _buildField("Customer Name", customerNameCtrl),
                      _buildField("Sales Order Code", soCodeCtrl, TextInputType.number),
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
                            final sp = SalesPayment(
                              salesPaymentCode: int.tryParse(spCodeCtrl.text),
                              customerCode: int.tryParse(customerCodeCtrl.text),
                              customerName: customerNameCtrl.text.isNotEmpty ? customerNameCtrl.text : null,
                              salesOrderCode: int.tryParse(soCodeCtrl.text),
                              amountPaid: amountCtrl.text.isNotEmpty ? double.tryParse(amountCtrl.text) : null,
                              payDate: payDateCtrl.text.isNotEmpty ? DateTime.parse(payDateCtrl.text) : null,
                              paymentMode: modeCtrl.text.isNotEmpty ? modeCtrl.text : null,
                              paymentRef: refCtrl.text.isNotEmpty ? refCtrl.text : null,
                            );
                            spProvider.addSalesPayment(sp);
                            _clearAddForm();
                            setState(() {
                              selectedSP = null;
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
            _sectionTitle("📋  Sales Payment List"),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: spProvider.salesPayments.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Center(child: Text("No sales payments found")),
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
                            label: Text("Sales Payment Code", 
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
                            label: Text("Sales Order Code", 
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
                        rows: spProvider.salesPayments.asMap().entries.map((entry) {
                          int index = entry.key;
                          SalesPayment sp = entry.value;

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
                              DataCell(Text(sp.salesPaymentCode?.toString() ?? '')),
                              DataCell(Text(sp.customerCode?.toString() ?? '')),
                              DataCell(Text(sp.customerName ?? '')),
                              DataCell(Text(sp.salesOrderCode?.toString() ?? '')),
                              DataCell(Text(sp.amountPaid?.toStringAsFixed(2) ?? '')),
                              DataCell(Text(sp.payDate?.toIso8601String().split('T')[0] ?? '')),
                              DataCell(Text(sp.paymentMode ?? '')),
                              DataCell(Text(sp.paymentRef ?? '')),
                              DataCell(
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () {
                                    setState(() {
                                      selectedSP = sp;
                                      _loadUpdateForm(sp);
                                    });
                                  },
                                ),
                              ),
                              DataCell(
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    spProvider.deleteSalesPayment(sp.id!);
                                    setState(() {
                                      selectedSP = null;
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
            if (selectedSP != null) ...[
              SizedBox(height: 20),
              _sectionTitle("✏️  Update Sales Payment"),
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
                        _buildField("Sales Payment Code", uSpCodeCtrl, TextInputType.number),
                        _buildField("Customer Code", uCustomerCodeCtrl, TextInputType.number),
                        _buildField("Customer Name", uCustomerNameCtrl),
                        _buildField("Sales Order Code", uSoCodeCtrl, TextInputType.number),
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
                              final sp = SalesPayment(
                                id: selectedSP!.id,
                                salesPaymentCode: int.tryParse(uSpCodeCtrl.text),
                                customerCode: int.tryParse(uCustomerCodeCtrl.text),
                                customerName: uCustomerNameCtrl.text.isNotEmpty ? uCustomerNameCtrl.text : null,
                                salesOrderCode: int.tryParse(uSoCodeCtrl.text),
                                amountPaid: uAmountCtrl.text.isNotEmpty ? double.tryParse(uAmountCtrl.text) : null,
                                payDate: uPayDateCtrl.text.isNotEmpty ? DateTime.parse(uPayDateCtrl.text) : null,
                                paymentMode: uModeCtrl.text.isNotEmpty ? uModeCtrl.text : null,
                                paymentRef: uRefCtrl.text.isNotEmpty ? uRefCtrl.text : null,
                              );
                              spProvider.updateSalesPayment(sp);
                              setState(() {
                                selectedSP = null;
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
    spCodeCtrl.clear();
    customerCodeCtrl.clear();
    customerNameCtrl.clear();
    soCodeCtrl.clear();
    amountCtrl.clear();
    payDateCtrl.clear();
    modeCtrl.clear();
    refCtrl.clear();
  }

  void _loadUpdateForm(SalesPayment sp) {
    uSpCodeCtrl.text = sp.salesPaymentCode?.toString() ?? '';
    uCustomerCodeCtrl.text = sp.customerCode?.toString() ?? '';
    uCustomerNameCtrl.text = sp.customerName ?? '';
    uSoCodeCtrl.text = sp.salesOrderCode?.toString() ?? '';
    uAmountCtrl.text = sp.amountPaid?.toString() ?? '';
    uPayDateCtrl.text = sp.payDate?.toIso8601String().split('T')[0] ?? '';
    uModeCtrl.text = sp.paymentMode ?? '';
    uRefCtrl.text = sp.paymentRef ?? '';
  }
}