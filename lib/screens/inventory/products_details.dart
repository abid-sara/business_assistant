import 'package:flutter/material.dart';
import 'package:business_assistant/style/text.dart';
import 'package:business_assistant/style/colors.dart';
import 'package:business_assistant/data/products.dart'; // Import the product data

class ItemDetails extends StatefulWidget {
  const ItemDetails({super.key});

  @override
  _ItemDetailsState createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {
  late TextEditingController _nameController;
  late TextEditingController _unitPriceController;
  late TextEditingController _descriptionController;
  late TextEditingController _quantityController;
  late TextEditingController _remainingQuantityController;
  late TextEditingController _unitCostController;
  late TextEditingController _unitsBoughtController;
  late TextEditingController _supplierNameController;
  late TextEditingController _supplierPhoneController;
  late TextEditingController _supplierAddressController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _unitPriceController = TextEditingController();
    _descriptionController = TextEditingController();
    _quantityController = TextEditingController();
    _remainingQuantityController = TextEditingController();
    _unitCostController = TextEditingController();
    _unitsBoughtController = TextEditingController();
    _supplierNameController = TextEditingController();
    _supplierPhoneController = TextEditingController();
    _supplierAddressController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //PASS the product itself
    final Product product =
        ModalRoute.of(context)!.settings.arguments as Product;

    Future.microtask(() {
      _nameController.text = product.name;
      _unitPriceController.text = product.unitPrice.toString();
      _descriptionController.text = product.description;
      _quantityController.text = product.quantity.toString();
      _remainingQuantityController.text = product.remainingQuantity.toString();
      _unitCostController.text = product.unitCost.toString();
      _unitsBoughtController.text = product.unitsBought.toString();
      _supplierNameController.text = product.supplierName;
      _supplierPhoneController.text = product.supplierPhone;
      _supplierAddressController.text = product.supplierAddress;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _unitPriceController.dispose();
    _descriptionController.dispose();
    _quantityController.dispose();
    _remainingQuantityController.dispose();
    _unitCostController.dispose();
    _unitsBoughtController.dispose();
    _supplierNameController.dispose();
    _supplierPhoneController.dispose();
    _supplierAddressController.dispose();
    super.dispose();
  }

  void _showEditDialog(Product product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Product'),
          content: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Form(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Item name'),
                    ),
                    TextFormField(
                      controller: _unitPriceController,
                      decoration:
                          const InputDecoration(labelText: 'Item unit price'),
                      keyboardType: TextInputType.number,
                    ),
                    TextFormField(
                      controller: _descriptionController,
                      decoration:
                          const InputDecoration(labelText: 'Item description'),
                    ),
                    TextFormField(
                      controller: _quantityController,
                      decoration:
                          const InputDecoration(labelText: 'Item quantity'),
                      keyboardType: TextInputType.number,
                    ),
                    TextFormField(
                      controller: _remainingQuantityController,
                      decoration: const InputDecoration(
                          labelText: 'Item remaining quantity'),
                      keyboardType: TextInputType.number,
                    ),
                    TextFormField(
                      controller: _unitCostController,
                      decoration:
                          const InputDecoration(labelText: 'Item unit cost'),
                      keyboardType: TextInputType.number,
                    ),
                    TextFormField(
                      controller: _unitsBoughtController,
                      decoration:
                          const InputDecoration(labelText: 'Item units bought'),
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
                      decoration:
                          const InputDecoration(labelText: 'Supplier address'),
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
                setState(() {
                  product.name = _nameController.text;
                  product.unitPrice = double.parse(_unitPriceController.text);
                  product.description = _descriptionController.text;
                  product.quantity = double.parse(_quantityController.text);
                  product.remainingQuantity =
                      double.parse(_remainingQuantityController.text);
                  product.unitCost = double.parse(_unitCostController.text);
                  product.unitsBought =
                      double.parse(_unitsBoughtController.text);
                  product.supplierName = _supplierNameController.text;
                  product.supplierPhone = _supplierPhoneController.text;
                  product.supplierAddress = _supplierAddressController.text;
                });
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Product product =
        ModalRoute.of(context)!.settings.arguments as Product;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Product details"),
      ),
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
                          width: 200,
                          height: 140,
                          child: Image.asset(product.image),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              product.name,
                              style: const TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Center(
                          child: SizedBox(
                              width: 100,
                              height: 50,
                              child: Text(product.description)),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                elevation: 0, // Remove shadow
                                shadowColor:
                                    Colors.transparent, // Remove shadow color
                                splashFactory: NoSplash
                                    .splashFactory, // Remove splash effect
                              ).copyWith(
                                overlayColor: WidgetStateProperty.all(
                                    Colors.transparent), // Remove overlay color
                              ),
                              child: const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(
                                    Icons.edit,
                                    size: 20,
                                    color: Colors.grey,
                                  ),
                                  Text(" Edit item ",
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ))
                                ],
                              ),
                              onPressed: () {
                                _showEditDialog(product);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "   Item information",
                      style: title_style,
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.lightGreen,
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            "Item name: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(product.name),
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            "Item unit price: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(product.unitPrice.toString()),
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            "Item description: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(product.description),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("   Inventory information", style: title_style),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.lightGreen,
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            "Item quantity: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(product.quantity.toString()),
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            "Item remaining quantity: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(product.remainingQuantity.toString()),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("  Cost details", style: title_style),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.lightGreen,
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            "Item unit cost: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(product.unitCost.toString()),
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            "Item units bought: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(product.unitsBought.toString()),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("   Supplier information", style: title_style),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.lightGreen,
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            "Supplier name: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(product.supplierName),
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            "Supplier phone: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(product.supplierPhone),
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            "Supplier address: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(product.supplierAddress),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
