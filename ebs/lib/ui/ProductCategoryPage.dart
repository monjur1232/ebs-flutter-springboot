import 'package:ebs/model/ProductCategory.dart';
import 'package:ebs/provider/ProductCategoryProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductCategoryPage extends StatefulWidget {
  @override
  State<ProductCategoryPage> createState() => _ProductCategoryPageState();
}

class _ProductCategoryPageState extends State<ProductCategoryPage> {
  final _addFormKey = GlobalKey<FormState>();
  final _updateFormKey = GlobalKey<FormState>();

  // Controllers for Add Form
  final codeCtrl = TextEditingController();
  final nameCtrl = TextEditingController();
  final descCtrl = TextEditingController();

  // Update Form
  ProductCategory? selectedCategory;
  final uCodeCtrl = TextEditingController();
  final uNameCtrl = TextEditingController();
  final uDescCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => context.read<ProductCategoryProvider>().fetchProductCategories());
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = context.watch<ProductCategoryProvider>();

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 240, 240),
      appBar: AppBar(
        title: Text("Product Category Management"),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ---------------- Add Section ----------------
            _sectionTitle("➕  Add a New Product Category"),
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
                      _buildField("Product Category Code", codeCtrl, TextInputType.number),
                      _buildField("Product Category Name", nameCtrl),
                      _buildField("Description", descCtrl),
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
                            final category = ProductCategory(
                              productCategoryCode: int.tryParse(codeCtrl.text),
                              productCategoryName: nameCtrl.text.isNotEmpty ? nameCtrl.text : null,
                              description: descCtrl.text.isNotEmpty ? descCtrl.text : null,
                            );
                            context.read<ProductCategoryProvider>().addProductCategory(category);
                            _clearAddForm();
                            setState(() {
                              selectedCategory = null;
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
            _sectionTitle("📋  Product Category List"),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: categoryProvider.productCategories.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Center(child: Text("No product categories found")),
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
                        rows: categoryProvider.productCategories.asMap().entries.map((entry) {
                          int index = entry.key;
                          ProductCategory cat = entry.value;

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
                              DataCell(Text(cat.productCategoryCode?.toString() ?? '')),
                              DataCell(Text(cat.productCategoryName ?? '')),
                              DataCell(Text(cat.description ?? '')),
                              DataCell(
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                  tooltip: "Edit",
                                  onPressed: () {
                                    setState(() {
                                      selectedCategory = cat;
                                      _loadUpdateForm(cat);
                                    });
                                  },
                                ),
                              ),
                              DataCell(
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  tooltip: "Delete",
                                  onPressed: () {
                                    context.read<ProductCategoryProvider>().deleteProductCategory(cat.id!);
                                    setState(() {
                                      selectedCategory = null;
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
            if (selectedCategory != null) ...[
              SizedBox(height: 20),
              _sectionTitle("✏️  Update Product Category"),
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
                        _buildField("Product Category Code", uCodeCtrl, TextInputType.number),
                        _buildField("Product Category Name", uNameCtrl),
                        _buildField("Description", uDescCtrl),
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
                              final category = ProductCategory(
                                id: selectedCategory!.id,
                                productCategoryCode: int.tryParse(uCodeCtrl.text),
                                productCategoryName: uNameCtrl.text.isNotEmpty ? uNameCtrl.text : null,
                                description: uDescCtrl.text.isNotEmpty ? uDescCtrl.text : null,
                              );
                              context.read<ProductCategoryProvider>().updateProductCategory(category);
                              setState(() {
                                selectedCategory = null;
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
      [TextInputType type = TextInputType.text, int maxLines = 1]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        maxLines: maxLines,
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
    descCtrl.clear();
  }

  void _loadUpdateForm(ProductCategory cat) {
    uCodeCtrl.text = cat.productCategoryCode?.toString() ?? '';
    uNameCtrl.text = cat.productCategoryName ?? '';
    uDescCtrl.text = cat.description ?? '';
  }
}