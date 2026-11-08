
import 'package:flutter/material.dart';
import 'models/product.dart';
import 'services/api_service.dart';

class AddProductScreen extends StatefulWidget {
  final Product? product;

  const AddProductScreen({super.key, this.product});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final ApiService apiService = ApiService();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final categoryController = TextEditingController();
  final priceController = TextEditingController();
  final stockController = TextEditingController();
  final brandController = TextEditingController();

  bool isLoading = false;

  bool get isEditing => widget.product != null;

  @override
  void initState() {
    super.initState();

    final product = widget.product;

    if (product != null) {
      titleController.text = product.title;
      descriptionController.text = product.description;
      categoryController.text = product.category;
      priceController.text = product.price.toString();
      stockController.text = product.stock.toString();
      brandController.text = product.brand;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    categoryController.dispose();
    priceController.dispose();
    stockController.dispose();
    brandController.dispose();
    super.dispose();
  }

  Future<void> saveProduct() async {
    if (titleController.text.trim().isEmpty ||
        priceController.text.trim().isEmpty ||
        stockController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nama, harga, dan stok wajib diisi.'),
        ),
      );
      return;
    }

    final price = double.tryParse(priceController.text);
    final stock = int.tryParse(stockController.text);

    if (price == null || stock == null || price < 0 || stock < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harga atau stok tidak valid.'),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      if (isEditing) {
        await apiService.updateProduct(
          id: widget.product!.id,
          title: titleController.text.trim(),
          description: descriptionController.text.trim(),
          category: categoryController.text.trim(),
          price: price,
          stock: stock,
          brand: brandController.text.trim(),
        );
      } else {
        await apiService.createProduct(
          title: titleController.text.trim(),
          description: descriptionController.text.trim(),
          category: categoryController.text.trim(),
          price: price,
          stock: stock,
          brand: brandController.text.trim(),
        );
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEditing
                ? 'Produk berhasil diperbarui!'
                : 'Produk berhasil ditambahkan!',
          ),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan produk: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Widget buildField({
    required String label,
    required TextEditingController controller,
    String? hint,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Product' : 'Add Product'),
        backgroundColor: const Color(0xFFFFF8F5),
        foregroundColor: const Color(0xFF51434A),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            buildField(
              label: 'Product Name *',
              controller: titleController,
            ),
            buildField(
              label: 'Description',
              controller: descriptionController,
              maxLines: 3,
            ),
            buildField(
              label: 'Category',
              controller: categoryController,
            ),
            buildField(
              label: 'Price *',
              controller: priceController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
            buildField(
              label: 'Stock *',
              controller: stockController,
              keyboardType: TextInputType.number,
            ),
            buildField(
              label: 'Brand',
              controller: brandController,
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: isLoading ? null : saveProduct,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE8AEBB),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : Text(
                        isEditing ? 'Update Product' : 'Save Product',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
