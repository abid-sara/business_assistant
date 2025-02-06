// ignore_for_file: use_build_context_synchronously

import 'package:business_assistant/cubits/Income/income_repository.dart';
import 'package:business_assistant/cubits/customer/customer_cubit.dart';
import 'package:business_assistant/models/income.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:business_assistant/models/order.dart';
import 'package:business_assistant/models/customer.dart';
import 'package:business_assistant/models/product.dart';
import 'package:business_assistant/cubits/product/product_repository.dart';
import 'package:business_assistant/style/colors.dart';
import 'package:business_assistant/widget/sidebar.dart';
import 'package:business_assistant/widget/orderLine.dart';
import 'package:intl/intl.dart';
import '../../cubits/customer/customer_repository.dart';
import '../../cubits/product/product_cubit.dart';
import '/cubits/order/order_cubit.dart';
import '/cubits/order/order_state.dart';
import 'package:business_assistant/cubits/order/order_repository.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: BlocProvider(
        create: (context) =>
            OrderCubit(repository: OrderRepository())..loadOrders(),
        child: const OrdersView(),
      ),
    );
  }
}

class OrdersView extends StatelessWidget {
  const OrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderCubit, OrderState>(
      listener: (context, state) {
        if (state is OrderError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          drawer: const Sidebar(),
          appBar: AppBar(
            title: const Text('Orders Center'),
            backgroundColor: Colors.white,
            bottom: TabBar(
              onTap: (index) {
                final status = index == 0
                    ? 'All'
                    : index == 1
                        ? 'Delivered'
                        : 'Pending';
                context.read<OrderCubit>().filterOrders(status: status);
              },
              tabs: const [
                Tab(text: 'All'),
                Tab(text: 'Delivered'),
                Tab(text: 'Pending'),
              ],
            ),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SearchBar(
                  onChanged: (query) => context
                      .read<OrderCubit>()
                      .filterOrders(searchQuery: query),
                ),
              ),
              if (state is OrderLoading)
                const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (state is OrderLoaded)
                Expanded(
                  child: TabBarView(
                    children: List.generate(
                      3,
                      (index) => OrderListView(orders: state.filteredOrders),
                    ),
                  ),
                )
              else if (state is OrderError)
                Expanded(
                  child: Center(child: Text(state.message)),
                ),
              const AddOrderButton(),
            ],
          ),
        );
      },
    );
  }
}

// SearchBar
class SearchBar extends StatelessWidget {
  final Function(String) onChanged;

  const SearchBar({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: 'Search orders...',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      onChanged: onChanged,
    );
  }
}

// Order ListView
class OrderListView extends StatelessWidget {
  final List<Order> orders;

  const OrderListView({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderCubit, OrderState>(builder: (context, state) {
      if (orders.isEmpty) {
        return const Center(
          child: Text('No orders found'),
        );
      }
      return ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Orderline(
            order: order,
            markOrderAsDelivered: (o) async {
              await context.read<OrderCubit>().markOrderAsDelivered(o);
              return true;
            },
            deleteOrder: (order, customer) {
              context.read<OrderCubit>().deleteOrder(order);
            },
          );
        },
      );
    });
  }
}

