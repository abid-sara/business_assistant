import 'package:business_assistant/database/db_customer.dart';
import 'package:business_assistant/database/db_order.dart';
import 'package:business_assistant/database/db_product.dart';
import 'package:business_assistant/models/order.dart';
import 'package:business_assistant/models/customer.dart';
import 'package:business_assistant/style/colors.dart';
import 'package:business_assistant/widget/sidebar.dart';
import 'package:business_assistant/widget/orderLine.dart';
import 'package:flutter/material.dart';
import 'package:business_assistant/models/product.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<Order> filteredOrders = [];
  List<Order> ordersCenter = [];
  List<Customer> customers = [];
  List<Product> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_updateFilteredOrders);
    _initializeData();
  }

     
   Future<void> _fetchAndUpdateOrders() async {
  try {
    // Fetch orders and map customers
    List<Order> ordersUnformatted = await displayOrder();
    print("Orders fetched: ${ordersUnformatted.length}");

    setState(() {
      ordersCenter = ordersUnformatted;
      print("Orders mapped: ${ordersCenter.length}");
    });

    // Initially filter all orders
    filteredOrders = await _filterOrders('All');
    print("Orders filtered: ${filteredOrders.length}");
  } catch (e) {
    print("Error fetching and updating orders: $e");
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error loading orders: $e')));
  }
}

