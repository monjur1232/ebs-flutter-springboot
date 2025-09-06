import 'package:ebs/ui/AttendancePage.dart';
import 'package:ebs/ui/CustomerPage.dart';
import 'package:ebs/ui/DepartmentPage.dart';
import 'package:ebs/ui/DesignationPage.dart';
import 'package:ebs/ui/EmployeePage.dart';
import 'package:ebs/ui/InventoryPage.dart';
import 'package:ebs/ui/PaymentPage.dart';
import 'package:ebs/ui/ProductCategoryPage.dart';
import 'package:ebs/ui/ProductPage.dart';
import 'package:ebs/ui/ProfitAndLossPage.dart';
import 'package:ebs/ui/PurchaseOrderPage.dart';
import 'package:ebs/ui/ReturnPage.dart';
// import 'package:ebs/ui/SalaryStructurePage.dart';
import 'package:ebs/ui/SalesOrderPage.dart';
import 'package:ebs/ui/SalesPaymentPage.dart';
import 'package:ebs/ui/SalesReturnPage.dart';
import 'package:ebs/ui/SupplierPage.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Main Title
              const Text(
                "Enterprise Business Solutions",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 125, 2, 119),
                ),
              ),

              // Company Name
              const Text(
                "Ha-Meem Group",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 184, 12, 47),
                ),
              ),
              const SizedBox(height: 24),

              // Employee Management Card
              _buildManagementCard(
                title: "Employee Management",
                buttons: [
                  _buildButton(
                    context: context,
                    text: "Department",
                    color: const Color.fromARGB(255, 7, 118, 44),
                    destination: DepartmentPage(),
                  ),
                  const SizedBox(height: 13),
                  _buildButton(
                    context: context,
                    text: "Designation",
                    color: const Color.fromARGB(255, 15, 31, 133),
                    destination: DesignationPage(),
                  ),
                  // const SizedBox(height: 13),
                  // _buildButton(
                  //   context: context,
                  //   text: "Salary Structure",
                  //   color: const Color.fromARGB(255, 200, 8, 120),
                  //   destination: SalaryStructurePage(),
                  // ),
                  const SizedBox(height: 13),
                  _buildButton(
                    context: context,
                    text: "Employee",
                    color: const Color.fromARGB(255, 141, 41, 18),
                    destination: EmployeePage(),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // HR Management Card
              _buildManagementCard(
                title: "HR Management",
                buttons: [
                  _buildButton(
                    context: context,
                    text: "Attendance",
                    color: const Color.fromARGB(255, 126, 9, 101),
                    destination: AttendancePage(),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Product Management Card
              _buildManagementCard(
                title: "Product Management",
                buttons: [
                  _buildButton(
                    context: context,
                    text: "Product Category",
                    color: const Color.fromARGB(255, 9, 113, 57),
                    destination: ProductCategoryPage(),
                  ),
                  const SizedBox(height: 13),
                  _buildButton(
                    context: context,
                    text: "Product",
                    color: const Color.fromARGB(255, 26, 23, 178),
                    destination: ProductPage(),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Purchase Management Card
              _buildManagementCard(
                title: "Purchase Management",
                buttons: [
                  _buildButton(
                    context: context,
                    text: "Supplier",
                    color: const Color.fromARGB(255, 111, 10, 111),
                    destination: SupplierPage(),
                  ),
                  const SizedBox(height: 13),
                  _buildButton(
                    context: context,
                    text: "Purchase Order",
                    color: const Color.fromARGB(255, 125, 10, 37),
                    destination: PurchaseOrderPage(),
                  ),
                  const SizedBox(height: 13),
                  _buildButton(
                    context: context,
                    text: "Return",
                    color: const Color.fromARGB(255, 34, 176, 18),
                    destination: ReturnPage(),
                  ),
                  const SizedBox(height: 13),
                  _buildButton(
                    context: context,
                    text: "Payment",
                    color: const Color.fromARGB(255, 15, 32, 140),
                    destination: PaymentPage(),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Sales Management Card
              _buildManagementCard(
                title: "Sales Management",
                buttons: [
                  _buildButton(
                    context: context,
                    text: "Customer",
                    color: const Color.fromARGB(255, 132, 14, 25),
                    destination: CustomerPage(),
                  ),
                  const SizedBox(height: 13),
                  _buildButton(
                    context: context,
                    text: "Sales Order",
                    color: const Color.fromARGB(255, 3, 83, 103),
                    destination: SalesOrderPage(),
                  ),
                  const SizedBox(height: 13),
                  _buildButton(
                    context: context,
                    text: "Sales Return",
                    color: const Color.fromARGB(255, 8, 136, 32),
                    destination: SalesReturnPage(),
                  ),
                  const SizedBox(height: 13),
                  _buildButton(
                    context: context,
                    text: "Sales Payment",
                    color: const Color.fromARGB(255, 13, 30, 147),
                    destination: SalesPaymentPage(),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Inventory Management Card
              _buildManagementCard(
                title: "Inventory Management",
                buttons: [
                  _buildButton(
                    context: context,
                    text: "Inventory",
                    color: const Color.fromARGB(255, 130, 11, 48),
                    destination: InventoryPage(),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Financial Reports Management Card
              _buildManagementCard(
                title: "Financial Reports",
                buttons: [
                  _buildButton(
                    context: context,
                    text: "Profit And Loss",
                    color: const Color.fromARGB(255, 133, 4, 142),
                    destination: ProfitAndLossPage(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildManagementCard({
    required String title,
    required List<Widget> buttons,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5D4037),
                ),
              ),
            ),
            ...buttons,
          ],
        ),
      ),
    );
  }

  Widget _buildButton({
    required BuildContext context,
    required String text,
    required Color color,
    required Widget destination,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destination),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}