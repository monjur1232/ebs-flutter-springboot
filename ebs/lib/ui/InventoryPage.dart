import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ebs/model/Inventory.dart';
import 'package:ebs/provider/InventoryProvider.dart';

class InventoryPage extends StatefulWidget {
  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => 
      Provider.of<InventoryProvider>(context, listen: false).fetchInventory());
  }

  @override
  Widget build(BuildContext context) {
    final inventoryProvider = Provider.of<InventoryProvider>(context);

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 240, 240),
      appBar: AppBar(
        title: Text("Inventory Management"),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildHeader(),
            SizedBox(height: 20),
            _buildInventoryTable(inventoryProvider.inventories),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Text(
      "Inventory Summary",
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.blueGrey[800],
      ),
    );
  }

  Widget _buildInventoryTable(List<Inventory> inventories) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: inventories.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(child: Text("No inventory data found")),
            )
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: MaterialStateProperty.all(const Color.fromARGB(255, 12, 5, 136)),
                columnSpacing: 12,
                dividerThickness: 1,
                border: TableBorder.all(color: Colors.grey, width: 1),
                columns: const [
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
                    label: Text("Purchased", 
                        style: TextStyle(fontWeight: FontWeight.bold,
                        color: Colors.white)),
                  ),
                  DataColumn(
                    label: Text("Returned to Supplier", 
                        style: TextStyle(fontWeight: FontWeight.bold,
                        color: Colors.white)),
                  ),
                  DataColumn(
                    label: Text("Sold", 
                        style: TextStyle(fontWeight: FontWeight.bold,
                        color: Colors.white)),
                  ),
                  DataColumn(
                    label: Text("Returned from Customer", 
                        style: TextStyle(fontWeight: FontWeight.bold,
                        color: Colors.white)),
                  ),
                  DataColumn(
                    label: Text("Available", 
                        style: TextStyle(fontWeight: FontWeight.bold,
                        color: Colors.white)),
                        columnWidth: FixedColumnWidth(130),
                  ),
                  DataColumn(
                    label: Text("Reorder Level", 
                        style: TextStyle(fontWeight: FontWeight.bold,
                        color: Colors.white)),
                  ),
                ],
                rows: inventories.map((inventory) {
                  return DataRow(
                    cells: [
                      DataCell(Text(inventory.productCode?.toString() ?? 'N/A')),
                      DataCell(Text(inventory.productName ?? 'N/A')),
                      DataCell(Text(inventory.purchasedQuantity.toString())),
                      DataCell(Text(inventory.returnedToSupplier.toString())),
                      DataCell(Text(inventory.soldQuantity.toString())),
                      DataCell(Text(inventory.returnedFromCustomer.toString())),
                      DataCell(
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(inventory.availableQuantity.toString()),
                            SizedBox(width: 8),
                            _buildStockStatusBadge(inventory),
                          ],
                        ),
                      ),
                      DataCell(Text(inventory.reorderLevel.toString())),
                    ],
                  );
                }).toList(),
              ),
            ),
    );
  }

  Widget _buildStockStatusBadge(Inventory inventory) {
    final reorderLevelStr = inventory.reorderLevel?.replaceAll(RegExp(r'[^0-9.]'), '') ?? '0';
    final reorderLevel = double.tryParse(reorderLevelStr)?.toInt() ?? 0;

    if (inventory.availableQuantity <= 0) {
      return _buildStatusBadge("Out of Stock", Colors.red);
    } else if (inventory.availableQuantity <= reorderLevel) {
      return _buildStatusBadge("Low Stock", Colors.orange);
    } else {
      return _buildStatusBadge("In Stock", Colors.green);
    }
  }

  Widget _buildStatusBadge(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }
}