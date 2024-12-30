import 'package:business_assistant/cubits/customer/customer_cubit.dart';
import 'package:business_assistant/cubits/customer/customer_state.dart';
import 'package:business_assistant/cubits/customer/validation_cubit.dart';
import 'package:business_assistant/cubits/order/order_cubit.dart';
import 'package:business_assistant/cubits/order/order_state.dart';
import 'package:business_assistant/widget/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:business_assistant/style/colors.dart';
import 'package:business_assistant/models/customer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomersPage extends StatelessWidget {
  CustomersPage({super.key});

  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _customerPhoneController =
      TextEditingController();
  final TextEditingController _customerEmailController =
      TextEditingController();
  final TextEditingController _customerAddressController =
      TextEditingController();
  final TextEditingController _customerNoteController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  void _clearCustomerInputFields() {
    _customerNameController.clear();
    _customerPhoneController.clear();
    _customerEmailController.clear();
    _customerAddressController.clear();
    _customerNoteController.clear();
  }

  void _showAddCustomerDialog(BuildContext context, CustomerCubit cubit) {
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return BlocProvider.value(
          value: context.read<ValidationCustomerCubit>(),
          child: BlocBuilder<ValidationCustomerCubit, ValidationState>(
            builder: (context, validationState) {
              return AlertDialog(
                title: const Text('Add Customer'),
                content: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: _customerNameController,
                          decoration:
                              const InputDecoration(labelText: 'Customer Name'),
                          onChanged: (value) => context
                              .read<ValidationCustomerCubit>()
                              .validateCustomerName(value),
                          validator: (_) =>
                              validationState.customerNameError.isEmpty
                                  ? null
                                  : validationState.customerNameError,
                        ),
                        TextFormField(
                          controller: _customerPhoneController,
                          decoration:
                              const InputDecoration(labelText: 'Phone Number'),
                          onChanged: (value) => context
                              .read<ValidationCustomerCubit>()
                              .validateCustomerPhoneNumber(value),
                          validator: (_) =>
                              validationState.customerPhoneError.isEmpty
                                  ? null
                                  : validationState.customerPhoneError,
                        ),
                        TextFormField(
                          controller: _customerEmailController,
                          decoration: const InputDecoration(labelText: 'Email'),
                          onChanged: (value) => context
                              .read<ValidationCustomerCubit>()
                              .validateCustomerEmail(value),
                          validator: (_) =>
                              validationState.customerEmailError.isEmpty
                                  ? null
                                  : validationState.customerEmailError,
                        ),
                        TextFormField(
                          controller: _customerAddressController,
                          decoration:
                              const InputDecoration(labelText: 'Address'),
                          validator: (value) => value?.isEmpty ?? true
                              ? 'Please enter the address'
                              : null,
                        ),
                        TextFormField(
                          controller: _customerNoteController,
                          decoration: const InputDecoration(
                              labelText: 'Additional Notes'),
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                      _clearCustomerInputFields();
                      context.read<ValidationCustomerCubit>().clearForm();
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        final newCustomer = Customer(
                          name: _customerNameController.text,
                          address: _customerAddressController.text,
                          phoneNum: _customerPhoneController.text,
                          email: _customerEmailController.text,
                          note: _customerNoteController.text,
                          deleted: 0,
                        );
                        cubit.addCustomer(newCustomer);
                        _clearCustomerInputFields();
                        context.read<ValidationCustomerCubit>().clearForm();
                        Navigator.of(dialogContext).pop();
                      }
                    },
                    child: const Text('Add Customer'),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerCubit, CustomerState>(
      builder: (context, state) {
        final cubit = context.read<CustomerCubit>();

        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.read<OrderCubit>().loadOrders(); // Ensure orders are loaded
        });

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
                                filled: true,
                              ),
                              onChanged: (query) =>
                                  cubit.filterCustomers(query),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SortByDropdown(
                            currentValue: state.currentSortOption,
                            onChanged: (String newValue) =>
                                cubit.sortCustomers(newValue),
                          ),
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
                    child: _buildCustomerList(state),
                  ),
                  SizedBox(
                    width: 170,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.darkGreen,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                      ),
                      onPressed: () => _showAddCustomerDialog(context, cubit),
                      child: const Row(
                        children: [
                          Icon(Icons.add, color: Colors.white),
                          Text('Add Customer',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                  Container(height: 80)
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

Widget _buildCustomerList(CustomerState state) {
  final List<Customer> customers;
  if (state is CustomerLoaded) {
    customers = state.customers;
  } else if (state is CustomerFiltered) {
    customers = state.filteredCustomers;
  } else if (state is CustomerSorted) {
    customers = state.sortedCustomers;
  } else {
    customers = [];
  }

  return ListView.builder(
    itemCount: customers.length,
    itemBuilder: (context, index) {
      final item = customers[index];
      return CustomerLine(
        customer: item,
      );
    },
  );
}

class CustomerLine extends StatelessWidget {
  final Customer customer;

  const CustomerLine({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/customerDetails',
          arguments: customer,
        );
      },
      child: Container(
        margin: const EdgeInsets.all(3),
        height: 50,
        decoration: const BoxDecoration(
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
              BlocBuilder<OrderCubit, OrderState>(
                builder: (context, state) {
                  final count = context
                      .read<OrderCubit>()
                      .customerOrdersCount(customer.id);
                  return Text(
                    count.toString(),
                    style: const TextStyle(color: Colors.white),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SortByDropdown extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final String currentValue;

  const SortByDropdown({
    super.key,
    required this.onChanged,
    required this.currentValue,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerCubit, CustomerState>(
      builder: (context, state) {
        final cubit = context.read<CustomerCubit>();
        final List<String> dropdownItems = ['Customer name', 'Order count'];
        final String selectedValue = cubit.currentSortOption;

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
                style: TextStyle(
                    fontSize: 13,
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
              ),
              DropdownButton<String>(
                value: selectedValue,
                icon:
                    const Icon(Icons.arrow_drop_down, color: Colors.deepPurple),
                iconSize: 18,
                elevation: 16,
                style: const TextStyle(
                    color: Colors.deepPurple,
                    fontSize: 13,
                    fontWeight: FontWeight.w500),
                underline: Container(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    cubit.sortCustomers(newValue);
                    onChanged(newValue);
                  }
                },
                items: dropdownItems.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}
