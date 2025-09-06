import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ebs/provider/ProfitAndLossProvider.dart';
// import 'package:ebs/model/ProfitAndLoss.dart';

class ProfitAndLossPage extends StatefulWidget {
  @override
  _ProfitAndLossPageState createState() => _ProfitAndLossPageState();
}

class _ProfitAndLossPageState extends State<ProfitAndLossPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProfitAndLossProvider>(context, listen: false)
          .fetchProfitAndLossData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProfitAndLossProvider>(context);
    final data = provider.profitAndLossData;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profit & Loss Analysis'),
        centerTitle: true,
      ),
      body: data == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  // Purchase and Sales Tables Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Purchase Table
                      Expanded(
                        child: Card(
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  'Purchase Records',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green[800],
                                  ),
                                ),
                                SizedBox(height: 8),
                                TextField(
                                  decoration: InputDecoration(
                                    labelText: 'Search Purchases',
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.search),
                                  ),
                                  onChanged: provider.setPurchaseSearchTerm,
                                ),
                                SizedBox(height: 8),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: DataTable(
                                    headingRowColor: MaterialStateProperty.all(const Color.fromARGB(255, 229, 194, 203)),
                                    columns: [
                                      DataColumn(label: Text('Product')),
                                      DataColumn(label: Text('Supplier')),
                                      DataColumn(label: Text('Unit Price')),
                                      DataColumn(label: Text('Qty')),
                                      DataColumn(label: Text('Total')),
                                    ],
                                    rows: provider.filteredPurchases.map((p) {
                                      return DataRow(cells: [
                                        DataCell(Text(p.productName ?? '')),
                                        DataCell(Text(p.supplierName ?? '')),
                                        DataCell(Text(p.unitPrice?.toStringAsFixed(2) ?? '')),
                                        DataCell(Text(p.purchaseQuantity?.toString() ?? '')),
                                        DataCell(Text(p.totalAmount?.toStringAsFixed(2) ?? '')),
                                      ]);
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      // Sales Table
                      Expanded(
                        child: Card(
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  'Sales Records',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue[800],
                                  ),
                                ),
                                SizedBox(height: 8),
                                TextField(
                                  decoration: InputDecoration(
                                    labelText: 'Search Sales',
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.search),
                                  ),
                                  onChanged: provider.setSalesSearchTerm,
                                ),
                                SizedBox(height: 8),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: DataTable(
                                    headingRowColor: MaterialStateProperty.all(const Color.fromARGB(255, 229, 194, 203)),
                                    columns: [
                                      DataColumn(label: Text('Product')),
                                      DataColumn(label: Text('Customer')),
                                      DataColumn(label: Text('Unit Price')),
                                      DataColumn(label: Text('Qty')),
                                      DataColumn(label: Text('Total')),
                                    ],
                                    rows: provider.filteredSales.map((s) {
                                      return DataRow(cells: [
                                        DataCell(Text(s.productName ?? '')),
                                        DataCell(Text(s.customerName ?? '')),
                                        DataCell(Text(s.unitPrice?.toStringAsFixed(2) ?? '')),
                                        DataCell(Text(s.salesQuantity?.toString() ?? '')),
                                        DataCell(Text(s.totalAmount?.toStringAsFixed(2) ?? '')),
                                      ]);
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  // Summary Section
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            'Profit & Loss Summary',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16),
                          // Total Summary Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildSummaryCard(
                                'Total Purchase',
                                '৳${data.totalPurchase.toStringAsFixed(2)}',
                                Colors.red,
                              ),
                              _buildSummaryCard(
                                'Total Sales',
                                '৳${data.totalSales.toStringAsFixed(2)}',
                                Colors.blue,
                              ),
                              _buildSummaryCard(
                                'Profit / Loss',
                                '৳${data.profitOrLoss.toStringAsFixed(2)}',
                                data.profitOrLoss >= 0 ? Colors.green : Colors.red,
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Divider(),
                          SizedBox(height: 16),
                          // Product-wise Summary
                          Text(
                            'Product-wise Summary',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 167, 24, 136),
                            ),
                          ),
                          SizedBox(height: 8),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columns: [
                                DataColumn(
                                  label: SizedBox(
                                    width: 150, // Product column এর প্রস্থ
                                    child: Text(
                                      'Product',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: SizedBox(
                                    width: 120, // Purchase column এর প্রস্থ
                                    child: Text(
                                      'Purchase',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: SizedBox(
                                    width: 120, // Sales column এর প্রস্থ
                                    child: Text(
                                      'Sales',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: SizedBox(
                                    width: 130, // Profit/Loss column এর প্রস্থ
                                    child: Text(
                                      'Profit/Loss',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                              rows: data.productSummary.entries.map((entry) {
                                final profitLoss = entry.value.sales - entry.value.purchase;
                                return DataRow(cells: [
                                  DataCell(Text(entry.key)),
                                  DataCell(Text('৳${entry.value.purchase.toStringAsFixed(2)}')),
                                  DataCell(Text('৳${entry.value.sales.toStringAsFixed(2)}')),
                                  DataCell(Text(
                                    '৳${profitLoss.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      color: profitLoss >= 0 ? Colors.green : Colors.red,
                                    ),
                                  )),
                                ]);
                              }).toList(),
                            ),

                          ),
                          SizedBox(height: 16),
                          Divider(),
                          SizedBox(height: 16),
                          // Supplier & Customer Summary
                          Text(
                            'Supplier & Customer Summary',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 196, 55, 74),
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      'Supplier-wise Purchase',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green[800],
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    ...data.supplierWisePurchase.entries.map((entry) {
                                      return ListTile(
                                        title: Text(entry.key),
                                        trailing: Text('৳${entry.value.toStringAsFixed(2)}'),
                                      );
                                    }).toList(),
                                  ],
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      'Customer-wise Sales',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue[800],
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    ...data.customerWiseSales.entries.map((entry) {
                                      return ListTile(
                                        title: Text(entry.key),
                                        trailing: Text('৳${entry.value.toStringAsFixed(2)}'),
                                      );
                                    }).toList(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Divider(),
                          SizedBox(height: 16),
                          // Count Summary
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    'Total Suppliers',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    data.supplierCount.toString(),
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    'Total Customers',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    data.customerCount.toString(),
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildSummaryCard(String title, String value, Color color) {
    return Card(
      color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}