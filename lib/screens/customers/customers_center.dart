import 'package:business_assistant/style/containers.dart';
import 'package:business_assistant/widget/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:business_assistant/data/customers.dart'; // Import the customers.dart file
import 'package:business_assistant/data/orders.dart';
import 'package:business_assistant/style/colors.dart';

class customersPage extends StatefulWidget {
  const customersPage({super.key});

  @override
  State<customersPage> createState() => _customersPageState();
}

class _customersPageState extends State<customersPage> {
  //controllers for each input field
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _customerPhoneController =
      TextEditingController();
  final TextEditingController _customerEmailController =
      TextEditingController();
  final TextEditingController _customerAddressController =
      TextEditingController();
  final TextEditingController _customerNoteController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  List<Customer> customersList =
      customers; //take the customers from the data file

  //we need to add the filter for the customers
  String _searchQuery = '';
  String _selectedSortOption = 'Orders count';
  String phoneError = '';
  String emailError = '';
  String addressError = '';
  String nameError = '';

  void _sortCustomers() {
    setState(() {
      if (_selectedSortOption == 'Customer name') {
        customersList.sort((a, b) => a.name.compareTo(b.name));
      } else if (_selectedSortOption == 'Orders count') {
        //sorting in an ascending order
        customersList
            .sort((a, b) => b.ordersCount().compareTo(a.ordersCount()));
      }
    });
  }

  List<Customer> _filterCustomers(String filter) {
    List<Customer> filteredCustomers =
        customersList; // first we have all the customers
    if (_searchQuery.isNotEmpty) {
      filteredCustomers = filteredCustomers.where((customer) {
        return customer.name.toLowerCase().contains(_searchQuery
            .toLowerCase()); // check if the name contains the one that was typed
      }).toList();
    }
    return filteredCustomers;
  }

  void _showAddCustomerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {

        return AlertDialog(
          title: const Text('Add Customer'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Customer Name'),
                controller: _customerNameController,
                onChanged: (value) {
                  setState(() {
                    if (value.isEmpty) {
                      nameError = 'Name of customer must be filled';
                    } else {
                      nameError = '';
                    }
                  });
                },
              ),
              Text(
                nameError,
                style: const TextStyle(color: Colors.red),
              ),
              TextField(
                controller: _customerPhoneController,
                decoration:
                    const InputDecoration(labelText: 'Customer phone number'),
                keyboardType: TextInputType.phone,
                onChanged: (value) {
                  setState(() {
                    if (value.isEmpty) {
                      phoneError = 'Please enter a phone number';
                    } else if (!RegExp(r'^[0-9]*$').hasMatch(value)) {
                      phoneError = 'Please enter a valid number';
                    } else {
                      phoneError = '';
                    }
                  });
                },
              ),
              Text(
                phoneError,
                style: const TextStyle(color: Colors.red),
              ),
              TextField(
                controller: _customerEmailController,
                decoration: const InputDecoration(labelText: 'Customer Email'),
                onChanged: (value) {
                  setState(() {
                    if (value.isEmpty) {
                      emailError = 'Please enter an email';
                    } else if (!RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value)) {
                      emailError = 'Please enter a valid email';
                    } else {
                      emailError = '';
                    }
                  });
                },
              ),
              Text(
                emailError,
                style: const TextStyle(color: Colors.red),
              ),
              TextField(
                controller: _customerAddressController,
                decoration:
                    const InputDecoration(labelText: 'Customer Address'),
                //it can be empty address
              ),
              TextField(
                controller: _customerNoteController,
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
                  if (_customerNameController.text.isEmpty) {
                    nameError = 'Name of customer must be filled';
                  }
                  if (_customerPhoneController.text.isEmpty) {
                    phoneError = 'Please enter a phone number';
                  } else if (!RegExp(r'^[0-9]*$')
                      .hasMatch(_customerPhoneController.text)) {
                    phoneError = 'Please enter a valid number';
                  }
                  if (_customerEmailController.text.isEmpty) {
                    emailError = 'Please enter an email';
                  } else if (!RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(_customerEmailController.text)) {
                    emailError = 'Please enter a valid email';
                  }
                });