Future<void> _initializeData() async {
  try {
    // Fetch customers
    customers = await displayCustomer();
    print("Fetched customers: $customers");
    customers.forEach((customer) => print("Customer: $customer"));

    print("Customers fetched: ${customers.length}");

    // Fetch products
    products = await displayProduct();
    print("Products fetched: ${products.length}");

    // Extract product names
    List<String> productNames = products.map((product) => product.name).toList();
    print("Product names extracted: ${productNames.length}");

    // Fetch orders
    List<Map<String, dynamic>> ordersUnformatted = await showOrders();
    print("Orders fetched: ${ordersUnformatted.length}");

    // Resolve all orders
   final futures = ordersUnformatted.map((map) async {
  try {
    final customerId = map['customer_id'];
    if (customerId == null) {
      print("Error: customer_id is null.");
      return null; // Skip invalid orders
    }

    final customer = customers.firstWhere(
      (c) => c.id == customerId,
      orElse: () => Customer(
        id: 0,
        name: '',
        address: '',
        phoneNum: '',
        email: '',
        note: '',
        deleted: 0,
      ),
    );

    if (customer.id == 0) {
      print("Warning: Placeholder customer used for order with customer_id: $customerId");
    }

    await _fetchAndUpdateOrders();
  } catch (e) {
    print("Error mapping order: $e");
    return null; // Handle invalid order gracefully
  }
});

// Filter out null futures and wait for the remaining ones
ordersCenter = await Future.wait(futures.whereType<Future<Order>>());
print("Orders mapped: ${ordersCenter.length}");


    // Remove null entries
    ordersCenter.removeWhere((order) => order == null);
    print("Orders mapped: ${ordersCenter.length}");

    // Filter all orders
    filteredOrders = await _filterOrders('All');
    print("Orders filtered: ${filteredOrders.length}");
  } catch (e) {
    print("Error initializing data: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error loading data: $e')),
    );
  } finally {
    setState(() {
  filteredOrders = ordersCenter;
});

  }
}



  Future<List<Order>> _filterOrders(String filter) async {
    List<Order> filtered = ordersCenter;

    if (filter != 'All') {
      filtered = ordersCenter.where((order) => order.status == filter.toLowerCase()).toList();
    }

    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((order) {
        final customerName = order.customer.name.toLowerCase();
        return order.id.toString().contains(_searchQuery) ||
            customerName.contains(_searchQuery.toLowerCase());
      }).toList();
    }

    return filtered;
  }

  Future<void> _updateFilteredOrders() async {
    final filter = _tabController.index == 0
        ? 'All'
        : _tabController.index == 1
            ? 'Delivered'
            : 'Pending';
    filteredOrders = await _filterOrders(filter);
    setState(() {});
  }

  void _showAddOrderDialog() async {
  final TextEditingController deliveryPriceController = TextEditingController();
  final TextEditingController deliveryDateController = TextEditingController();
  final TextEditingController deliveryAddressController = TextEditingController();
  final TextEditingController orderDateController = TextEditingController();
  List<Map<String, dynamic>> selectedProducts = [];
  Customer? selectedCustomer;

  // Ensure products are loaded before showing the dialog
  List<Product> products = await displayProduct();

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
              child: Column(
                children: [
                  // Product selection
                  ...selectedProducts.asMap().entries.map((entry) {
                    int index = entry.key;
                    Map<String, dynamic> productData = entry.value;
                    return Column(
                      children: [
                        DropdownButtonFormField<Product>(
                          decoration: const InputDecoration(labelText: 'Product'),
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
                          decoration: const InputDecoration(labelText: 'Quantity'),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {
                              productData['quantity'] = int.tryParse(value) ?? 1;
                            });
                          },
                          controller: TextEditingController(text: productData['quantity'].toString()),
                        ),
                        IconButton(
                          icon: const Icon(Icons.remove_circle),
                          onPressed: () {
                            removeProductField(index, setState);
                          },
                        ),
                      ],
                    );
                  }).toList(),
                  TextButton(
                    onPressed: () => addProductField(setState),
                    child: const Text('Add Product'),
                  ),
                  // Customer selection
                  DropdownButtonFormField<Customer>(
  decoration: const InputDecoration(labelText: 'Customer'),
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
    print("Customer selected: ${newValue?.name}, ID: ${newValue?.id}");
  },
  value: selectedCustomer,
),

                  TextField(
                    controller: orderDateController,
                    decoration: const InputDecoration(labelText: 'Order Date'),
                    keyboardType: TextInputType.datetime,
                  ),
                  TextField(
                    controller: deliveryDateController,
                    decoration: const InputDecoration(labelText: 'Delivery Date'),
                    keyboardType: TextInputType.datetime,
                  ),
                  TextField(
                    controller: deliveryPriceController,
                    decoration: const InputDecoration(labelText: 'Delivery Price'),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: deliveryAddressController,
                    decoration: const InputDecoration(labelText: 'Delivery Address'),
                  ),
                ],
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
    if (selectedCustomer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a customer.')),
      );
      return;
    }

    // Validate `customer_id`
    print("Adding order for Customer ID: ${selectedCustomer!.id}");

    Map<String, dynamic> orderData = {
  'price': selectedProducts.fold(0.0, (sum, item) =>
      sum + (item['product']?.unitPrice ?? 0.0) * (item['quantity'] ?? 1)),
  'delivery_price': double.tryParse(deliveryPriceController.text) ?? 0.0,
  'delivery_date': deliveryDateController.text.isEmpty ? null : deliveryDateController.text,
  'delivery_address': deliveryAddressController.text.isEmpty ? '' : deliveryAddressController.text,
  'order_date': orderDateController.text.isEmpty ? null : orderDateController.text,
  'status': 'pending',
  'deleted': 0,
  'customer_id': selectedCustomer!.id,
};


    try {
  int orderId = await addOrder(order: orderData, products: selectedProducts);
  if (orderId > 0) {
    setState(() {
      ordersCenter.add(Order(
        id: orderId,
        totalPrice: orderData['price'],
        deliveryPrice: orderData['delivery_price'],
        deliveryDate: orderData['delivery_date'] ?? '',
        deliveryAddress: orderData['delivery_address'] ?? '',
        orderDate: orderData['order_date'] ?? '',
        status: orderData['status'],
        deleted: orderData['deleted'],
        customer: selectedCustomer!,
      ));
    });

    filteredOrders = await _filterOrders('All');
    Navigator.of(context).pop();
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Failed to add order.')),
    );
  }
} catch (e) {
  print("Error adding order: $e");
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Error adding order: $e')),
  );
}
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




  void _deleteOrder(Order order, Customer customer) async {
    try {
      bool success = await deleteOrder(order.id, customer.id);
      if (success) {
        setState(() {
          ordersCenter.remove(order);
          filteredOrders.remove(order);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order deleted successfully.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting order: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Sidebar(),
      appBar: AppBar(
        title: const Text('Orders Center'),
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
      body: 
           Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Search orders...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onChanged: (query) {
                      _searchQuery = query;
                      _updateFilteredOrders();
                    },
                  ),
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
                ElevatedButton(
                  onPressed: _showAddOrderDialog,
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.darkGreen),
                  child: const Text('Add Order'),
                ),
              ],
            ),
    );
  }

  Widget _buildOrderList(String filter) {
  return ListView.builder(
    itemCount: filteredOrders.length,
    itemBuilder: (context, index) {
      final order = filteredOrders[index];
      return Orderline(
        order: order,
        markOrderAsDelivered: (o) async => await _markOrderAsDelivered(o),
        deleteOrder: (order, customer) => _deleteOrder(order, customer),
      );
    },
  );
}


  Future<bool> _markOrderAsDelivered(Order order) async {
    try {
      bool success = await updateOrderStatus(order.id, 'delivered');
      if (success) {
        await _updateFilteredOrders();
        return true;
      }
      return false;
    } catch (e) {
      print("Error marking order as delivered: $e");
      return false;
    }
  }
}

