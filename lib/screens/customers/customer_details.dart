import 'package:business_assistant/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:business_assistant/widget/orderLine.dart';
import 'package:business_assistant/style/containers.dart';
import 'package:business_assistant/data/customers.dart'; // Import the customers.dart file
import 'package:business_assistant/data/orders.dart'; // Import the orders.dart file
import 'package:business_assistant/data/products.dart'; // Import the products.dart file
import 'dart:math';

class customerDetails extends StatefulWidget {
  const customerDetails({super.key});

  @override
  _customerDetailsState createState() => _customerDetailsState();
}

class _customerDetailsState extends State<customerDetails> {
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _addressController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    _noteController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void deleteOrder(Order order, Customer customer) {
    setState(() {
      customer.orders.remove(order);
      ordersCenter.remove(order);
    });
    print(
        "Delete from the customers has worked and the order is deleted from the list of the customer");
  }

  void _showAddOrderDialog(Customer currentCustomer) {
    final TextEditingController deliveryPriceController =
        TextEditingController();
    final TextEditingController deliveryDateController =
        TextEditingController();
    final TextEditingController deliveryAddressController =
        TextEditingController();
    final TextEditingController orderDateController = TextEditingController();
    List<Map<String, dynamic>> selectedProducts = [];
    Customer selectedCustomer = currentCustomer;

    void addProductField(StateSetter setState) {
      setState(() {
        selectedProducts.add({'product': null, 'quantity': 1});
      });
    }

    void removeProductField(int index, StateSetter setState) {
      setState(() {
        selectedProducts.removeAt(index);
      });
    }

    Future<void> selectDate(
        BuildContext context, TextEditingController controller) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );
      if (picked != null) {
        setState(() {
          controller.text = "${picked.toLocal()}".split(' ')[0];
        });
      }
    }

    String generateOrderCode() {
      final random = Random();
      const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
      const codeLength = 8;

      String randomString(int length) {
        return String.fromCharCodes(Iterable.generate(
          length,
          (_) => characters.codeUnitAt(random.nextInt(characters.length)),
        ));
      }

      return randomString(codeLength);
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add Order'),
              content: SingleChildScrollView(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...selectedProducts.asMap().entries.map((entry) {
                        int index = entry.key;
                        Map<String, dynamic> productData = entry.value;
                        return Column(
                          children: [
                            DropdownButtonFormField<Product>(
                              decoration:
                                  const InputDecoration(labelText: 'Product'),
                              items: products.map((Product product) {
                                return DropdownMenuItem<Product>(
                                  value: product,
                                  child: Text(product.name),
                                );
                              }).toList(),
                              onChanged: (Product? newValue) {
                                setState(() {
                                  productData['product'] = newValue;
                                });
                              },
                              value: productData['product'],
                            ),
                            TextField(
                              decoration: const InputDecoration(
                                  labelText: 'Product Quantity'),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  productData['quantity'] =
                                      int.tryParse(value) ?? 1;
                                });
                              },
                              controller: TextEditingController(
                                  text: productData['quantity'].toString()),
                            ),
                            IconButton(
                              icon: const Icon(Icons.remove_circle),
                              onPressed: () {
                                removeProductField(index, setState);
                              },
                            ),
                          ],
                        );
                      }),
                      TextButton(
                        onPressed: () => addProductField(setState),
                        child: const Text('Add a Product'),
                      ),
                      GestureDetector(
                        onTap: () => selectDate(context, orderDateController),
                        child: AbsorbPointer(
                          child: TextField(
                            controller: orderDateController,
                            decoration:
                                const InputDecoration(labelText: 'Order date'),
                          ),
                        ),
                      ),
                      TextField(
                        controller: deliveryPriceController,
                        decoration:
                            const InputDecoration(labelText: 'Delivery Price'),
                        keyboardType: TextInputType.number,
                      ),
                      TextField(
                        controller: deliveryAddressController,
                        decoration: const InputDecoration(
                            labelText: 'Delivery Address'),
                      ),
                      GestureDetector(
                        onTap: () =>
                            selectDate(context, deliveryDateController),
                        child: AbsorbPointer(
                          child: TextField(
                            controller: deliveryDateController,
                            decoration: const InputDecoration(
                                labelText: 'Estimated Delivery Date'),
                          ),
                        ),
                      ),
                    ],
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
                    if (selectedProducts.any(
                            (productData) => productData['product'] == null) ||
                        deliveryPriceController.text.isEmpty ||
                        deliveryDateController.text.isEmpty ||
                        deliveryAddressController.text.isEmpty ||
                        orderDateController.text.isEmpty) {
                      print("Some fields are empty !!");
                      return;
                    }

                    final newOrder = Order(
                      totalPrice: 70, //temp !!
                      orderCode:
                          generateOrderCode(), // must be generated by a function
                      products: {
                        for (var productData in selectedProducts)
                          productData['product']: productData['quantity']
                      },
                      customer: selectedCustomer,
                      deliveryPrice: double.parse(deliveryPriceController.text),
                      deliveryDate: deliveryDateController.text,
                      deliveryAddress: deliveryAddressController.text,
                      orderDate: orderDateController.text,
                    );

                    setState(() {
                      ordersCenter.add(newOrder);
                      selectedCustomer.addOrder(newOrder);
                      print(
                          "The order for the customer ${selectedCustomer.name} has been added successfully and his orders count now is ${selectedCustomer.ordersCount()}");
                    });

                    Navigator.of(context).pop();
                  },
                  child: const Text('Add Order'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showEditCustomerDialog(Customer customer) {
    _nameController.text = customer.name;
    _addressController.text = customer.address;
    _phoneController.text = customer.phone_num;
    _emailController.text = customer.email;
    _noteController.text = customer.note;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Customer'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Customer Name'),
                controller: _nameController,
              ),
              TextField(
                controller: _phoneController,
                decoration:
                    const InputDecoration(labelText: 'Customer phone number'),
                keyboardType: TextInputType.phone,
              ),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Customer Email'),
              ),
              TextField(
                controller: _addressController,
                decoration:
                    const InputDecoration(labelText: 'Customer Address'),
              ),
              TextField(
                controller: _noteController,
                decoration: const InputDecoration(labelText: 'Additional note'),
              ),
              const SizedBox(height: 10),
            ],
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
                  customer.name = _nameController.text;
                  customer.address = _addressController.text;
                  customer.phone_num = _phoneController.text;
                  customer.email = _emailController.text;
                  customer.note = _noteController.text;
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
    final customer = ModalRoute.of(context)!.settings.arguments as Customer;

    //looking for the corresponding customer

    return Scaffold(
      appBar: AppBar(
        title: Text(customer.name),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.transparent,
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
          Center(
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(63, 255, 255, 255),
                borderRadius: BorderRadius.circular(10),
              ),
              width: 400,
              height: 700,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // const Divider(
                  //   color: AppColors.darkGreen,
                  //   thickness: 1,
                  //   indent: 10,
                  //   endIndent: 10,
                  // ),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.purpule,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Personal information",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              _showEditCustomerDialog(customer);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(63, 255, 255, 255),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Text(
                              "Name: ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(customer.name),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              "Address: ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(customer.address),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              "Phone number: ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(customer.phone_num),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              "Email: ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(customer.email),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              "Note: ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(customer.note),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          ("Customer orders"),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text("Orders count ${customer.ordersCount()}"),
                      ],
                    ),
                  ),
                  customer.ordersCount() == 0
                      ? const Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Text("No orders yet for the customer..."),
                        )
                      : Expanded(
                          child: ListView(
                          children: [
                            for (var order in customer.orders)
                              Orderline(
                                order: order,
                                markOrderAsDelivered: (order) {
                                  setState(() {
                                    order.setDelivered(!order.delivered);
                                  });
                                },
                                deleteOrder: deleteOrder,
                              ),
                          ],
                        )),
                  ElevatedButton(
                      onPressed: () {
                        //adding an order
                        _showAddOrderDialog(customer);
                      },
                      child: const Text("Add order"))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
