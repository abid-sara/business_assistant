// order_details.dart
import 'package:business_assistant/cubits/order/orderDetails_cubit.dart';
import 'package:business_assistant/cubits/order/order_repository.dart';
import 'package:business_assistant/cubits/order/order_state.dart';
import 'package:business_assistant/style/containers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:business_assistant/models/order.dart';
import 'package:business_assistant/style/colors.dart';
import 'package:business_assistant/style/text.dart';
import 'package:business_assistant/widget/button.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

class OrderDetails extends StatelessWidget {
  const OrderDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final Order order = ModalRoute.of(context)!.settings.arguments as Order;

    return MultiBlocProvider(
      providers: [
        Provider<OrderRepository>(
          create: (context) =>
              OrderRepository(), // Initialize your repository here
        ),
        BlocProvider(
          create: (context) => OrderDetailsCubit(
            repository: context.read<OrderRepository>(),
          )..loadOrderDetails(order.id!),
        ),
      ],
      child: OrderDetailsView(order: order),
    );
  }
}

class OrderDetailsView extends StatelessWidget {
  final Order order;

  const OrderDetailsView({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: const Text("Order details"),
        backgroundColor: Colors.white,
      ),
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
          BlocBuilder<OrderDetailsCubit, OrderState>(
            builder: (context, state) {
              if (state is OrderLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is OrderError) {
                return Center(child: Text(state.message));
              }

              if (state is OrderDetailsLoaded) {
                return OrderDetailsContent(
                  order: order,
                  state: state,
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}

class OrderDetailsContent extends StatelessWidget {
  final Order order;
  final OrderDetailsLoaded state;

  const OrderDetailsContent({
    super.key,
    required this.order,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            margin: const EdgeInsets.all(10),
            width: 400,
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 3.0,
                  spreadRadius: 0.0,
                  offset: Offset(1.0, 1.0),
                )
              ],
              borderRadius: BorderRadius.all(Radius.circular(40)),
            ),
            child: Column(
              children: [
                OrderHeader(order: order),
                const ProductListHeader(),
                ProductList(products: state.products),
                OrderSummary(
                  order: order,
                  totalWithDelivery: state.totalWithDelivery,
                ),
                PdfExportButton(order: order),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OrderHeader extends StatelessWidget {
  final Order order;

  const OrderHeader({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              const SizedBox(width: 3),
              Text("Order", style: title_style),
              const SizedBox(width: 8),
              Text(
                order.id.toString(),
                style: const TextStyle(fontSize: 15, color: Colors.grey),
              ),
            ],
          ),
        ),
        const Divider(
          color: Colors.grey,
          thickness: 1,
          indent: 20,
          endIndent: 20,
        ),
      ],
    );
  }
}

class ProductListHeader extends StatelessWidget {
  const ProductListHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(13.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Item"),
          Text("Unit price"),
          Text("Quantity"),
          Text("Total"),
        ],
      ),
    );
  }
}

class ProductList extends StatelessWidget {
  final List<Map<String, dynamic>> products;

  const ProductList({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: roundedRadius,
        color: AppColors.lightGreen,
      ),
      child: Column(
        children: products.map((product) {
          return ProductListItem(
            name: product['name'],
            unitPrice: product['unitPrice'],
            quantity: product['quantity'],
            total: product['total'],
          );
        }).toList(),
      ),
    );
  }
}

class ProductListItem extends StatelessWidget {
  final String name;
  final double unitPrice;
  final int quantity;
  final double total;

  const ProductListItem({
    super.key,
    required this.name,
    required this.unitPrice,
    required this.quantity,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name),
          Text(unitPrice.toString()),
          Text(quantity.toString()),
          Text(total.toString()),
        ],
      ),
    );
  }
}

class OrderSummary extends StatelessWidget {
  final Order order;
  final double totalWithDelivery;

  const OrderSummary({
    super.key,
    required this.order,
    required this.totalWithDelivery,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OrderInfoSection(
          backgroundColor: AppColors.yellowGreen,
          child: TotalLine(total: order.totalPrice),
        ),
        GestureDetector(
          onTap: () => Navigator.pushNamed(
            context,
            '/customerDetails',
            arguments: order.customer,
          ),
          child: OrderInfoSection(
            backgroundColor: AppColors.lightGreen,
            child: CustomerLine(customer: order.customer.name),
          ),
        ),
        OrderInfoSection(
          backgroundColor: AppColors.purpule,
          child: OrderDateInfo(
            orderDate: order.orderDate,
            deliveryDate: order.deliveryDate,
            deliveryAddress: order.deliveryAddress,
            deliveryPrice: order.deliveryPrice.toString(),
          ),
        ),
        OrderInfoSection(
          backgroundColor: AppColors.yellowGreen,
          child: TotalLine(total: totalWithDelivery),
        ),
      ],
    );
  }
}

class OrderInfoSection extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;

  const OrderInfoSection({
    super.key,
    required this.child,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: roundedRadius,
          color: backgroundColor,
        ),
        child: child,
      ),
    );
  }
}

class TotalLine extends StatelessWidget {
  final double total;
  const TotalLine({super.key, required this.total});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Total"),
          Text("${total.toStringAsFixed(2)}  DZD"),
        ],
      ),
    );
  }
}

class CustomerLine extends StatelessWidget {
  final String customer;
  const CustomerLine({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: roundedRadius,
          color: AppColors.lightGreen,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Customer"),
              Text(customer),
            ],
          ),
        ),
      ),
    );
  }
}

class PdfExportButton extends StatelessWidget {
  final Order order;

  const PdfExportButton({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ElevatedButton(
        style: button,
        onPressed: () async {
          final cubit = context.read<OrderDetailsCubit>();
          final pdfData = await cubit.generateOrderPdf(order);
          await Printing.layoutPdf(
            onLayout: (format) => Future.value(pdfData),
          );
        },
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.picture_as_pdf, color: Colors.white),
            SizedBox(width: 10),
            Text(
              "Export PDF",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderDateInfo extends StatelessWidget {
  final String orderDate;
  final String deliveryDate;
  final String deliveryAddress;
  final String deliveryPrice;

  const OrderDateInfo({
    super.key,
    required this.orderDate,
    required this.deliveryDate,
    required this.deliveryAddress,
    required this.deliveryPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Order date:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                orderDate,
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Delivery date:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                deliveryDate,
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Delivery address:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: Text(
                  deliveryAddress,
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Delivery price:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text("$deliveryPrice  DZD"),
            ],
          ),
        ],
      ),
    );
  }
}