// Add Order Button
class AddOrderButton extends StatelessWidget {
  const AddOrderButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderCubit, OrderState>(
      builder: (context, state) {
        return SizedBox(
          child: ElevatedButton(
            onPressed: () => _showAddOrderDialog(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.darkGreen,
              padding: const EdgeInsets.all(13),
            ),
            child: const Text(
              'Add Order',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  void _showAddOrderDialog(BuildContext context) async {
    final TextEditingController deliveryPriceController =
        TextEditingController();
    final TextEditingController deliveryAddressController =
        TextEditingController();

    DateTime? orderDate;
    DateTime? deliveryDate;

    List<Product> products = await ProductRepository().getProductsRepo();
    List<Customer> customers = await CustomerRepository().getCustomersRepo();
    List<Map<String, dynamic>> selectedProducts = [];
    Customer? selectedCustomer;

    double calculateTotalOrderPrice() {
      double total = 0.0;
      for (var productData in selectedProducts) {
        Product? product = productData['product'];
        int quantity = productData['quantity'];
        if (product != null) {
          total += product.unitPrice * quantity;
        }
      }
      return total;
    }

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return BlocListener<OrderCubit, OrderState>(
          listener: (context, state) {
            if (state is OrderLoaded) {
              Navigator.of(dialogContext).pop();
            } else if (state is OrderError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          child: StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Text('Add Order'),
                content: SingleChildScrollView(
                  child: AddOrderForm(
                    deliveryPriceController: deliveryPriceController,
                    deliveryAddressController: deliveryAddressController,
                    products: products,
                    customers: customers,
                    selectedProducts: selectedProducts,
                    selectedCustomer: selectedCustomer,
                    onCustomerChanged: (Customer? customer) {
                      setState(() => selectedCustomer = customer);
                    },
                    onAddProduct: () {
                      setState(() {
                        selectedProducts.add({'product': null, 'quantity': 1});
                      });
                    },
                    onRemoveProduct: (int index) {
                      setState(() {
                        selectedProducts.removeAt(index);
                      });
                    },
                    onProductChanged: (int index, Product? product) {
                      setState(() {
                        selectedProducts[index]['product'] = product;
                      });
                    },
                    onQuantityChanged: (int index, int quantity) {
                      setState(() {
                        selectedProducts[index]['quantity'] = quantity;
                      });
                    },
                    onOrderDateSelected: (date) {
                      setState(() => orderDate = date);
                    },
                    onDeliveryDateSelected: (date) {
                      setState(() => deliveryDate = date);
                    },
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: AppColors.darkGreen),
                    ),
                  ),
                  BlocBuilder<OrderCubit, OrderState>(
                    builder: (context, state) {
                      return TextButton(
                        onPressed: () async {
                          // Date validation
                          if (orderDate == null ||
                              deliveryDate == null ||
                              deliveryDate!.isBefore(orderDate!)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Invalid date selection!'),
                              ),
                            );
                            return;
                          }

                          // Customer validation
                          if (selectedCustomer == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please select a customer'),
                              ),
                            );
                            return;
                          }

                          // Product validation
                          if (selectedProducts.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Please add at least one product'),
                              ),
                            );
                            return;
                          }

                          // Create Order object
                          final Order order = Order(
                            totalPrice: calculateTotalOrderPrice(),
                            orderDate:
                                DateFormat('yyyy-MM-dd').format(orderDate!),
                            deliveryDate:
                                DateFormat('yyyy-MM-dd').format(deliveryDate!),
                            deliveryPrice:
                                double.tryParse(deliveryPriceController.text) ??
                                    0.0,
                            deliveryAddress: deliveryAddressController.text,
                            customer: selectedCustomer!,
                            status: 'pending',
                            deleted: 0,
                          );

                          // Add order to the database via the cubit
                          await BlocProvider.of<OrderCubit>(context)
                              .addOrder(order.toMap(), selectedProducts);

                          // Increment customer order count
                          BlocProvider.of<CustomerCubit>(context)
                              .incrementCustomerOrderCounts(
                                  selectedCustomer?.id);
                          print("after doing the increment: ");

                          // Decrease product quantity based on selected products
                          for (var productData in selectedProducts) {
                            final product = productData['product'] as Product?;
                            final quantity = productData['quantity'] as int;

                            if (product != null) {
                              BlocProvider.of<ProductCubit>(context)
                                  .decrementProductQuantity(
                                      product.id, quantity);
                            }
                          }

                          // Insert income directly after adding the order
                          final income = Income(
                            date: DateFormat('yyyy-MM-dd')
                                .parse(order.deliveryDate),
                            amount: order.totalPrice,
                            order: order,
                            deleted: 0,
                          );

                          // Insert income using the repository's insert method
                          final incomeRepository =
                              IncomeRepository(); // Make sure this is initialized properly
                          await incomeRepository.insertIncome(income);
                        },
                        child: state is OrderLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Add Order',
                                style: TextStyle(color: AppColors.darkGreen),
                              ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        );
      },
    );

    // After dialog is closed, refresh the orders
    if (context.mounted) {
      context.read<OrderCubit>().loadOrders();
    }
  }
}

class AddOrderForm extends StatelessWidget {
  final TextEditingController deliveryPriceController;
  final TextEditingController deliveryAddressController;
  final List<Product> products;
  final List<Customer> customers;
  final List<Map<String, dynamic>> selectedProducts;
  final Customer? selectedCustomer;
  final void Function(Customer?) onCustomerChanged;
  final void Function() onAddProduct;
  final void Function(int) onRemoveProduct;
  final void Function(int, Product?) onProductChanged;
  final void Function(int, int) onQuantityChanged;
  final void Function(DateTime) onOrderDateSelected;
  final void Function(DateTime) onDeliveryDateSelected;

  const AddOrderForm({
    super.key,
    required this.deliveryPriceController,
    required this.deliveryAddressController,
    required this.products,
    required this.customers,
    required this.selectedProducts,
    required this.selectedCustomer,
    required this.onCustomerChanged,
    required this.onAddProduct,
    required this.onRemoveProduct,
    required this.onProductChanged,
    required this.onQuantityChanged,
    required this.onOrderDateSelected,
    required this.onDeliveryDateSelected,
  });

