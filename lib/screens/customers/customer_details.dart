import 'package:flutter/material.dart';
import 'package:business_assistant/style/colors.dart';
import 'package:business_assistant/widget/button.dart';
import 'package:business_assistant/models/customer.dart';
import 'package:business_assistant/models/order.dart';
import 'package:business_assistant/database/db_order.dart';
import 'package:business_assistant/database/db_customer.dart';

class CustomerDetails extends StatefulWidget {
  const CustomerDetails({super.key});

  @override
  _CustomerDetailsState createState() => _CustomerDetailsState();
}

class _CustomerDetailsState extends State<CustomerDetails> {
  Customer? _customer;
  List<Order> _orders = [];
  late int customerId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      customerId = ModalRoute.of(context)!.settings.arguments as int;
      _fetchCustomerDetails();
    });
  }
  Future<void> _showEditCustomerDialog(Customer? customer) async {
  final nameController = TextEditingController(text: customer!.name);
  final addressController = TextEditingController(text: customer.address);
  final phoneController = TextEditingController(text: customer.phoneNum);
  final emailController = TextEditingController(text: customer.email);
  final noteController = TextEditingController(text: customer.note);

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Edit Customer'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(labelText: 'Address'),
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: noteController,
                decoration: const InputDecoration(labelText: 'Notes'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              // Create an updated customer object
              final updatedCustomer = Customer(
                id: customer.id,
                name: nameController.text,
                address: addressController.text,
                phoneNum: phoneController.text,
                email: emailController.text,
                note: noteController.text,
                deleted: customer.deleted,
              );

              // Update in the database
              await updateCustomer(updatedCustomer);

              // Refresh the customer details
              setState(() {
                _customer = updatedCustomer;
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


  Future<void> _fetchCustomerDetails() async {
    try {
     
      final customerMap = await getCustomerById(customerId);
      final Customer customer = Customer.fromMap(customerMap);
      final List orders = await getOrdersForCustomer(customerId);
      //add a debugging print statement
      print('customer_id' +customerId.toString());
      setState(() {
        _customer = customer;
        _orders = orders.cast<Order>();
      });
    } catch (e) {
      print("Error fetching customer details: $e");
    }
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(_customer?.name ?? "Loading..."),
      
    ),
    body: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/background.png"), 
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _customer == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 4,
                    margin: const EdgeInsets.only(bottom: 16.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Personal Information',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                               IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  _showEditCustomerDialog( _customer);
                                },
                              ),
                            ],
                          ),
                          Text("Name: ${_customer!.name}"),
                          Text("Address: ${_customer!.address}"),
                          Text("Phone number: ${_customer!.phoneNum}"),
                          Text("Email: ${_customer!.email}"),
                          Text("Note: ${_customer!.note}"),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Customer Orders',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text("Orders count: ${_orders.length}"),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: _orders.isEmpty
                        ? const Center(
                            child: Text(
                              "No orders yet for the customer...",
                              style: TextStyle(fontSize: 16),
                            ),
                          )
                        : ListView.builder(
                            itemCount: _orders.length,
                            itemBuilder: (context, index) {
                              final order = _orders[index];
                              return Card(
                                elevation: 2,
                                margin: const EdgeInsets.symmetric(vertical: 8.0),
                                child: ListTile(
                                  title: Text('Order ID: ${order.id}'),
                                  subtitle: Text(
                                    'Total Price: \$${order.totalPrice.toStringAsFixed(2)}',
                                  ),
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/orderDetails',
                                      arguments: order,
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/addOrder',
                          arguments: _customer,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.darkGreen,
                        padding: const EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 24.0,
                        ),
                      ),
                      child: const Text(
                        "Add Order",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    ),
  );
}


  Widget _buildPersonalInfoSection() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Personal Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    _showEditCustomerDialog( _customer);
                  },
                ),


              ],
            ),
            Text('Name: ${_customer!.name}'),
            Text('Address: ${_customer!.address}'),
            Text('Phone number: ${_customer!.phoneNum}'),
            Text('Email: ${_customer!.email}'),
            Text('Note: ${_customer!.note}'),
          ],
        ),
      ),
    );
  }

}