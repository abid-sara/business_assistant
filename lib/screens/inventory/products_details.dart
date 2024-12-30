import 'package:business_assistant/cubits/product/product_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:business_assistant/cubits/product/product_cubit.dart';
import 'package:business_assistant/models/product.dart';
import 'package:business_assistant/style/colors.dart';
import 'package:business_assistant/style/text.dart';

class ItemDetails extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _unitPriceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _minQuantityController = TextEditingController();
  final TextEditingController _supplierNameController = TextEditingController();
  final TextEditingController _supplierPhoneController =
      TextEditingController();
  final TextEditingController _supplierAddressController =
      TextEditingController();

  ItemDetails({super.key});

  void _populateFields(Product product) {
    _nameController.text = product.name;
    _unitPriceController.text = product.unitPrice.toString();
    _descriptionController.text = product.productDescription;
    _quantityController.text = product.quantity.toString();
    _minQuantityController.text = product.minimumQuantity.toString();
    _supplierNameController.text = product.supplierName;
    _supplierPhoneController.text = product.supplierPhoneNum;
    _supplierAddressController.text = product.supplierAddress;
  }

  void _showEditDialog(BuildContext context, Product product) {
    _populateFields(product);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocConsumer<ProductCubit, ProductState>(
          listener: (context, state) {
            if (state is ProductUpdated) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Updated successfully")));
            } else if (state is ProductError) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text("Update failed")));
            }
          },
          builder: (context, state) {
            return AlertDialog(
              title: const Text('Edit Product'),
              content: SingleChildScrollView(
                child: Form(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration:
                            const InputDecoration(labelText: 'Item name'),
                      ),
                      TextFormField(
                        controller: _unitPriceController,
                        decoration:
                            const InputDecoration(labelText: 'Item unit price'),
                        keyboardType: TextInputType.number,
                      ),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                            labelText: 'Item description'),
                      ),
                      TextFormField(
                        controller: _quantityController,
                        decoration:
                            const InputDecoration(labelText: 'Item quantity'),
                        keyboardType: TextInputType.number,
                      ),
                      TextFormField(
                        controller: _minQuantityController,
                        decoration: const InputDecoration(
                            labelText: 'Item minimum quantity'),
                        keyboardType: TextInputType.number,
                      ),
                      TextFormField(
                        controller: _supplierNameController,
                        decoration:
                            const InputDecoration(labelText: 'Supplier name'),
                      ),
                      TextFormField(
                        controller: _supplierPhoneController,
                        decoration:
                            const InputDecoration(labelText: 'Supplier phone'),
                      ),
                      TextFormField(
                        controller: _supplierAddressController,
                        decoration: const InputDecoration(
                            labelText: 'Supplier address'),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    final id = product.id;
                    final updatedProduct = product.copyWith(
                      id: product.id,
                      name: _nameController.text,
                      unitPrice:
                          double.tryParse(_unitPriceController.text) ?? 0.0,
                      productDescription: _descriptionController.text,
                      quantity: int.tryParse(_quantityController.text) ?? 0,
                      minimumQuantity:
                          int.tryParse(_minQuantityController.text) ?? 0,
                      supplierName: _supplierNameController.text,
                      supplierPhoneNum: _supplierPhoneController.text,
                      supplierAddress: _supplierAddressController.text,
                    );

                    context
                        .read<ProductCubit>()
                        .updateProduct(id, updatedProduct);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductCubit, ProductState>(
      listener: (context, state) {
        if (state is ProductLoaded) {
          // Refresh the product data when state updates
          final updatedProduct = state.products.firstWhere(
            (p) =>
                p.id ==
                (ModalRoute.of(context)?.settings.arguments as Product).id,
            orElse: () => ModalRoute.of(context)?.settings.arguments as Product,
          );
        }
      },
      builder: (context, state) {
        final originalProduct =
            ModalRoute.of(context)!.settings.arguments as Product;
        Product displayProduct = originalProduct;

        if (state is ProductUpdated &&
            state.updatedProduct.id == originalProduct.id) {
          displayProduct = state.updatedProduct;
        } else if (state is ProductLoaded) {
          final updatedProduct = state.products.firstWhere(
            (p) => p.id == originalProduct.id,
            orElse: () => originalProduct,
          );
          displayProduct = updatedProduct;
        }
        return _buildScaffold(context, displayProduct);
      },
    );
  }

  Widget _buildScaffold(BuildContext context, Product product) {
    return Scaffold(
      appBar: AppBar(title: const Text("Product Details")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(108, 220, 220, 232),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: SizedBox(
                          width: 150,
                          height: 140,
                          child: Image.asset(product.productImage ??
                              'assets/images/default.png'),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(product.name,
                              style: const TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold)),
                          Text(product.productDescription, maxLines: 3),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.edit, color: Colors.grey),
                            label: const Text('Edit item',
                                style: TextStyle(color: Colors.grey)),
                            onPressed: () => _showEditDialog(context, product),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                              shadowColor: Colors.transparent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text("Item Information", style: title_style),
                _buildInfoBox("Item name", product.name),
                _buildInfoBox("Unit price", product.unitPrice.toString()),
                _buildInfoBox("Description", product.productDescription),
                Text("Inventory Information", style: title_style),
                _buildInfoBox("Item quantity", product.quantity.toString()),
                _buildInfoBox("Item minimum required quantity",
                    product.minimumQuantity.toString()),
                const SizedBox(height: 16),
                Text("Supplier Information", style: title_style),
                _buildInfoBox("Supplier name", product.supplierName),
                _buildInfoBox("Supplier phone", product.supplierPhoneNum),
                _buildInfoBox("Supplier address", product.supplierAddress),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoBox(String label, String value) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.lightGreen,
      ),
      child: Row(
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}
