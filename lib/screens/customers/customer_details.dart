import 'package:business_assistant/cubits/customer/customer_cubit.dart';
import 'package:business_assistant/cubits/customer/customer_state.dart';
import 'package:business_assistant/cubits/order/order_cubit.dart';
import 'package:business_assistant/cubits/order/order_state.dart';
import 'package:flutter/material.dart';
import 'package:business_assistant/style/colors.dart';
import 'package:business_assistant/models/customer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomerDetails extends StatelessWidget {
  CustomerDetails({super.key});

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  void _populateFields(Customer customer) {
    _nameController.text = customer.name;
    _addressController.text = customer.address;
    _phoneController.text = customer.phoneNum;
    _emailController.text = customer.email;
    _noteController.text = customer.note;
  }

  Future<void> _showEditCustomerDialog(
      BuildContext context, Customer customer) async {
    _populateFields(customer);

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocConsumer<CustomerCubit, CustomerState>(
          listener: (context, state) {
            if (state is CustomerUpdated) {
              Navigator.of(context).pop();
              context.read<OrderCubit>().loadOrders();

              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Customer Updated Successfuly")));
            } else if (state is CustomerError) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Failed to update customer")));
            }
          },
          builder: (context, state) {
            return AlertDialog(
              title: const Text('Edit Customer'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                    ),
                    TextField(
                      controller: _addressController,
                      decoration: const InputDecoration(labelText: 'Address'),
                    ),
                    TextField(
                      controller: _phoneController,
                      decoration:
                          const InputDecoration(labelText: 'Phone Number'),
                    ),
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                    ),
                    TextField(
                      controller: _noteController,
                      decoration: const InputDecoration(labelText: 'Notes'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.read<OrderCubit>().loadOrders();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    final id = customer.id;
                    final updatedCustomer = Customer(
                      id: customer.id,
                      name: _nameController.text,
                      address: _addressController.text,
                      phoneNum: _phoneController.text,
                      email: _emailController.text,
                      note: _noteController.text,
                      deleted: customer.deleted,
                    );

                    context
                        .read<CustomerCubit>()
                        .updateCustomer(id, updatedCustomer);
                    Navigator.of(context).pop();
                    context.read<OrderCubit>().loadOrders();
                  },
                  child: const Text('Save'),
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
    return BlocConsumer<CustomerCubit, CustomerState>(
      listener: (context, state) {
        if (state is CustomerDeleted) {
          context.read<CustomerCubit>().fetchCustomers();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Customer deleted successfully')),
          );
        } else if (state is CustomerError) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to delete customer')),
          );
        }
      },
      builder: (context, state) {
        final originalCustomer =
            ModalRoute.of(context)!.settings.arguments as Customer;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.read<OrderCubit>()
            ..setCurrentCustomer(originalCustomer)
            ..loadCustomerOrders();
        });

        Customer displayCustomer = originalCustomer;

        if (state is CustomerLoaded) {
          displayCustomer = state.customers.firstWhere(
            (p) => p.id == originalCustomer.id,
            orElse: () => originalCustomer,
          );
        } else if (state is CustomerUpdated &&
            state.updatedCustomer.id == originalCustomer.id) {
          displayCustomer = state.updatedCustomer;
        } else {
          // Default to the original customer if no updates are found
          displayCustomer = originalCustomer;
        }

        return _buildScaffold(context, displayCustomer);
      },
    );
  }

  Widget _buildScaffold(BuildContext context, Customer customer) {
    return BlocBuilder<CustomerCubit, CustomerState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(customer.name),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
                context.read<OrderCubit>().loadOrders();
              },
            ),
          ),
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Personal Information Card
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
                                  _showEditCustomerDialog(context, customer);
                                },
                              ),
                              GestureDetector(
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.grey[800],
                                ),
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Delete Customer'),
                                      content: const Text(
                                          'Are you sure you want to delete this customer?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            if (customer.id != null) {
                                              context
                                                  .read<CustomerCubit>()
                                                  .deleteCustomer(customer.id);
                                              Navigator.of(context).pop();
                                              Navigator.of(context).pop();
                                              context
                                                  .read<OrderCubit>()
                                                  .loadOrders();
                                            }
                                          },
                                          child: const Text('Delete'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          Text("Name: ${customer.name}"),
                          Text("Address: ${customer.address}"),
                          Text("Phone number: ${customer.phoneNum}"),
                          Text("Email: ${customer.email}"),
                          Text("Note: ${customer.note}"),
                        ],
                      ),
                    ),
                  ),

                  // Orders Header Row
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
                      BlocBuilder<OrderCubit, OrderState>(
                        builder: (context, state) {
                          if (state is OrderLoaded) {
                            return Text("Orders count: ${state.orders.length}");
                          }
                          return const Text("Orders count: 0");
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Orders List
                  Expanded(
                    child: BlocBuilder<OrderCubit, OrderState>(
                      builder: (context, state) {
                        if (state is OrderLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is OrderLoaded) {
                          final customerOrders = state.orders;

                          if (customerOrders.isEmpty) {
                            return const Center(
                              child: Text(
                                "No orders yet for the customer...",
                                style: TextStyle(fontSize: 16),
                              ),
                            );
                          }

                          return ListView.builder(
                            itemCount: customerOrders.length,
                            itemBuilder: (context, index) {
                              final order = customerOrders[index];
                              return Card(
                                elevation: 2,
                                margin:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: ListTile(
                                  title: Text('Order ID: ${order.id}'),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Total Price: ${order.totalPrice.toStringAsFixed(2)}  DZD',
                                      ),
                                      Text(
                                        'Status: ${order.status}',
                                        style: TextStyle(
                                          color: order.status.toLowerCase() ==
                                                  'delivered'
                                              ? AppColors.darkGreen
                                              : Colors.red,
                                        ),
                                      ),
                                      Text('Order Date: ${order.orderDate}'),
                                    ],
                                  ),
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/details',
                                      arguments: order,
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        } else if (state is OrderError) {
                          return Center(
                            child: Text(
                              'Error loading orders: ${state.message}',
                              style: const TextStyle(color: Colors.red),
                            ),
                          );
                        }
                        return const Center(
                          child: Text("Loading orders..."),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
