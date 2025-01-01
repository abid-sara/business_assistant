// ignore_for_file: use_build_context_synchronously


import 'package:business_assistant/cubits/product/product_cubit.dart';
import 'package:business_assistant/models/expense.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:business_assistant/widget/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:business_assistant/style/text.dart';
import 'package:business_assistant/style/colors.dart';
import 'package:business_assistant/models/product.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import '../../cubits/product/product_state.dart';
import '../../cubits/product/validation_cubit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'package:business_assistant/cubits/expense/expense_cubit.dart';  



Future<String> saveImageToLocalStorage(String sourcePath) async {
  try {
    final Directory appDir = await getApplicationDocumentsDirectory();
    final String imagesDir = path.join(appDir.path, 'product_images');

    // Create images directory if it doesn't exist
    final Directory imagesDirFile = Directory(imagesDir);
    if (!await imagesDirFile.exists()) {
      await imagesDirFile.create(recursive: true);
    }

    // Generate unique filename using timestamp
    final String fileName =
        'product_${DateTime.now().millisecondsSinceEpoch}${path.extension(sourcePath)}';
    final String destinationPath = path.join(imagesDir, fileName);

    // Copy image file to app's local storage
    await File(sourcePath).copy(destinationPath);

    return destinationPath;
  } catch (e) {
    print('Error saving image: $e');
    return ''; // Return empty string if save fails
  }
}

class Inventory extends StatelessWidget {
  Inventory({super.key});

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _unitController = TextEditingController();
  final TextEditingController _unitPriceController = TextEditingController();
  final TextEditingController _supplierNameController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _supplierPhoneController =
      TextEditingController();
  final TextEditingController _supplierAddressController =
      TextEditingController();
  final TextEditingController _additionalInfoController =
      TextEditingController();
  final TextEditingController _minController = TextEditingController();

  void _clearForm() {
    _nameController.clear();
    _quantityController.clear();
    _unitController.clear();
    _unitPriceController.clear();
    _supplierNameController.clear();
    _supplierPhoneController.clear();
    _supplierAddressController.clear();
    _additionalInfoController.clear();
    _minController.clear();
  }

