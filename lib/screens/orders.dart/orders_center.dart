import 'package:business_assistant/style/colors.dart';
import 'package:business_assistant/style/text.dart';
import 'package:business_assistant/widget/buttons.dart';
import 'package:business_assistant/widget/orders_tabs.dart';
import 'package:flutter/material.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});
  static const String pageRoute = '/ordersCenter';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // leading: GestureDetector(
          //     onTap: () {
          //       Navigator.pop(context);
          //     },
          //     child: const Icon(Icons.arrow_back_ios_new_rounded)),

          title: const Text("Orders center"),
          backgroundColor: Colors.white,
        ),
        backgroundColor: Colors.transparent,
        body: Stack(children: [
          //background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Column(
              children: [
                //the tabs
                const FilterTabs(),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("Order            ",
                        style: TextStyle(color: Colors.grey)),
                    Text("Date     ", style: TextStyle(color: Colors.grey)),
                    Text("   Delivered", style: TextStyle(color: Colors.grey))
                  ],
                ),

                Expanded(
                  child: ListView(
                    children: [
                      Orderline(
                          title: "Order1", date: "23/04/2024", code: "UIP09"),
                      Orderline(
                          title: "Order2", date: "24/04/2024", code: "UIP09"),
                      Orderline(
                          title: "Order3", date: "25/04/2024", code: "UIP09"),
                      Orderline(
                          title: "Order4", date: "26/04/2024", code: "UIP09"),
                      Orderline(
                          title: "Order5", date: "27/04/2024", code: "UIP09"),
                      // Add more Orderline widgets as needed
                    ],
                  ),
                ),
                AddButton(
                  thing: "order",
                ),

                //considering this, as our bottom bar
                const SizedBox(
                  width: double.infinity,
                  height: 80,
                )
              ],
            ),
          ),
        ]));
  }
}

// ignore: must_be_immutable
class Orderline extends StatefulWidget {
  late String title;
  late String date;
  late bool? checked;
  late String code;
  Orderline({
    super.key,
    required this.title,
    required this.date,
    required this.code,
    this.checked,
  });

  @override
  State<Orderline> createState() => _OrderlineState();
}

class _OrderlineState extends State<Orderline> {
  late bool isChecked;
  @override
  void initState() {
    super.initState();
    isChecked = widget.checked ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/details');
        //  We have to pass the data through the screens
      },
      child: Container(
        margin: const EdgeInsets.all(3),
        width: double.infinity,
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: AppColors.lightGreen,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            //the first main title
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(widget.title, style: title_style),
                Text(widget.code,
                    style:
                        const TextStyle(color: Color.fromARGB(255, 70, 66, 66)))
              ],
            ),
            //delivery date
            Text(widget.date),
            //here we need to handle the click logic
            IconButton(
              onPressed: () {
                setState(() {
                  isChecked = !isChecked; // Toggle the state
                });
              },
              icon: Icon(
                isChecked ? Icons.check_circle : Icons.radio_button_unchecked,
                color: isChecked ? Colors.green : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