class DetailsBox extends StatefulWidget {
  final Order order;

  const DetailsBox({super.key, required this.order});

  @override
  State<DetailsBox> createState() => _DetailsBoxState();
}

class _DetailsBoxState extends State<DetailsBox> {
  late List<Map<String, dynamic>> products = [];
  double totalPriceOfProduct = 0.0;

  @override
  void initState() {
    super.initState();
    _initialize(widget.order);
  }

  Future<void> _initialize(Order order) async {
  try {
    // Fetch the products for this order
    List<Map<String, dynamic>> rawProducts = await getProductsForOrder(order.id);

    // Check if rawProducts is null or empty
    if (rawProducts == null || rawProducts.isEmpty) {
      products = []; // Assign an empty list if no products are found
    } else {
      products = rawProducts.map((entry) {
        // Ensure unitPrice and quantity are not null, default to 0.0 and 0 respectively
        double unitPrice = (entry['unitPrice'] ?? 0.0).toDouble(); // Make sure it's a valid double
        int quantity = (entry['quantity'] ?? 0);      // Default to 0 if null

        // Check that unitPrice and quantity are valid numbers before multiplying
        double total = unitPrice * quantity; // Only multiply when values are non-null

        return {
          'name': entry['name'],
          'unitPrice': unitPrice,
          'quantity': quantity,
          'total': total, // Corrected the total field
          'supplierName': entry['supplierName'],
          'supplierPhoneNum': entry['supplierPhoneNum'],
          'supplierAddress': entry['supplierAddress'],
          'productDescription': entry['productDescription'],
          'minimumQuantity': entry['minimumQuantity'],
          'additionalInfo': entry['additionalInfo'],
          'productImage': entry['productImage'],
        };
      }).toList();
    }

    // Get the total price including delivery
    totalPriceOfProduct = await getTotalWithDelivery(order.id);

    // After initialization, update the UI
    setState(() {});
  } catch (e) {
    print("Error initializing details: $e");
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order ID: ${widget.order.id}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('Customer: ${widget.order.customer.name}'),
            const SizedBox(height: 10),
            Text('Delivery Address: ${widget.order.deliveryAddress}'),
            const SizedBox(height: 10),
            Text('Order Date: ${widget.order.orderDate}'),
            const SizedBox(height: 10),
            Text('Delivery Date: ${widget.order.deliveryDate}'),
            const SizedBox(height: 10),
            Text(
              'Total Price: \$${totalPriceOfProduct.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text('Products:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ListTile(
                    title: Text(product['name']),
                    subtitle: Text(
                      'Unit Price: \$${product['unitPrice']}, Quantity: ${product['quantity']}}',
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
