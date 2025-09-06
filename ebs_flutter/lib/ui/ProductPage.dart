import 'package:ebs/model/Product.dart';
import 'package:ebs/provider/ProductProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductPage extends StatefulWidget {
  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final _addFormKey = GlobalKey<FormState>();
  final _updateFormKey = GlobalKey<FormState>();

  // Controllers for Add Form
  final codeCtrl = TextEditingController();
  final nameCtrl = TextEditingController();
  final catCodeCtrl = TextEditingController();
  final catNameCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final reorderCtrl = TextEditingController();
  final statusCtrl = TextEditingController();

  // Update Form
  Product? selectedProduct;
  final uCodeCtrl = TextEditingController();
  final uNameCtrl = TextEditingController();
  final uCatCodeCtrl = TextEditingController();
  final uCatNameCtrl = TextEditingController();
  final uDescCtrl = TextEditingController();
  final uReorderCtrl = TextEditingController();
  final uStatusCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => context.read<ProductProvider>().fetchProducts()); // Load data once
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 240, 240),
      appBar: AppBar(
        title: Text("Product Management"),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ---------------- Add Section ----------------
            _sectionTitle("➕  Add a New Product"),
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
                      _buildField("Product Code", codeCtrl, TextInputType.number),
                      _buildField("Product Name", nameCtrl),
                      _buildField("Product Category Code", catCodeCtrl, TextInputType.number),
                      _buildField("Product Category Name", catNameCtrl),
                      _buildField("Description", descCtrl),
                      _buildField("Reorder Level", reorderCtrl),
                      _buildField("Status", statusCtrl),
                      SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity, // full width
                        child: ElevatedButton.icon(
                          icon: Icon(Icons.save, color: const Color.fromARGB(255, 255, 255, 255)),
                          label: Text(
                            "Save",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 2, 111, 9),
                            padding: EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () {
                            final product = Product(
                              productCode: int.tryParse(codeCtrl.text),
                              productName: nameCtrl.text.isNotEmpty ? nameCtrl.text : null,
                              productCategoryCode: catCodeCtrl.text.isNotEmpty
                                  ? int.tryParse(catCodeCtrl.text)
                                  : null,
                              productCategoryName: catNameCtrl.text.isNotEmpty ? catNameCtrl.text : null,
                              description: descCtrl.text.isNotEmpty ? descCtrl.text : null,
                              reorderLevel: reorderCtrl.text.isNotEmpty ? reorderCtrl.text : null,
                              status: statusCtrl.text.isNotEmpty ? statusCtrl.text : null,
                            );
                            context.read<ProductProvider>().addProduct(product);
                            _clearAddForm();
                            setState(() {
                              selectedProduct = null;
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
            _sectionTitle("📋  Product List"),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: productProvider.products.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Center(child: Text("No products found")),
                    )
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        headingRowColor: MaterialStateProperty.all(
                            const Color.fromARGB(255, 203, 17, 17)),
                        columnSpacing: 12, // Reduced spacing
                        dividerThickness: 1,
                        border: TableBorder.all(color: const Color.fromARGB(255, 189, 189, 189), width: 1),
                        columns: const [
                          DataColumn(
                            label: Text("Product Code", 
                                style: TextStyle(fontWeight: FontWeight.bold,
                                color: Colors.white)
                                ),
                          ),
                          DataColumn(
                            label: Text("Product Name",
                                style: TextStyle(fontWeight: FontWeight.bold,
                                color: Colors.white)
                                ),
                          ),
                          DataColumn(
                            label: Text("Product Category Code",
                                style: TextStyle(fontWeight: FontWeight.bold,
                                color: Colors.white)
                                ),
                          ),
                          DataColumn(
                            label: Text("Product Category Name",
                                style: TextStyle(fontWeight: FontWeight.bold,
                                color: Colors.white)
                                ),
                          ),
                          DataColumn(
                            label: Text("Description",
                                style: TextStyle(fontWeight: FontWeight.bold,
                                color: Colors.white)
                                ),
                          ),
                          DataColumn(
                            label: Text("Reorder Level",
                                style: TextStyle(fontWeight: FontWeight.bold,
                                color: Colors.white)
                                ),
                          ),
                          DataColumn(
                            label: Text("Status",
                                style: TextStyle(fontWeight: FontWeight.bold,
                                color: Colors.white)
                                ),
                          ),
                          DataColumn(
                            label: Text("Edit",
                                style: TextStyle(fontWeight: FontWeight.bold,
                                color: Colors.white)
                                ),
                          ),
                          DataColumn(
                            label: Text("Delete",
                                style: TextStyle(fontWeight: FontWeight.bold,
                                color: Colors.white)
                                ),
                          ),
                        ],
                        rows: productProvider.products.asMap().entries.map((entry) {
                          int index = entry.key;
                          Product product = entry.value;

                          return DataRow(
                            color: MaterialStateProperty.resolveWith<Color?>(
                              (Set<MaterialState> states) {
                                if (index % 2 == 0) {
                                  return const Color.fromARGB(255, 238, 236, 236);
                                }
                                return null;
                              },
                            ),
                            cells: [
                              DataCell(Text(product.productCode?.toString() ?? '')),
                              DataCell(Text(product.productName ?? '')),
                              DataCell(Text(product.productCategoryCode?.toString() ?? '')),
                              DataCell(Text(product.productCategoryName ?? '')),
                              DataCell(Text(product.description ?? '')),
                              DataCell(Text(product.reorderLevel ?? '')),
                              DataCell(Text(product.status ?? '')),
                              DataCell(
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                  tooltip: "Edit",
                                  onPressed: () {
                                    setState(() {
                                      selectedProduct = product;
                                      _loadUpdateForm(product);
                                    });
                                  },
                                ),
                              ),
                              DataCell(
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  tooltip: "Delete",
                                  onPressed: () {
                                    context.read<ProductProvider>().deleteProduct(product.id!);
                                    setState(() {
                                      selectedProduct = null;
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
            if (selectedProduct != null) ...[
              SizedBox(height: 20),
              _sectionTitle("✏️  Update Product"),
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
                        _buildField("Product Code", uCodeCtrl, TextInputType.number),
                        _buildField("Product Name", uNameCtrl),
                        _buildField("Product Category Code", uCatCodeCtrl, TextInputType.number),
                        _buildField("Product Category Name", uCatNameCtrl),
                        _buildField("Description", uDescCtrl),
                        _buildField("Reorder Level", uReorderCtrl),
                        _buildField("Status", uStatusCtrl),
                        SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity, // full width
                          child: ElevatedButton.icon(
                            icon: Icon(Icons.update, color: const Color.fromARGB(255, 255, 255, 255)),
                            label: Text(
                              "Update",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 4, 8, 125),
                              padding: EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: () {
                              final product = Product(
                                id: selectedProduct!.id,
                                productCode: int.tryParse(uCodeCtrl.text),
                                productName: uNameCtrl.text.isNotEmpty ? uNameCtrl.text : null,
                                productCategoryCode: uCatCodeCtrl.text.isNotEmpty ? int.tryParse(uCatCodeCtrl.text) : null,
                                productCategoryName: uCatNameCtrl.text.isNotEmpty ? uCatNameCtrl.text : null,
                                description: uDescCtrl.text.isNotEmpty ? uDescCtrl.text : null,
                                reorderLevel: uReorderCtrl.text.isNotEmpty ? uReorderCtrl.text : null,
                                status: uStatusCtrl.text.isNotEmpty ? uStatusCtrl.text : null,
                              );
                              context.read<ProductProvider>().updateProduct(product);
                              setState(() {
                                selectedProduct = null;
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

  /// ---------------- Helpers ----------------
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
    catCodeCtrl.clear();
    catNameCtrl.clear();
    descCtrl.clear();
    reorderCtrl.clear();
    statusCtrl.clear();
  }

  void _loadUpdateForm(Product product) {
    uCodeCtrl.text = product.productCode?.toString() ?? '';
    uNameCtrl.text = product.productName ?? '';
    uCatCodeCtrl.text = product.productCategoryCode?.toString() ?? '';
    uCatNameCtrl.text = product.productCategoryName ?? '';
    uDescCtrl.text = product.description ?? '';
    uReorderCtrl.text = product.reorderLevel ?? '';
    uStatusCtrl.text = product.status ?? '';
  }
}