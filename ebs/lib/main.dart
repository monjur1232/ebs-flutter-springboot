import 'package:ebs/provider/AttendanceProvider.dart';
import 'package:ebs/provider/CustomerProvider.dart';
import 'package:ebs/provider/DepartmentProvider.dart';
import 'package:ebs/provider/DesignationProvider.dart';
import 'package:ebs/provider/EmployeeProvider.dart';
import 'package:ebs/provider/InventoryProvider.dart';
import 'package:ebs/provider/PaymentProvider.dart';
import 'package:ebs/provider/ProductCategoryProvider.dart';
import 'package:ebs/provider/ProductProvider.dart';
import 'package:ebs/provider/ProfitAndLossProvider.dart';
import 'package:ebs/provider/PurchaseOrderProvider.dart';
import 'package:ebs/provider/ReturnProvider.dart';
import 'package:ebs/provider/SalaryStructureProvider.dart';
import 'package:ebs/provider/SalesOrderProvider.dart';
import 'package:ebs/provider/SalesPaymentProvider.dart';
import 'package:ebs/provider/SalesReturnProvider.dart';
import 'package:ebs/provider/SupplierProvider.dart';
import 'package:ebs/ui/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => EmployeeProvider()),
        ChangeNotifierProvider(create: (_) => DepartmentProvider()),
        ChangeNotifierProvider(create: (_) => DesignationProvider()),
        ChangeNotifierProvider(create: (_) => ProductCategoryProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => SupplierProvider()),
        ChangeNotifierProvider(create: (_) => PurchaseOrderProvider()),
        ChangeNotifierProvider(create: (_) => ReturnProvider()),
        ChangeNotifierProvider(create: (_) => PaymentProvider()),
        ChangeNotifierProvider(create: (_) => CustomerProvider()),
        ChangeNotifierProvider(create: (_) => SalesOrderProvider()),
        ChangeNotifierProvider(create: (_) => SalesReturnProvider()),
        ChangeNotifierProvider(create: (_) => SalesPaymentProvider()),
        ChangeNotifierProvider(create: (_) => SalaryStructureProvider()),
        ChangeNotifierProvider(create: (_) => AttendanceProvider()),
        ChangeNotifierProvider(create: (_) => InventoryProvider()),
        ChangeNotifierProvider(create: (_) => ProfitAndLossProvider()),
        // Another Provider
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Home(),
      ),
    );
  }
}