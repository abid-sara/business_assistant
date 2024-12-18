import 'package:business_assistant/widget/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:business_assistant/style/text.dart';
import 'package:business_assistant/style/colors.dart';
import 'package:business_assistant/models/product.dart';
import 'package:image_input/image_input.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';
import 'dart:io';

import '../../database/db_product.dart';

class Inventory extends StatefulWidget {
  const Inventory({super.key});

  @override
  State<Inventory> createState() => _InventoryState();
}

class _InventoryState extends State<Inventory>
    with SingleTickerProviderStateMixin {
  //controllers for the input fields
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

  late TabController _tabController;

  List<Product> filtered_products = [];
  List<Product> products = [];
  String _searchQuery = '';
  String unitPriceError = '';
  String currentQuantityError = '';
  String costPriceError = '';
  String totalUnitsError = '';
  String supplierPhoneError = '';
  String imageError = "";
  String minThresholdError = "";
  List<XFile> imageInputImages = [];
  bool allowEditImageInput = true;
  File? _image;
  String _imagePath = "";

  Future<void> initialize() async {
    List<Map<String, dynamic>> productsUnformated = await showProducts();
    products = productsUnformated.map((map) => Product.fromMap(map)).toList();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    initialize();
  }

  List<Product> _filterItems(String category) {
    List<Product> filteredResults = products;

    if (_searchQuery.isNotEmpty) {
      filteredResults = filteredResults.where((product) {
        return product.name.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    if (category == 'All') {
      return filteredResults;
    } else if (category == 'Low-stock') {
      return filteredResults
          .where((product) => product.quantity < product.minimumQuantity)
          .toList();
    } else if (category == 'High-stock') {
      return filteredResults
          .where((product) =>
              product.quantity >=
              product
                  .minimumQuantity) // we should just consider the min threshold in each product
          .toList();
    } else {
      return filteredResults;
    }
  }

  void _addNewItem(Product product) async {
    // Add the product to the local filtered products list
    setState(() {
      filtered_products.add(product);
    });

    // Prepare the product data as a map for database insertion
    Map<String, dynamic> productData = {
      'name': product.name,
      'quantity': product.quantity,
      'product_image': product.productImage,
      'unit_price': product.unitPrice,
      'product_description': product.productDescription,
      'minimum_quantity': product.minimumQuantity,
      'deleted': 0,
      'supplier_name': product.supplierName,
      'supplier_phone_num': product.supplierPhoneNum,
      'supplier_address': product.supplierAddress,
    };

    // Add the product to the database
    bool success = await addProduct(product: productData);

    if (!success) {
      // If database insertion fails, remove the product from the local list
      setState(() {
        filtered_products.remove(product);
      });

      // Optionally show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to add product to database')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('YES to add product to database')),
      );
      // Re-fetch the entire product list from the database
      List<Map<String, dynamic>> productsUnformated = await showProducts();
      setState(() {
        products =
            productsUnformated.map((map) => Product.fromMap(map)).toList();
        // Reset the search query to show the updated list
        _searchQuery = '';
        _searchController.clear();
      });
    }
  }

  void _showAddItemDialog() {
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        //it must rebuild the widget !
        return StatefulBuilder(builder: (context, setState) {
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
                        child: Text(
                          "Product information",
                          style: title_style,
                        ),
                      ),
                      TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'Product name'),
                        controller: _nameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a product name';
                          }
                          return null;
                        },
                      ),

                      TextFormField(
                        onChanged: (value) {
                          if (value.isEmpty) {
                            unitPriceError = 'Please enter a unit price';
                            setState(() {});
                          }
                          if (!RegExp(r'^\d+(\.\d+)?$').hasMatch(value)) {
                            unitPriceError = 'Please enter a valid number';
                            setState(() {});
                          }
                          unitPriceError = '';
                          setState(() {});
                        },
                        decoration:
                            const InputDecoration(labelText: 'Unit price'),
                        keyboardType: TextInputType.number,
                        controller: _unitPriceController,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a unit price';
                          }
                          if (!RegExp(r'^[0-9]*$').hasMatch(value)) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),
                      Text(unitPriceError,
                          style: const TextStyle(color: Colors.red)),
                      const SizedBox(height: 30),
                      Center(
                        child: Text(
                          "Inventory information",
                          style: title_style,
                        ),
                      ),
                      TextFormField(
                        controller: _quantityController,
                        decoration: const InputDecoration(
                            labelText: 'Current Quantity'),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the current quantity';
                          }
                          if (!RegExp(r'^[0-9]*$').hasMatch(value)) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          if (value.isEmpty) {
                            currentQuantityError =
                                'Please enter the current quantity';
                            setState(() {});
                          }
                          if (!RegExp(r'^[0-9]*$').hasMatch(value)) {
                            currentQuantityError =
                                'Please enter a valid number';
                            setState(() {});
                          }
                          currentQuantityError = '';
                        },
                      ),

                      //add the field for the min threshold
                      TextFormField(
                        controller: _minController,
                        decoration: const InputDecoration(
                            labelText: 'Minimum quantity threshold'),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the minimum threshold';
                          }
                          if (!RegExp(r'^[0-9]*$').hasMatch(value)) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          if (value.isEmpty) {
                            minThresholdError =
                                'Please enter the min threshold';
                            setState(() {});
                          }
                          if (!RegExp(r'^[0-9]*$').hasMatch(value)) {
                            minThresholdError = 'Please enter a valid number';
                            setState(() {});
                          }
                          minThresholdError = '';
                        },
                      ),

                      const SizedBox(height: 30),
                      Center(
                        child: Text("Supplier information", style: title_style),
                      ),
                      TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'Supplier name'),
                        controller: _supplierNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the supplier name';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                            labelText: 'Supplier phone number'),
                        keyboardType: TextInputType.phone,
                        controller: _supplierPhoneController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the supplier phone number';
                          }
                          return null;
                        },
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                            labelText: 'Supplier address'),
                        controller: _supplierAddressController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the supplier address';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'Additional info'),
                        controller: _additionalInfoController,
                      ),
                      const SizedBox(height: 30),
                      Text(
                        "Product's image",
                        style: title_style,
                      ),
                      Center(
                        child: Column(
                          children: [
                            //use the image path instead
                            _imagePath.isEmpty
                                ? const SizedBox()
                                : Image.file(
                                    File(_imagePath),
                                    width: 100,
                                    height: 100,
                                  ),
                            ImageInput(
                              images: imageInputImages,
                              allowEdit: allowEditImageInput,
                              allowMaxImage: 1,
                              getPreferredCameraDevice: () async =>
                                  await getPrefferedCameraDevice(context),
                              getImageSource: () async =>
                                  await getImageSource(context),
                              onImageSelected: (image) {
                                setState(() {
                                  imageInputImages = [image];
                                  _imagePath = image.path;
                                  print(
                                      "The path of the image got is : $_imagePath");
                                  print("The length of the pics list is ");
                                  print(imageInputImages.length);
                                });
                              },
                              onImageRemoved: (image, index) {
                                setState(() {
                                  imageInputImages.remove(image);
                                  _imagePath = "";
                                });
                              },
                              loadingBuilder: (context, progress) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
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
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    String imagePath = imageInputImages.isNotEmpty
                        ? imageInputImages[0].path
                        : "assets/images/default.png";

                    // Create the product object
                    final newProduct = Product(
                      id: products.length + 1,
                      name: _nameController.text,
                      quantity: int.parse(_quantityController.text),
                      productImage: imagePath ??
                          "assets/images/default.png", // must be a default image
                      unitPrice: double.parse(_unitPriceController.text),
                      productDescription: _additionalInfoController.text,
                      minimumQuantity: int.parse(_minController.text),
                      deleted: false,
                      supplierName: _supplierNameController.text,
                      supplierPhoneNum: _supplierPhoneController.text,
                      supplierAddress: _supplierAddressController.text,
                    );

                    // Add the product to the products list
                    setState(() {
                      //We just needed to add the product to the products list of the parent using the setState of the parent
                      _addNewItem(newProduct);
                      //calls the setState of the parent widget
                    });

                    // Optionally, clear the text fields after adding the product
                    _nameController.clear();
                    _quantityController.clear();
                    _unitController.clear();
                    _unitPriceController.clear();
                    _supplierNameController.clear();
                    _supplierPhoneController.clear();
                    _supplierAddressController.clear();
                    _additionalInfoController.clear();
                    _minController.clear();
                    setState(() {
                      imageInputImages = [];
                    });

                    // Close the dialog
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Add'),
              ),
            ],
          );
        });
      },
    );
  }

  void _deleteProduct(int id) {
    setState(() {
      deleteProduct(id);
      filtered_products.removeWhere((product) => product.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Product> filteredProducts = _filterItems(_searchQuery);
    return Scaffold(
      drawer: const Sidebar(),
      appBar: AppBar(
        title: const Text("Inventory center"),
        backgroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All items'),
            Tab(text: 'High-stock'),
            Tab(text: 'Low-stock'),
          ],
          labelPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          indicator: const UnderlineTabIndicator(
            borderSide: BorderSide(
              width:
                  4.0, // Change this value to adjust the thickness of the indicator
              color: Color.fromARGB(193, 169, 169, 199),
            ),
            insets: EdgeInsets.symmetric(
                horizontal:
                    16.0), // Adjust this value to change the width of the indicator
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
                image: AssetImage(
                    "assets/images/background.png"), // Path to your image
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Row for the search bar and the drop down menu

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Search for an item ',
                    prefixIcon: const Icon(Icons.search),
                    fillColor: AppColors.purpule,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none, // Remove the border side
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none, // Remove the border side
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none, // Remove the border side
                    ),
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                  ),
                  onChanged: (query) {
                    setState(() {
                      _searchQuery = query;
                    });
                  },
                ),
              ),

              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("Item", style: TextStyle(color: Colors.grey)),
                  Text("Stock-level", style: TextStyle(color: Colors.grey)),
                ],
              ),
              // Expanded widget to make the TabBarView scrollable
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildItemList('All'),
                    _buildItemList('High-stock'),
                    _buildItemList('Low-stock'),
                  ],
                ),
              ),
              // Button for adding an item in the list
              SizedBox(
                width: 130,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.darkGreen,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                  ),
                  onPressed: _showAddItemDialog,
                  child: const Row(
                    children: [
                      Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      Text('Add Item', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ),
              // Place for the bottom bar
              Container(
                height: 70,
                color: Colors.white,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildItemList(String category) {
    final filteredItems = _filterItems(category);
    return ListView.builder(
      itemCount: filteredItems.length,
      itemBuilder: (context, index) {
        final item = filteredItems[index];
        return ItemLine(
          id: item.id,
          quantity: item.quantity,
          title: item.name,
          image: item.productImage,
          itemObj: item,
          onDelete: _deleteProduct,
        );
      },
    );
  }
}

// Ignore: must_be_immutable
class ItemLine extends StatelessWidget {
  final int id;
  final int quantity;
  final String title;
  final String image; // Path to the image
  final Product itemObj;
  final Function(int) onDelete; // Callback function for deletion

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
        onTap: () {
          // Pass the product ID to the details screen
          Navigator.pushNamed(context, '/itemDetails', arguments: itemObj);
        },
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
                Text(
                  "$quantity ",
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    onDelete(id); // Call the delete callback
                  },
                  icon: const Icon(Icons.delete, size: 20),
                ),
              ],
            ), // For the quantity
            title: Text(title),
          ),
        ),
      ),
    );
  }
}

//there is still a problem with the image input !

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
