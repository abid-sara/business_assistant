import 'package:business_assistant/database/db_customer.dart';
import 'package:business_assistant/database/db_product.dart';
import 'package:business_assistant/models/order.dart';
import 'package:business_assistant/style/colors.dart';
import 'package:business_assistant/widget/sidebar.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:business_assistant/widget/orderLine.dart';
import 'dart:math';
import 'package:business_assistant/database/db_order.dart';
import 'package:business_assistant/models/product.dart';
import 'package:business_assistant/models/customer.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  Customer? selectedCustomer;
  List<Order> filteredOrders = [];
  DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  String DateError = "";
  String priceError = ""; //it must be only numbers and no char
  late List<Product> products;
  late List<Order> ordersCenter;
  late List<Customer> customers;

  Future<bool> _initializeData() async {
    try {
      filteredOrders = await _filterOrders('All'); //at first we start by all

      List<Map<String, dynamic>> ordersUnformated = await showOrders();
      ordersCenter = ordersUnformated.map((map) => Order.fromMap(map)).toList();

      List<Map<String, dynamic>> productsUnformated = await showProducts();
      products = productsUnformated.map((map) => Product.fromMap(map)).toList();

      List<Map<String, dynamic>> customersUnformated = await showCustomers();
      customers =
          customersUnformated.map((map) => Customer.fromMap(map)).toList();

      for (var product in productsUnformated) {
        print(product);
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_updateFilteredOrders);
    _initializeData();
  }

  Future<bool> _markOrderAsDelivered(Order order) async {
    try {
      // Directly await the updateOrderStatus method
      bool success = await updateOrderStatus(order.id);

      if (success) {
        // Update filtered orders if status update was successful
        await _updateFilteredOrders();
        return true;
      } else {
        // Show an error message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update order status')),
        );
        return false;
      }
    } catch (e) {
      // Handle any unexpected errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
      return false;
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_updateFilteredOrders);
    _tabController.dispose();
    super.dispose();
  }

  Future<List<Order>> _filterOrders(String filter) async {
    List<Order> filtered = ordersCenter;

    // Filter orders by status
    if (filter == 'All') {
      filtered = ordersCenter;
    } else if (filter == 'Delivered') {
      filtered =
          ordersCenter.where((order) => order.status == "delivered").toList();
    } else if (filter == 'Pending') {
      filtered =
          ordersCenter.where((order) => order.status == "pending").toList();
    }

    // Search query filter
    if (_searchQuery.isNotEmpty) {
      filtered = await Future.wait(filtered.map((order) async {
        String customerName = await getCustomerName(order.customer.id);
        bool matchesSearchQuery = order.id
                .toString()
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            customerName.toLowerCase().contains(_searchQuery.toLowerCase());

        return matchesSearchQuery
            ? order
            : null; // Return order if it matches the search query, else null
      })).then((results) =>
          results.whereType<Order>().toList()); // Filter out null values
    }

    return filtered;
  }

  Future<bool> _updateFilteredOrders() async {
    try {
      List<Order> filtered = await _filterOrders(
        _tabController.index == 0
            ? 'All'
            : _tabController.index == 1
                ? 'Delivered'
                : 'Pending',
      );

      setState(() {
        filteredOrders = filtered;
      });

      return true;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating orders: ${e.toString()}')),
      );
      return false;
    }
  }

  Future<void> _selectDate(
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
//defining the date Times that will be compared

  void _showAddOrderDialog() {
    final TextEditingController deliveryPriceController =
        TextEditingController();
    final TextEditingController deliveryDateController =
        TextEditingController();
    final TextEditingController deliveryAddressController =
        TextEditingController();
    final TextEditingController orderDateController = TextEditingController();
    List<Map<String, dynamic>> selectedProducts = [];
    late DateTime deliveryDate;
    late DateTime orderDate;
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
                      DropdownButtonFormField<Customer>(
                        decoration:
                            const InputDecoration(labelText: 'Customer'),
                        items: customers.map((Customer customer) {
                          return DropdownMenuItem<Customer>(
                            value: customer,
                            child: Text(customer.name),
                          );
                        }).toList(),
                        onChanged: (Customer? newValue) {
                          setState(() {
                            selectedCustomer = newValue;
                          });
                        },
                      ),
                      GestureDetector(
                        onTap: () {
                          _selectDate(context, orderDateController);
                        },
                        child: AbsorbPointer(
                          child: TextField(
                            onChanged: (value) {
                              setState(() {
                                if (orderDateController.text.isNotEmpty) {
                                  orderDate = dateFormat
                                      .parse(orderDateController.text);
                                }
                              });
                            },
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
                        onChanged: (value) {
                          setState(() {
                            if (RegExp(r'^[0-9]*$').hasMatch(value)) {
                              priceError = '';
                            } else {
                              priceError = 'Please enter a valid number';
                            }
                          });
                        },
                      ),
                      //display the error in case something is wrong
                      Text(
                        priceError,
                        style: const TextStyle(color: Colors.red),
                      ),
                      TextField(
                        controller: deliveryAddressController,
                        decoration: const InputDecoration(
                            labelText: 'Delivery Address'),
                      ),
                      GestureDetector(
                        onTap: () {
                          _selectDate(context, deliveryDateController);
                        },
                        child: AbsorbPointer(
                          child: TextField(
                            onChanged: (value) {
                              print("helloo we are hereee!");
                              setState(() {
                                if (deliveryDateController.text.isNotEmpty) {
                                  deliveryDate = dateFormat
                                      .parse(deliveryDateController.text);
                                }
                              });
                              if (deliveryDate.isBefore(orderDate)) {
                                setState(() {
                                  DateError =
                                      "Delivery date must be after the order date";
                                  print("There is an error !");
                                });
                              } else if (deliveryDate.isAfter(orderDate)) {
                                setState(() {
                                  DateError = "";
                                  print("Delivery date is before order date");
                                });
                              }
                            },
                            controller: deliveryDateController,
                            decoration: const InputDecoration(
                                labelText: 'Estimated Delivery Date'),
                          ),
                        ),
                      ),
                      //display the error in case something is wrong
                      Text(
                        DateError,
                        style: const TextStyle(color: Colors.red),
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
                  onPressed: () async {
                    if (selectedProducts.any(
                            (productData) => productData['product'] == null) ||
                        selectedCustomer == null ||
                        deliveryPriceController.text.isEmpty ||
                        deliveryDateController.text.isEmpty ||
                        deliveryAddressController.text.isEmpty ||
                        orderDateController.text.isEmpty) {
                      print("Some fields are empty !!");
                      return;
                    }

                    setState(() {
                      if (orderDateController.text.isNotEmpty) {
                        orderDate = dateFormat.parse(orderDateController.text);
                      }
                    });
                    print("helloo we are hereee!");
                    setState(() {
                      if (deliveryDateController.text.isNotEmpty) {
                        deliveryDate =
                            dateFormat.parse(deliveryDateController.text);
                      }
                    });
                    if (deliveryDate.isBefore(orderDate)) {
                      setState(() {
                        DateError =
                            "Delivery date must be after the order date";
                        print("There is an error !");
                      });
                    } else if (deliveryDate.isAfter(orderDate)) {
                      setState(() {
                        DateError = "";
                        print("Delivery date is before order date");
                      });
                    }

                    //check if there is an error in the date, in that case we return without adding the order
                    if (DateError.isNotEmpty) {
                      return;
                    }

                    // Prepare order data for database
                    Map<String, dynamic> orderData = {
                      "status": "pending",
                      "orderDate": orderDateController.text,
                      "deliveryDate": deliveryDateController.text,
                      "deliveryAddress": deliveryAddressController.text,
                      "deliveryPrice":
                          double.parse(deliveryPriceController.text),
                      "customerId": selectedCustomer!.id,
                    };

                    // Prepare products data for database
                    List<Map<String, dynamic>> orderProducts =
                        selectedProducts.map((productData) {
                      return {
                        "id": productData['product'].id,
                        "product_id": productData['product'].id,
                        "quantity": productData['quantity']
                      };
                    }).toList();

                    // Add order to database
                    int orderId = await addOrder(
                        order: orderData, products: orderProducts);

                    if (orderId > 0) {
                      // Refresh orders list
                      _initializeData();
                      Navigator.of(context).pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Failed to add order')),
                      );
                    }

                    // setState(() {
                    //   ordersCenter.add(newOrder);
                    //   selectedCustomer?.addOrder(newOrder);
                    //   _updateFilteredOrders(); // Update filtered orders
                    //   //We have to update the quantity of the order

                    //   for (var productData in selectedProducts) {
                    //     productData['product'].quantity -=
                    //         productData['quantity'];
                    //     print(
                    //         "We are reducing the quantity for the used ones ");
                    //   }
                    // });

                    // Navigator.of(context).pop();
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

  void _deleteOrder(Order orderToDelete, Customer customer) async {
    try {
      // Find the corresponding order from the orders center
      var orderToRemove = ordersCenter.firstWhere(
        (order) => order.id == orderToDelete.id,
      );

      bool success = await deleteOrder(orderToRemove.id, customer.id);

      if (success) {
        setState(() {
          filteredOrders.removeWhere((order) => order.id == orderToDelete.id);
          ordersCenter.removeWhere((order) => order.id == orderToDelete.id);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete order')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order not found')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Sidebar(),
      appBar: AppBar(
        title: const Text("Orders center"),
        backgroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Delivered'),
            Tab(text: 'Pending'),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      body: FutureBuilder<void>(
          future: _initializeData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            // Handle any errors during data initialization
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Failed to load data'),
                    ElevatedButton(
                      onPressed: () => _initializeData(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            return Stack(
              children: [
                //background image
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/background.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            labelText: 'Search for an order...',
                            prefixIcon: const Icon(Icons.search),
                            fillColor: AppColors.purpule,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide:
                                  BorderSide.none, // Remove the border side
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide:
                                  BorderSide.none, // Remove the border side
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide:
                                  BorderSide.none, // Remove the border side
                            ),
                            filled: true,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                          ),
                          onChanged: (query) {
                            setState(() {
                              _searchQuery = query;
                              _updateFilteredOrders(); // Update filtered orders on search query change
                            });
                          },
                        ),
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("Order", style: TextStyle(color: Colors.grey)),
                          Text("Due Date",
                              style: TextStyle(color: Colors.grey)),
                          Text("Delivered",
                              style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            _buildOrderList('All'),
                            _buildOrderList('Delivered'),
                            _buildOrderList('Pending'),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 170,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.darkGreen,
                          ),
                          onPressed: _showAddOrderDialog,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                              SizedBox(width: 8),
                              Text('Add Order',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                      //considering this, as our bottom bar
                      const SizedBox(
                        width: double.infinity,
                        height: 80,
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }

  Widget _buildOrderList(String filter) {
    return ListView.builder(
      itemCount: filteredOrders.length,
      itemBuilder: (context, index) {
        final order = filteredOrders[index];
        return Orderline(
          order: order,
          markOrderAsDelivered: _markOrderAsDelivered,
          deleteOrder: _deleteOrder,
        );
      },
    );
  }
}

//it is adding the order immediately to the list of orders
//and it is also moving the delivred ones to their respective page