  Future<void> _selectDate(
      BuildContext context, void Function(DateTime) onDateSelected) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      onDateSelected(picked);
    }
  }

  String calculateProductOrderPrice(Product? product, int quantity) {
    if (product == null || quantity <= 0) return '0.00';
    return (product.unitPrice * quantity).toStringAsFixed(2);
  }

  double calculateTotalOrderPrice() {
    double total = 0.0;

    for (var productData in selectedProducts) {
      final product = productData['product'] as Product?;
      final quantity = productData['quantity'] ?? 0;

      if (product != null && quantity > 0) {
        total += product.unitPrice * quantity;
      }
    }

    final deliveryPrice = double.tryParse(deliveryPriceController.text) ?? 0.0;
    total += deliveryPrice;

    return total;
  }

  @override
  Widget build(BuildContext context) {
    final totalOrderPrice = calculateTotalOrderPrice().toStringAsFixed(2);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Customer Dropdown
        DropdownButtonFormField<Customer>(
          value: selectedCustomer,
          hint: const Text('Select Customer'),
          onChanged: onCustomerChanged,
          items: customers.map((customer) {
            return DropdownMenuItem(
              value: customer,
              child: Text(customer.name),
            );
          }).toList(),
        ),
        const SizedBox(height: 10),

        // Order Date Picker
        ElevatedButton(
          onPressed: () => _selectDate(context, onOrderDateSelected),
          style: const ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(AppColors.yellowGreen),
          ),
          child: const Text(
            'Select Order Date',
            style: TextStyle(color: AppColors.darkGreen),
          ),
        ),
        const SizedBox(height: 10),

        // Delivery Date Picker
        ElevatedButton(
          onPressed: () => _selectDate(context, onDeliveryDateSelected),
          style: const ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(AppColors.yellowGreen),
          ),
          child: const Text(
            'Select Delivery Date',
            style: TextStyle(color: AppColors.darkGreen),
          ),
        ),
        const SizedBox(height: 10),

        // Delivery Price Field
        TextField(
          controller: deliveryPriceController,
          decoration: const InputDecoration(labelText: 'Delivery Price'),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            // Trigger a rebuild to update total price when delivery price changes
            (context as Element).markNeedsBuild();
          },
        ),
        const SizedBox(height: 10),

        // Delivery Address Field
        TextField(
          controller: deliveryAddressController,
          decoration: const InputDecoration(labelText: 'Delivery Address'),
        ),
        const SizedBox(height: 20),

        // Product Selection
        const Text('Products:', style: TextStyle(fontWeight: FontWeight.bold)),
        ...selectedProducts.asMap().entries.map((entry) {
          final index = entry.key;
          final productData = entry.value;
          final product = productData['product'] as Product?;
          final quantity = productData['quantity'] ?? 0;
          final orderPrice = calculateProductOrderPrice(product, quantity);

          return Column(
            children: [
              Column(
                children: [
                  // Product Dropdown
                  DropdownButton<Product>(
                    value: product,
                    hint: const Text('Select Product'),
                    onChanged: (product) => onProductChanged(index, product),
                    items: products.map((product) {
                      return DropdownMenuItem(
                        value: product,
                        child: Text(product.name),
                      );
                    }).toList(),
                  ),

                  // Quantity Input
                  TextField(
                    decoration: const InputDecoration(labelText: 'Quantity'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      final quantity = int.tryParse(value) ?? 0;
                      if (product != null && quantity > product.quantity) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Only ${product.quantity} available in inventory'),
                          ),
                        );
                      } else {
                        onQuantityChanged(index, quantity);
                      }
                      (context as Element).markNeedsBuild();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 5),

              // Order Price Display
              Column(
                children: [
                  const Text(
                    'Order Price:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '$orderPrice DZD',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Remove Product Button
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: const Icon(Icons.remove_circle, color: Colors.red),
                  onPressed: () => onRemoveProduct(index),
                ),
              ),
            ],
          );
        }),
        const SizedBox(height: 10),

        // Add Product Button
        ElevatedButton.icon(
          onPressed: onAddProduct,
          style: const ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(AppColors.yellowGreen),
          ),
          icon: const Icon(Icons.add, color: AppColors.darkGreen),
          label: const Text('Add Product',
              style: TextStyle(color: AppColors.darkGreen)),
        ),

        const SizedBox(height: 20),

        // Total Order Price Display
        Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Total Order Price:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(width: 10),
              Text(
                "$totalOrderPrice DZD",
                style:
                    const TextStyle(fontSize: 18, color: AppColors.darkGreen),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