  Future<void> handleImagePicker(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      try {
        // Save image to local storage and get permanent path
        final String savedImagePath =
            await saveImageToLocalStorage(pickedFile.path);
        if (savedImagePath.isNotEmpty) {
          context.read<ValidationCubit>().updateImageInput(savedImagePath);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to save image')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error processing image: $e')),
        );
      }
    }
  }

  void _showAddItemDialog(BuildContext context, ProductCubit cubit) {
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocBuilder<ProductCubit, ProductState>(
          builder: (context, state) {
            return AlertDialog(
              title: const Text('Add Item'),
              content: SingleChildScrollView(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(
                          child:
                              Text("Product information", style: title_style),
                        ),
                        TextFormField(
                          controller: _nameController,
                          decoration:
                              const InputDecoration(labelText: 'Product name'),
                          validator: (value) => value?.isEmpty ?? true
                              ? 'Please enter a product name'
                              : null,
                        ),
                        TextFormField(
                          controller: _unitPriceController,
                          decoration:
                              const InputDecoration(labelText: 'Unit price'),
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d*\.?\d*$')),
                          ],
                          onChanged: (value) =>
                              BlocProvider.of<ValidationCubit>(context,
                                      listen: false)
                                  .validateUnitPrice(value),
                          validator: (value) {
                            final state = BlocProvider.of<ValidationCubit>(
                                    context,
                                    listen: false)
                                .state;
                            return state.unitPriceError.isEmpty
                                ? null
                                : state.unitPriceError;
                          },
                        ),
                        const SizedBox(height: 30),
                        Center(
                          child:
                              Text("Inventory information", style: title_style),
                        ),
                        TextFormField(
                          controller: _quantityController,
                          decoration: const InputDecoration(
                              labelText: 'Current Quantity'),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          onChanged: (value) =>
                              BlocProvider.of<ValidationCubit>(context,
                                      listen: false)
                                  .validateCurrentQuantity(value),
                          validator: (value) {
                            final state = BlocProvider.of<ValidationCubit>(
                                    context,
                                    listen: false)
                                .state;
                            return state.currentQuantityError.isEmpty
                                ? null
                                : state.currentQuantityError;
                          },
                        ),
                        TextFormField(
                          controller: _minController,
                          decoration: const InputDecoration(
                              labelText: 'Minimum quantity threshold'),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          onChanged: (value) =>
                              BlocProvider.of<ValidationCubit>(context,
                                      listen: false)
                                  .validateMinThreshold(value),
                          validator: (value) {
                            final state = BlocProvider.of<ValidationCubit>(
                                    context,
                                    listen: false)
                                .state;
                            return state.minThresholdError.isEmpty
                                ? null
                                : state.minThresholdError;
                          },
                        ),
                        const SizedBox(height: 30),
                        Center(
                          child:
                              Text("Supplier information", style: title_style),
                        ),
                        TextFormField(
                          controller: _supplierNameController,
                          decoration:
                              const InputDecoration(labelText: 'Supplier name'),
                          validator: (value) => value?.isEmpty ?? true
                              ? 'Please enter the supplier name'
                              : null,
                        ),
                        TextFormField(
                          controller: _supplierPhoneController,
                          decoration: const InputDecoration(
                              labelText: 'Supplier phone number'),
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          onChanged: (value) =>
                              BlocProvider.of<ValidationCubit>(context,
                                      listen: false)
                                  .validateSupplierPhoneNumber(value),
                          validator: (value) {
                            final state = BlocProvider.of<ValidationCubit>(
                                    context,
                                    listen: false)
                                .state;
                            return state.supplierPhoneError.isEmpty
                                ? null
                                : state.supplierPhoneError;
                          },
                        ),
                        TextFormField(
                          controller: _supplierAddressController,
                          decoration: const InputDecoration(
                              labelText: 'Supplier address'),
                          validator: (value) => value?.isEmpty ?? true
                              ? 'Please enter the supplier address'
                              : null,
                        ),
                        TextFormField(
                          controller: _additionalInfoController,
                          decoration: const InputDecoration(
                              labelText: 'Additional info'),
                        ),
                        const SizedBox(height: 30),
                        BlocBuilder<ValidationCubit, ValidationState>(
                          builder: (context, state) {
                            return Column(
                              children: [
                                const Text("Product's image",
                                    style: TextStyle(fontSize: 16)),
                                const SizedBox(height: 10),
                                Container(
                                  width: 150,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: state.imagePath.isNotEmpty
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.file(
                                            File(state.imagePath),
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return const Center(
                                                child: Icon(
                                                    Icons.image_not_supported,
                                                    size: 40),
                                              );
                                            },
                                          ),
                                        )
                                      : const Center(
                                          child: Icon(Icons.add_photo_alternate,
                                              size: 40),
                                        ),
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton.icon(
                                  onPressed: () => handleImagePicker(context),
                                  icon: const Icon(
                                    Icons.photo_library,
                                    color: Colors.white,
                                  ),
                                  label: Text(
                                    state.imagePath.isEmpty
                                        ? 'Select Image'
                                        : 'Change Image',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  style: const ButtonStyle(
                                    backgroundColor: WidgetStatePropertyAll(
                                        AppColors.darkGreen),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              actions: [
                TextButton(
  onPressed: () {
    Navigator.of(context).pop();
    _clearForm();
    context.read<ValidationCubit>().clearForm();
  },
  child: const Text(
    'Cancel',
    style: TextStyle(color: AppColors.darkGreen),
  ),
),

TextButton(
  onPressed: () {
    if (formKey.currentState!.validate()) {
      final newProduct = Product(
        name: _nameController.text,
        quantity: int.parse(_quantityController.text),
        productImage: context
                .read<ValidationCubit>()
                .state
                .imagePath
                .isNotEmpty
            ? context.read<ValidationCubit>().state.imagePath
            : "assets/images/default.png",
        unitPrice: double.parse(_unitPriceController.text),
        productDescription: _additionalInfoController.text,
        minimumQuantity: int.parse(_minController.text),
        deleted: false,
        supplierName: _supplierNameController.text,
        supplierPhoneNum: _supplierPhoneController.text,
        supplierAddress: _supplierAddressController.text,
      );

      // Print the product details being added
      print('Adding product: ${newProduct.toString()}');
      
      try {
        cubit.addProduct(newProduct);

        final newExpense = Expense(
          date: DateTime.now(),
          amount: newProduct.unitPrice * newProduct.quantity,
        );

        // Print the expense details being added
        print('Adding expense: Date: ${newExpense.date}, Amount: ${newExpense.amount}');

        final expenseCubit = context.read<ExpenseCubit>();
        expenseCubit.addExpense(newExpense);
        print('Product and expense added successfully');

        Navigator.of(context).pop();
        _clearForm();
        context.read<ValidationCubit>().clearForm();
      } catch (e) {
        print('Error: $e');
      }
    }
  },
  child: const Text(
    'Add',
    style: TextStyle(color: AppColors.darkGreen),
  ),
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
    return DefaultTabController(
      length: 3,
      child: BlocBuilder<ProductCubit, ProductState>(builder: (context, state) {
        final cubit = context.read<ProductCubit>();
        return Scaffold(
          drawer: const Sidebar(),
          appBar: AppBar(
            title: const Text("Inventory center"),
            backgroundColor: Colors.white,
            bottom: TabBar(
              onTap: (index) {
                String category = index == 1
                    ? 'High-stock'
                    : index == 2
                        ? 'Low-stock'
                        : 'All';
                cubit.filterProducts(_searchController.text, category);
              },
              tabs: const [
                Tab(text: 'All items'),
                Tab(text: 'High-stock'),
                Tab(text: 'Low-stock'),
              ],
              labelPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              indicator: const UnderlineTabIndicator(
                borderSide: BorderSide(
                    width: 4.0, color: Color.fromARGB(193, 169, 169, 199)),
                insets: EdgeInsets.symmetric(horizontal: 16.0),
              ),
              unselectedLabelColor: Colors.grey,
              labelColor: const Color.fromARGB(255, 30, 19, 19),
              indicatorPadding: const EdgeInsets.all(4),
            ),
          ),
          body: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/background.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              if (state is ProductLoading)
                const Center(child: CircularProgressIndicator())
              else if (state is ProductError)
                Center(child: Text(state.message))
              else
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          labelText: 'Search for an item',
                          prefixIcon: const Icon(Icons.search),
                          fillColor: AppColors.purpule,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                        ),
                        onChanged: (query) {
                          final currentTab =
                              DefaultTabController.of(context).index;
                          String category = currentTab == 1
                              ? 'High-stock'
                              : currentTab == 2
                                  ? 'Low-stock'
                                  : 'All';
                          cubit.filterProducts(query, category);
                        },
                      ),
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("Item", style: TextStyle(color: Colors.grey)),
                        Text("Stock-level",
                            style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                    Expanded(
                      child: _buildProductList(state),
                    ),
                    SizedBox(
                      width: 130,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.darkGreen,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                        ),
                        onPressed: () => _showAddItemDialog(context, cubit),
                        child: const Row(
                          children: [
                            Icon(Icons.add, color: Colors.white),
                            Text('Add Item',
                                style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                    Container(height: 70, color: Colors.white),
                  ],
                ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildProductList(ProductState state) {
    final List<Product> products;
    if (state is ProductLoaded) {
      products = state.products;
    } else if (state is ProductFiltered) {
      products = state.filteredProducts;
    } else {
      products = [];
    }

    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final item = products[index];
        return ItemLine(
          id: item.id,
          quantity: item.quantity,
          title: item.name,
          image: item.productImage ?? 'assets/images/default.png',
          itemObj: item,
          onDelete: (id) => context.read<ProductCubit>().deleteProduct(id),
        );
      },
    );
  }
}

class ItemLine extends StatelessWidget {
  final int? id;
  final int quantity;
  final String title;
  final String image;
  final Product itemObj;
  final Function(int?) onDelete;

  const ItemLine({
    super.key,
    this.id,
    required this.quantity,
    required this.title,
    required this.image,
    required this.itemObj,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: GestureDetector(
        onTap: () =>
            Navigator.pushNamed(context, '/itemDetails', arguments: itemObj),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.lightGreen,
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            leading: Container(
              margin: const EdgeInsets.all(3),
              width: 100,
              height: 100,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: image.startsWith('assets/')
                    ? Image.asset(
                        image,
                        fit: BoxFit.cover,
                        width: 100,
                        height: 100,
                      )
                    : Image.file(
                        File(image),
                        fit: BoxFit.cover,
                        width: 100,
                        height: 100,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/images/default.png',
                            fit: BoxFit.cover,
                            width: 100,
                            height: 100,
                          );
                        },
                      ),
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("$quantity ", style: const TextStyle(fontSize: 15)),
                IconButton(
                  onPressed: () => onDelete(id),
                  icon: const Icon(Icons.delete, size: 20),
                ),
              ],
            ),
            title: Text(title),
          ),
        ),
      ),
    );
  }
}