                if (nameError.isNotEmpty ||
                    phoneError.isNotEmpty ||
                    emailError.isNotEmpty) {
                  return;
                }

                // Adding an item it means that we will append a new customer in the list of customers
                // if none of them is empty then add the customer
                if (_customerNameController.text.isEmpty ||
                    _customerPhoneController.text.isEmpty ||
                    _customerEmailController.text.isEmpty ||
                    _customerAddressController.text.isEmpty) {
                  return;
                }

                // Email validation
                String email = _customerEmailController.text;
                bool emailValid = RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(email);
                if (!emailValid) {
                  // Show an error message or handle the invalid email case
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Invalid email address')),
                  );
                  return;
                }

                setState(() {
                  customersList.add(Customer(
                      customerID: customers.length + 1,
                      name: _customerNameController.text,
                      address: _customerAddressController.text,
                      phone_num: _customerPhoneController.text,
                      email: _customerEmailController.text,
                      note: _customerNoteController.text,
                      orders: []));
                  // empty orders at first because it is a new customer
                  // clear the text fields
                  _customerNameController.clear();
                  _customerPhoneController.clear();
                  _customerEmailController.clear();
                  _customerAddressController.clear();
                  _customerNoteController.clear();
                });

                Navigator.of(context).pop();
              },
              child: const Text('Add customer'),
              // its adding the customers to the list
            ),
          ],
        );
      },
    );
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
      //ADDING THE BACKGROUND IMAGE
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
                    Text("Customer",
                        style: TextStyle(color: Colors.grey)),
                    Text("Orders", style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  children: filteredCustomers.map((customer) {
                    return CustomerLine(
                        customerId: customer.customerID,
                        customerName: customer.name,
                        ordersCount: customer.orders.length,
                        customeObj: customer);
                  }).toList(),
                ),
              ),
              SizedBox(
                width: 170,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.darkGreen,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                  ),
                  onPressed: () {
                    _showAddCustomerDialog();
                  },
                  child: const Row(
                    children: [
                      Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      Text(
                        'Add customer',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 80,
                //for the bottom bar
              )
            ],
          ),
        ],
      ),
    );
  }
}

class CustomerLine extends StatelessWidget {
  final int customerId;
  final String customerName;
  final int ordersCount;
  final Customer customeObj;
  const CustomerLine(
      {super.key,
      required this.customerId,
      required this.customerName,
      required this.ordersCount,
      required this.customeObj});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //takes us to the details, passing the needed arguments too through pages
      onTap: () {
        Navigator.pushNamed(
          context,
          '/customerDetails',
          arguments:
              customeObj, //pass the id of the customer to be able to get the details
        );
      },
      child: Container(
        margin: const EdgeInsets.all(3),
        height: 50,
        decoration: BoxDecoration(
          color: AppColors.darkGreen,
          borderRadius: roundedRadius,
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(customerName,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              Text(ordersCount.toString(),
                  style: const TextStyle(color: Colors.white)),
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
  // Default selected value
  String selectedValue = "Orders count";

  // Options for the dropdown menu
  final List<String> dropdownOptions = [
    "Orders count",
    "Customer name",
  ];

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
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Sort by: ",
              style: TextStyle(
                fontSize: 13,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            DropdownButton<String>(
              value: selectedValue,
              icon: const Icon(Icons.arrow_drop_down,
                  color: Colors.deepPurple, size: 18),
              iconSize: 18,
              elevation: 16,
              style: const TextStyle(
                color: Colors.deepPurple,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              underline: Container(), // Remove default underline
              onChanged: (String? newValue) {
                setState(() {
                  selectedValue = newValue!;
                  widget.onChanged(newValue);
                });
              },
              items:
                  dropdownOptions.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}



//adding the customer is shown immediatly 
