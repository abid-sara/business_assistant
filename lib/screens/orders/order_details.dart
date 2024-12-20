//this what will be shown after clicking on the order line

import 'package:business_assistant/database/db_order.dart';
import 'package:business_assistant/style/containers.dart';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:business_assistant/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:business_assistant/style/colors.dart';
import 'package:business_assistant/models/order.dart';
import 'package:business_assistant/style/text.dart';

// ignore: camel_case_types
class orderDetails extends StatelessWidget {
  const orderDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final Order order = ModalRoute.of(context)!.settings.arguments as Order;
    //we can use now this order object to get the relevant information
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back_ios_new_rounded)),
        title: const Text("Order details"),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.transparent,
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
          detailsBox(order: order),
        ],
      ),
    );
  }
}

class detailsBox extends StatefulWidget {
  final Order order; // Make it immutable by marking it final
  const detailsBox({super.key, required this.order});

  @override
  State<detailsBox> createState() => _detailsBoxState();
}

class _detailsBoxState extends State<detailsBox> {
  late List<Map<String, dynamic>> products;
  late double totalPriceOfProduct;

  Future<void> initialize(Order order) async {
    products = await getProductsForOrder(order.id);

    products = products
        .map((entry) => {
              'name': entry["name"],
              'unitPrice': entry["unitPrice"],
              'quantity': entry[
                  "quantity"], //quantity of the product ordered (from the OrderProduct table)
              'total': entry["unitPrice"] * entry["quantity"],
            })
        .toList();

    totalPriceOfProduct = await getTotalWithDelivery(widget.order.id);
  }

  @override
  void initState() {
    super.initState();
    initialize(widget.order);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
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
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Header section with title
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          const SizedBox(width: 3),
                          Center(
                            child: Text(
                              "   Order",
                              style: title_style,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(widget.order.id.toString(),
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.grey)),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(
                  color: Colors.grey,
                  thickness: 1,
                  indent: 20,
                  endIndent: 20,
                ),
                // Product list headers
                const Padding(
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
                ),
                // Dynamically display product details
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    width: 380,
                    decoration: BoxDecoration(
                      borderRadius: roundedRadius,
                      color: AppColors.lightGreen,
                    ),
                    child: Column(
                      children: [
                        for (var product in products)
                          itemLine(
                            itemName: product['name'],
                            unitPrice: product['unitPrice'],
                            quantity: product['quantity'],
                            total: product['total'],
                          ),
                      ],
                    ),
                  ),
                ),
                // Total price section
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: roundedRadius,
                      color: AppColors.yellowGreen,
                    ),
                    child: TotalLine(total: widget.order.totalPrice),
                  ),
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/customerDetails',
                          arguments: widget.order.customer);
                    },
                    child: CustomerLine(customer: widget.order.customer.name)),
                OrderDate(
                  orderDate: widget.order.orderDate,
                  deliveryDate: widget.order.deliveryDate,
                  deliveryAddress: widget.order.deliveryAddress,
                  deliveryPrice: widget.order.deliveryPrice.toString(),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: roundedRadius,
                      color: AppColors.yellowGreen,
                    ),
                    child: TotalLine(total: totalPriceOfProduct),
                  ),
                ),
                const SizedBox(height: 100),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                    style: button,
                    onPressed: () {
                      _printOrderPdf(widget.order);
                      print("Exporting PDF... ");
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.picture_as_pdf, color: Colors.white),
                        SizedBox(width: 10),
                        Text(
                          "Export PDF",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class detailsBox extends StatefulWidget {
//   Order order;
//   detailsBox({super.key, required this.order});

//   @override
//   State<detailsBox> createState() => _detailsBoxState();
// }

// class _detailsBoxState extends State<detailsBox> {
//   late String orderId;
Future<Uint8List> _generateOrderPdf(Order order) async {
  final pdf = pw.Document();
  final totalPriceOfProduct = await getTotalWithDelivery(order.id);
  final products = await getProductsForOrder(order.id);
  final productData = products.map((entry) {
    return [
      entry["name"],
      entry["unitPrice"].toString(),
      entry["quantity"].toString(),
      (entry["unitPrice"] * entry["quantity"]).toString(),
    ];
  }).toList();
  pdf.addPage(
    pw.Page(
      build: (context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Order Details',
                style:
                    pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 20),
            pw.Text('Order Code: ${order.id}',
                style: const pw.TextStyle(fontSize: 18)),
            pw.SizedBox(height: 10),
            pw.Text('Customer: ${order.customer.name}',
                style: const pw.TextStyle(fontSize: 18)),
            pw.SizedBox(height: 10),
            pw.Text('Order Date: ${order.orderDate}',
                style: const pw.TextStyle(fontSize: 18)),
            pw.SizedBox(height: 10),
            pw.Text('Delivery Date: ${order.deliveryDate}',
                style: const pw.TextStyle(fontSize: 18)),
            pw.SizedBox(height: 10),
            pw.Text('Delivery Address: ${order.deliveryAddress}',
                style: const pw.TextStyle(fontSize: 18)),
            pw.SizedBox(height: 10),
            pw.Text('Delivery Price: ${order.deliveryPrice}',
                style: const pw.TextStyle(fontSize: 18)),
            pw.SizedBox(height: 20),
            pw.Text('Items:',
                style:
                    pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Table.fromTextArray(
              headers: ['Item', 'Unit Price', 'Quantity', 'Total'],
              data: productData,
            ),
            pw.SizedBox(height: 20),
            pw.Text('Total Price: ${order.totalPrice}',
                style:
                    pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Text('Total Price with Delivery: $totalPriceOfProduct}',
                style:
                    pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.Spacer(),
            pw.Text("Generated on: ${DateTime.now()}"),
            pw.Text("Thank you for the order "),
            pw.Text(
              "Business Assistant",
              style: pw.TextStyle(
                  fontSize: 15,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.green),
            ),
            // pw.Text("Here we print the title of the business")
          ],
        );
      },
    ),
  );

  return pdf.save();
}

void _printOrderPdf(Order order) async {
  await Printing.layoutPdf(
    onLayout: (PdfPageFormat format) async => _generateOrderPdf(order),
  );
}

//item line
// ignore: must_be_immutable
class itemLine extends StatelessWidget {
  //pass all the needed information to this widget
  String itemName;
  double unitPrice;
  int quantity;
  double total;
  itemLine(
      {super.key,
      required this.itemName,
      required this.unitPrice,
      required this.quantity,
      required this.total});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(itemName),
              Text(unitPrice.toString()),
              Text(quantity.toString()),
              Text(total.toString()),
            ],
          ),
          //after each line we have a divider
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class TotalLine extends StatelessWidget {
  double total;
  TotalLine({super.key, required this.total});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Total"),
          Text(total.toString()),
        ],
      ),
    );
  }
}

class CustomerLine extends StatelessWidget {
  String customer;
  CustomerLine({super.key, required this.customer});

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
              //clicking on the customer can take us to the customer details
              const Text("Customer"),
              Text(customer),
            ],
          ),
        ),
      ),
    );
  }
}

class OrderDate extends StatelessWidget {
  String orderDate;
  String deliveryDate;
  String deliveryAddress;
  String deliveryPrice;

  OrderDate(
      {super.key,
      required this.orderDate,
      required this.deliveryDate,
      required this.deliveryAddress,
      required this.deliveryPrice});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: roundedRadius,
          color: AppColors.purpule,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Order date",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(orderDate),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Delivery date",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(deliveryDate),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Delivery address",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(deliveryAddress),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Delivery price",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(deliveryPrice),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
