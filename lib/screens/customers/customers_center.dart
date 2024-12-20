import 'package:business_assistant/widget/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:business_assistant/style/colors.dart';
import 'package:business_assistant/models/customer.dart';
import 'package:business_assistant/database/db_customer.dart';

class CustomersPage extends StatefulWidget {
  const CustomersPage({super.key});

  @override
  State<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  // Controllers for each input field
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _customerPhoneController = TextEditingController();
  final TextEditingController _customerEmailController = TextEditingController();
  final TextEditingController _customerAddressController = TextEditingController();
  final TextEditingController _customerNoteController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  List<Customer> customersList = []; // Initially empty, will be loaded from DB

  String _searchQuery = '';
  String _selectedSortOption = 'Orders count';
  String phoneError = '';
  String emailError = '';
  String addressError = '';
  String nameError = '';

  @override
  void initState() {
    super.initState();
    _getCustomers(); // Fetch customers when the page loads
  }
  

  // Fetch customers from the database
 Future<void> _getCustomers() async {
  try {
    List<Object> fetchedCustomers = await showCustomers();
    print("Fetched customers: $fetchedCustomers"); 
    setState(() {
      customersList = fetchedCustomers.cast<Customer>();
    });
  } catch (e) {
    print("Error loading customers: $e");
  }
}



  // Sorting function
  void _sortCustomers() {
    setState(() {
      if (_selectedSortOption == 'Customer name') {
        customersList.sort((a, b) => a.name.compareTo(b.name));
      } else if (_selectedSortOption == 'Orders count') {
        customersList.sort((a, b) => b.ordersCountValue.compareTo(a.ordersCountValue));
      }
    });
  }

  // Filter customers based on search query
  List<Customer> _filterCustomers(String filter) {
    if (filter.isEmpty) {
      return customersList;
    }
    return customersList.where((customer) {
      return customer.name.toLowerCase().contains(filter.toLowerCase());
    }).toList();
  }

  // Show add customer dialog
  void _showAddCustomerDialog({Customer? customer}) {
  // Pre-fill fields if a customer is provided
  if (customer != null) {
    _customerNameController.text = customer.name;
    _customerPhoneController.text = customer.phoneNum;
    _customerEmailController.text = customer.email;
    _customerAddressController.text = customer.address;
    _customerNoteController.text = customer.note;
  } else {
    _clearCustomerInputFields(); // Clear fields for a new customer
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(customer == null ? 'Add Customer' : 'Edit Customer'),
        content: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // All input fields remain the same
                TextField(
                  decoration: const InputDecoration(labelText: 'Customer Name'),
                  controller: _customerNameController,
                ),
                TextField(
                  controller: _customerPhoneController,
                  decoration: const InputDecoration(labelText: 'Customer phone number'),
                ),
                TextField(
                  controller: _customerEmailController,
                  decoration: const InputDecoration(labelText: 'Customer Email'),
                ),
                TextField(
                  controller: _customerAddressController,
                  decoration: const InputDecoration(labelText: 'Customer Address'),
                ),
                TextField(
                  controller: _customerNoteController,
                  decoration: const InputDecoration(labelText: 'Additional Notes'),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _clearCustomerInputFields();
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (customer == null) {
                // Adding a new customer
                final newCustomer = {
                  'name': _customerNameController.text,
                  'address': _customerAddressController.text,
                  'phone_num': _customerPhoneController.text,
                  'email': _customerEmailController.text,
                  'note': _customerNoteController.text,
                  'deleted': 0,
                };
                await insertCustomer(newCustomer);
              } else {
                // Editing an existing customer
                customer.name = _customerNameController.text;
                customer.phoneNum = _customerPhoneController.text;
                customer.email = _customerEmailController.text;
                customer.address = _customerAddressController.text;
                customer.note = _customerNoteController.text;

                await updateCustomer(customer); // Update the customer in the database
              }
              _clearCustomerInputFields();
              Navigator.of(context).pop();
              _getCustomers(); // Refresh the customer list
            },
            child: Text(customer == null ? 'Add Customer' : 'Update Customer'),
          ),
        ],
      );
    },
  );
}


  // Clear input fields after adding a customer
  void _clearCustomerInputFields() {
    _customerNameController.clear();
    _customerPhoneController.clear();
    _customerEmailController.clear();
    _customerAddressController.clear();
    _customerNoteController.clear();
  }

  @override
  Widget build(BuildContext context) {
    List<Customer> filteredCustomers = _filterCustomers(_searchQuery);
    return Scaffold(
      drawer: const Sidebar(),
      appBar: AppBar(
        title: const Text("Customers center"),
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
          Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 200,
                        height: 50,
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            labelText: 'Customer...',
                            prefixIcon: const Icon(Icons.search),
                            fillColor: AppColors.purpule,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                          ),
                          onChanged: (query) {
                            setState(() {
                              _searchQuery = query;
                            });
                          },
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SortByDropdown(
                            onChanged: (String newValue) {
                              setState(() {
                                _selectedSortOption = newValue;
                                _sortCustomers();
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Customer", style: TextStyle(color: Colors.grey)),
                    Text("Orders", style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredCustomers.length,
                  itemBuilder: (context, index) {
                    final customer = filteredCustomers[index];
                    return CustomerLine(customer: customer);
                  },
                ),
              ),
              SizedBox(
                width: 170,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.darkGreen,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  onPressed: _showAddCustomerDialog,
                  child: const Row(
                    children: [
                      Icon(Icons.add, color: Colors.white),
                      Text('Add Customer', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              Container(height: 80) // For bottom padding
            ],
          ),
        ],
      ),
    );
  }
}

class CustomerLine extends StatelessWidget {
  final Customer customer;

  const CustomerLine({required this.customer});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to the customer details page with the customer as an argument
        Navigator.pushNamed(
          context,
          '/customerDetails',
          arguments: customer.id,
        );
      },
      child: Container(
        margin: const EdgeInsets.all(3),
        height: 50,
        decoration: BoxDecoration(
          color: AppColors.darkGreen,
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                customer.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                customer.ordersCountValue.toString(),
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class SortByDropdown extends StatefulWidget {
  final ValueChanged<String> onChanged;
  const SortByDropdown({
    super.key,
    required this.onChanged,
  });

  @override
  _SortByDropdownState createState() => _SortByDropdownState();
}

class _SortByDropdownState extends State<SortByDropdown> {
  String selectedValue = "Orders count";

  final List<String> dropdownOptions = ["Orders count", "Customer name"];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 185,
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          const Text(
            "Sort by: ",
            style: TextStyle(fontSize: 13, color: Colors.black, fontWeight: FontWeight.w500),
          ),
          DropdownButton<String>(
            value: selectedValue,
            icon: const Icon(Icons.arrow_drop_down, color: Colors.deepPurple),
            iconSize: 18,
            elevation: 16,
            style: const TextStyle(color: Colors.deepPurple, fontSize: 13, fontWeight: FontWeight.w500),
            underline: Container(),
            onChanged: (String? newValue) {
              setState(() {
                selectedValue = newValue!;
                widget.onChanged(newValue);
              });
            },
            items: dropdownOptions.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
