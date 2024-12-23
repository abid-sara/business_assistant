import 'package:business_assistant/cubits/product/product_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:business_assistant/widget/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:business_assistant/style/text.dart';
import 'package:business_assistant/style/colors.dart';
import 'package:business_assistant/models/product.dart';
import 'package:image_input/image_input.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import '../../cubits/product/product_repository.dart';
import '../../cubits/product/product_state.dart';
import '../../cubits/product/validation_cubit.dart';

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
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d*\.?\d*$')),
                            ],
                            onChanged: (value) => context
                                .read<ValidationCubit>()
                                .validateUnitPrice(value),
                            validator: (value) {
                              final state =
                                  context.watch<ValidationCubit>().state;
                              return state.unitPriceError.isEmpty
                                  ? null
                                  : state.unitPriceError;
                            }),
                        const SizedBox(height: 30),
                        Center(
                            child: Text("Inventory information",
                                style: title_style)),
                        TextFormField(
                            controller: _quantityController,
                            decoration: const InputDecoration(
                                labelText: 'Current Quantity'),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            onChanged: (value) => context
                                .read<ValidationCubit>()
                                .validateCurrentQuantity(value),
                            validator: (value) {
                              final state =
                                  context.watch<ValidationCubit>().state;
                              return state.currentQuantityError.isEmpty
                                  ? null
                                  : state.currentQuantityError;
                            }),
                        TextFormField(
                            controller: _minController,
                            decoration: const InputDecoration(
                                labelText: 'Minimum quantity threshold'),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            onChanged: (value) => context
                                .read<ValidationCubit>()
                                .validateMinThreshold(value),
                            validator: (value) {
                              final state =
                                  context.watch<ValidationCubit>().state;
                              return state.minThresholdError.isEmpty
                                  ? null
                                  : state.minThresholdError;
                            }),
                        const SizedBox(height: 30),
                        Center(
                            child: Text("Supplier information",
                                style: title_style)),
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
                            onChanged: (value) => context
                                .read<ValidationCubit>()
                                .validateSupplierPhoneNumber(value),
                            validator: (value) {
                              final state =
                                  context.watch<ValidationCubit>().state;
                              return state.supplierPhoneError.isEmpty
                                  ? null
                                  : state.supplierPhoneError;
                            }),
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
                        Text("Product's image", style: title_style),
                        Center(
                          child: Column(
                            children: [
                              if (state is ValidationState &&
                                  state.imagePath.isNotEmpty)
                                Image.file(
                                  File(state.imagePath),
                                  width: 100,
                                  height: 100,
                                ),
                              ImageInput(
                                images: state is ValidationState
                                    ? state.imageInputImages
                                    : [],
                                allowEdit: true,
                                allowMaxImage: 1,
                                getPreferredCameraDevice: () async =>
                                    await getPrefferedCameraDevice(context),
                                getImageSource: () async =>
                                    await getImageSource(context),
                                onImageSelected: (image) => context
                                    .read<ValidationCubit>()
                                    .updateImageInput(image),
                                loadingBuilder: (context, progress) =>
                                    const CircularProgressIndicator(),
                              ),
                            ],
                          ),
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
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      final newProduct = Product(
                        // id: DateTime.now().millisecondsSinceEpoch,
                        name: _nameController.text,
                        quantity: int.parse(_quantityController.text),
                        productImage: state is ValidationState &&
                                state.imagePath.isNotEmpty
                            ? state.imagePath
                            : "assets/images/default.png",
                        unitPrice: double.parse(_unitPriceController.text),
                        productDescription: _additionalInfoController.text,
                        minimumQuantity: int.parse(_minController.text),
                        deleted: false,
                        supplierName: _supplierNameController.text,
                        supplierPhoneNum: _supplierPhoneController.text,
                        supplierAddress: _supplierAddressController.text,
                      );

                      cubit.addProduct(newProduct);
                      _clearForm();
                      context.read<ValidationCubit>().clearForm();
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Add'),
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
          id: item.id!,
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
  final int id;
  final int quantity;
  final String title;
  final String image;
  final Product itemObj;
  final Function(int) onDelete;

  const ItemLine({
    super.key,
    required this.id,
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
                child: Image.asset(
                  image,
                  fit: BoxFit.cover,
                  width: 100,
                  height: 100,
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

var getImageSource = (BuildContext context) {
  return showDialog<ImageSource>(
    context: context,
    builder: (context) {
      return SimpleDialog(
        children: [
          SimpleDialogOption(
            child: const Text("Camera"),
            onPressed: () {
              Navigator.of(context).pop(ImageSource.camera);
            },
          ),
          SimpleDialogOption(
              child: const Text("Gallery"),
              onPressed: () {
                Navigator.of(context).pop(ImageSource.gallery);
              }),
        ],
      );
    },
  ).then((value) {
    return value ?? ImageSource.gallery;
  });
};

var getPrefferedCameraDevice = (BuildContext context) async {
  var status = await Permission.camera.request();
  if (status.isDenied) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Allow Camera Permission"),
      ),
    );
    return null;
  }
  return showDialog<CameraDevice>(
    context: context,
    builder: (context) {
      return SimpleDialog(
        children: [
          SimpleDialogOption(
            child: const Text("Rear"),
            onPressed: () {
              Navigator.of(context).pop(CameraDevice.rear);
            },
          ),
          SimpleDialogOption(
              child: const Text("Front"),
              onPressed: () {
                Navigator.of(context).pop(CameraDevice.front);
              }),
        ],
      );
    },
  ).then(
    (value) {
      return value ?? CameraDevice.rear;
    },
  );
};
