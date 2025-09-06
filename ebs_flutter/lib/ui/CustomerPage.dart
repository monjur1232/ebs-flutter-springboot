import 'package:ebs/model/Customer.dart';
import 'package:ebs/provider/CustomerProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomerPage extends StatefulWidget {
  @override
  State<CustomerPage> createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  final _addFormKey = GlobalKey<FormState>();
  final _updateFormKey = GlobalKey<FormState>();

  // Controllers for Add Form
  final codeCtrl = TextEditingController();
  final nameCtrl = TextEditingController();
  final contactCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final taxCtrl = TextEditingController();
  final statusCtrl = TextEditingController();

  // Update Form
  Customer? selectedCustomer;
  final uCodeCtrl = TextEditingController();
  final uNameCtrl = TextEditingController();
  final uContactCtrl = TextEditingController();
  final uPhoneCtrl = TextEditingController();
  final uEmailCtrl = TextEditingController();
  final uAddressCtrl = TextEditingController();
  final uTaxCtrl = TextEditingController();
  final uStatusCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => context.read<CustomerProvider>().fetchCustomers()); // Load data once
  }

  @override
  Widget build(BuildContext context) {
    final customerProvider = context.watch<CustomerProvider>();

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 240, 240),
      appBar: AppBar(
        title: Text("Customer Management"),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ---------------- Add Section ----------------
            _sectionTitle("➕  Add a New Customer"),
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
                      _buildField("Customer Code", codeCtrl, TextInputType.number),
                      _buildField("Customer Name", nameCtrl),
                      _buildField("Contact Person", contactCtrl),
                      _buildField("Phone", phoneCtrl, TextInputType.phone),
                      _buildField("Email", emailCtrl, TextInputType.emailAddress),
                      _buildField("Address", addressCtrl),
                      _buildField("Tax ID", taxCtrl, TextInputType.number),
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
                            final customer = Customer(
                              customerCode: int.tryParse(codeCtrl.text),
                              customerName: nameCtrl.text.isNotEmpty ? nameCtrl.text : null,
                              contactPerson: contactCtrl.text.isNotEmpty ? contactCtrl.text : null,
                              phone: phoneCtrl.text.isNotEmpty ? phoneCtrl.text : null,
                              email: emailCtrl.text.isNotEmpty ? emailCtrl.text : null,
                              address: addressCtrl.text.isNotEmpty ? addressCtrl.text : null,
                              taxId: taxCtrl.text.isNotEmpty ? int.tryParse(taxCtrl.text) : null,
                              status: statusCtrl.text.isNotEmpty ? statusCtrl.text : null,
                            );
                            customerProvider.addCustomer(customer);
                            _clearAddForm();
                            setState(() {
                              selectedCustomer = null;
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
            _sectionTitle("📋  Customer List"),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: customerProvider.customers.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Center(child: Text("No customers found")),
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
                            label: Text("Contact Person", 
                                style: TextStyle(fontWeight: FontWeight.bold,
                                color: Colors.white)),
                          ),
                          DataColumn(
                            label: Text("Phone", 
                                style: TextStyle(fontWeight: FontWeight.bold,
                                color: Colors.white)),
                          ),
                          DataColumn(
                            label: Text("Email", 
                                style: TextStyle(fontWeight: FontWeight.bold,
                                color: Colors.white)),
                          ),
                          DataColumn(
                            label: Text("Address", 
                                style: TextStyle(fontWeight: FontWeight.bold,
                                color: Colors.white)),
                          ),
                          DataColumn(
                            label: Text("Tax ID", 
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
                        rows: customerProvider.customers.asMap().entries.map((entry) {
                          int index = entry.key;
                          Customer customer = entry.value;

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
                              DataCell(Text(customer.customerCode?.toString() ?? '')),
                              DataCell(Text(customer.customerName ?? '')),
                              DataCell(Text(customer.contactPerson ?? '')),
                              DataCell(Text(customer.phone ?? '')),
                              DataCell(Text(customer.email ?? '')),
                              DataCell(Text(customer.address ?? '')),
                              DataCell(Text(customer.taxId?.toString() ?? '')),
                              DataCell(Text(customer.status ?? '')),
                              DataCell(
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () {
                                    setState(() {
                                      selectedCustomer = customer;
                                      _loadUpdateForm(customer);
                                    });
                                  },
                                ),
                              ),
                              DataCell(
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    customerProvider.deleteCustomer(customer.id!);
                                    setState(() {
                                      selectedCustomer = null;
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
            if (selectedCustomer != null) ...[
              SizedBox(height: 20),
              _sectionTitle("✏️  Update Customer"),
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
                        _buildField("Customer Code", uCodeCtrl, TextInputType.number),
                        _buildField("Customer Name", uNameCtrl),
                        _buildField("Contact Person", uContactCtrl),
                        _buildField("Phone", uPhoneCtrl, TextInputType.phone),
                        _buildField("Email", uEmailCtrl, TextInputType.emailAddress),
                        _buildField("Address", uAddressCtrl),
                        _buildField("Tax ID", uTaxCtrl, TextInputType.number),
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
                              final customer = Customer(
                                id: selectedCustomer!.id,
                                customerCode: int.tryParse(uCodeCtrl.text),
                                customerName: uNameCtrl.text.isNotEmpty ? uNameCtrl.text : null,
                                contactPerson: uContactCtrl.text.isNotEmpty ? uContactCtrl.text : null,
                                phone: uPhoneCtrl.text.isNotEmpty ? uPhoneCtrl.text : null,
                                email: uEmailCtrl.text.isNotEmpty ? uEmailCtrl.text : null,
                                address: uAddressCtrl.text.isNotEmpty ? uAddressCtrl.text : null,
                                taxId: uTaxCtrl.text.isNotEmpty ? int.tryParse(uTaxCtrl.text) : null,
                                status: uStatusCtrl.text.isNotEmpty ? uStatusCtrl.text : null,
                              );
                              customerProvider.updateCustomer(customer);
                              setState(() {
                                selectedCustomer = null;
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
    codeCtrl.clear();
    nameCtrl.clear();
    contactCtrl.clear();
    phoneCtrl.clear();
    emailCtrl.clear();
    addressCtrl.clear();
    taxCtrl.clear();
    statusCtrl.clear();
  }

  void _loadUpdateForm(Customer customer) {
    uCodeCtrl.text = customer.customerCode?.toString() ?? '';
    uNameCtrl.text = customer.customerName ?? '';
    uContactCtrl.text = customer.contactPerson ?? '';
    uPhoneCtrl.text = customer.phone ?? '';
    uEmailCtrl.text = customer.email ?? '';
    uAddressCtrl.text = customer.address ?? '';
    uTaxCtrl.text = customer.taxId?.toString() ?? '';
    uStatusCtrl.text = customer.status ?? '';
  }
}