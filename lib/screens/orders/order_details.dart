//this what will be shown after clicking on the order line
import 'package:business_assistant/style/containers.dart';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:business_assistant/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:business_assistant/style/colors.dart';
import 'package:business_assistant/data/orders.dart';
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
  Order order;
  detailsBox({super.key, required this.order});

  @override
  State<detailsBox> createState() => _detailsBoxState();
}

class _detailsBoxState extends State<detailsBox> {
  late String orderCode;
  Future<Uint8List> _generateOrderPdf(Order order) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Order Details',
                  style: pw.TextStyle(
                      fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Text('Order Code: ${order.orderCode}',
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
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Table.fromTextArray(
                headers: ['Item', 'Unit Price', 'Quantity', 'Total'],
                data: order.products.entries
                    .map((e) => [
                          e.key.name,
                          e.key.unitPrice.toString(),
                          e.value.toString(),
                          (e.key.unitPrice * e.value).toString()
                        ])
                    .toList(),
              ),
              pw.SizedBox(height: 20),
              pw.Text('Total Price: ${order.totalPrice}',
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Text(
                  'Total Price with Delivery: ${order.getTotalWithDelivery()}',
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold)),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(Icons.close)),
                    ),
                  ],
                ),
                //the title will only include the order + index
                Row(
                  //title and the code as a column and the edit in the corner
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(width: 3),
                          Center(
                            child: Text(
                              "   Order",
                              style: title_style,
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(widget.order.orderCode,
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.grey)),
                        ],
                      ),
                    ),
                    //no need to edit this
                    // const Padding(
                    //   padding: EdgeInsets.all(10.0),
                    //   child: Icon(Icons.edit),
                    // ),
                  ],
                ),
                const Divider(
                  color: Colors.grey,
                  thickness: 1,
                  indent: 20,
                  endIndent: 20,
                ),
                //title for each section
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

                //details for the items bought in the order
                Center(
                  child: Container(
                    //the child of this container is the set of lines that are related to each item bought in the order
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    width: 380,

                    decoration: BoxDecoration(
                      borderRadius: roundedRadius,
                      color: AppColors.lightGreen,
                    ),
                    //the child of this container is the set of lines that are related to each item bought in the order

                    child: Column(
                      children: [
                        //loop through the products of that order
                        for (var product in widget.order.products.keys)
                          itemLine(
                            itemName: product.name,
                            unitPrice: product.unitPrice,
                            quantity: widget.order.products[product]!,
                            total: product.unitPrice *
                                widget.order.products[product]!,
                          ),
                      ],
                    ),
                  ),
                ),

                //the total price of the order
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: roundedRadius,
                        color: AppColors.yellowGreen,
                      ),
                      child: TotalLine(total: widget.order.totalPrice)),
                ),
                GestureDetector(
                    //once we click on that line of the customer we will be redirected to the page of that customer
                    onTap: () {
                      Navigator.pushNamed(context, '/customerDetails',
                          arguments: widget.order.customer);
                    },
                    child: CustomerLine(customer: widget.order.customer.name)),
                //details of the dates and delivery
                OrderDate(
                    orderDate: widget.order.orderDate,
                    deliveryDate: widget.order.deliveryDate,
                    deliveryAddress: widget.order.deliveryAddress,
                    deliveryPrice: widget.order.deliveryPrice.toString()),
                // total price with the delivery
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: roundedRadius,
                        color: AppColors.yellowGreen,
                      ),
                      child: TotalLine(
                          total: widget.order.getTotalWithDelivery())),
                  //use the previously defined function
                ),

                const SizedBox(
                  height: 100,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                      style: button,
                      onPressed: () {
                        _printOrderPdf(widget.order);
                        //we must add the logic that will export the correct PDF
                        print("Exporting PDF... ");
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.picture_as_pdf,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Export PDF",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
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
