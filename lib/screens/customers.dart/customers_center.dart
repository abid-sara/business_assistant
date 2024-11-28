import 'package:business_assistant/style/colors.dart';
import 'package:business_assistant/style/containers.dart';
import 'package:flutter/material.dart';

class customersPage extends StatefulWidget {
  const customersPage({super.key});
  static const String pageRoute = '/customersCenter';

  @override
  State<customersPage> createState() => _customersPageState();
}

class _customersPageState extends State<customersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back_ios_new_rounded)),
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
                image: AssetImage("assets/images/background.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: SearchBar(),
                  ),
                  //sort by dropdown menu
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: SortByDropdown(),
                  ),
                ],
              ),
              //need to add the search bar and the sort by dropdown menu
              //title for the rows
              const Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Customer            ",
                        style: TextStyle(color: Colors.grey)),
                    Text("Orders", style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    CustomerLine(customerName: "Customer1", ordersCount: 5),
                    CustomerLine(customerName: "Customer2", ordersCount: 3),
                    CustomerLine(customerName: "Customer3", ordersCount: 7),
                    // Add more Orderline widgets as needed
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class CustomerLine extends StatelessWidget {
  String customerName;
  int ordersCount;
  CustomerLine(
      {super.key, required this.customerName, required this.ordersCount});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //takes us to the details, passing the needed arguments too through pages
      onTap: () {
        // Navigator.pushNamed(
        //   context,
        //   '/customerDetails',
        //   arguments: CustomerDetailsArguments(123, 'customerName_passed'),
        // );
      },
      child: Container(
        margin: const EdgeInsets.all(3),
        height: 50,
        decoration: BoxDecoration(
          color: AppColors.green,
          borderRadius: roundedRadius,
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(customerName, style: const TextStyle(color: Colors.white)),
              Text(ordersCount.toString(),
                  style: const TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}

//defining the dropDown menu
class SortByDropdown extends StatefulWidget {
  const SortByDropdown({super.key});

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
        // border: Border.all(color: Colors.grey, width: 0),
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
