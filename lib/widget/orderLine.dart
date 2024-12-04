import 'package:flutter/material.dart';
import '../style/text.dart';
import '../style/colors.dart';
import 'package:business_assistant/data/customers.dart';
import 'package:business_assistant/data/orders.dart';

// ignore: must_be_immutable
class Orderline extends StatefulWidget {
  Order order;
  final Function(Order) markOrderAsDelivered;
  final Function(Order, Customer) deleteOrder;
  Orderline(
      {super.key,
      required this.order,
      required this.markOrderAsDelivered,
      required this.deleteOrder});

  @override
  State<Orderline> createState() => _OrderlineState();
}

class _OrderlineState extends State<Orderline> {
  late bool isChecked;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/details',
          arguments: widget.order, // Pass the order object as an argument
        );
      },
      child: Container(
        margin: const EdgeInsets.all(3),
        width: double.infinity,
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: AppColors.lightGreen,
        ),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(
            // mainAxisAlignment: MainAxisAlignment,
            children: [
              IconButton(
                  onPressed: () {
                    widget.deleteOrder(widget.order, widget.order.customer);
                  },
                  icon: const Icon(
                    Icons.delete,
                    size: 20,
                  )),
              //the first main title
              Column(
                // crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(widget.order.orderCode, style: title_style),
                  Text(widget.order.customer.name,
                      style: const TextStyle(
                          color: Color.fromARGB(255, 70, 66, 66))),
                ],
              ),
            ],
          ),
          Text(widget.order.deliveryDate),
          Row(
            children: [
              //delivery date

              //here we need to handle the click logic
              IconButton(
                onPressed: () {
                  setState(() {
                    //toggles the state of delivred
                    widget.markOrderAsDelivered(widget.order);
                    //update the delivery status
                    print(
                        "The delivery status of the order now is ${widget.order.delivered}");
                  });
                },
                icon: Icon(
                  widget.order.delivered
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color: widget.order.delivered ? Colors.green : Colors.grey,
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
