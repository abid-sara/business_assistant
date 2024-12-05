import 'package:business_assistant/style/colors.dart';
import 'package:business_assistant/widget/sidebar.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
  static const String pageRoute = '/dashboard';
}

class _DashboardState extends State<Dashboard> {
  //maybe we should add the dialog for adding customers and orders??
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        drawer: const Sidebar(),
        appBar: AppBar(
          leading: Builder(
            builder: (context) {
              return Padding(
                padding: const EdgeInsets.all(8.0), // Adjust padding here
                child: IconButton(
                  icon: const Icon(Icons.menu,
                      size: 30), // Change the icon if needed
                  onPressed: () {
                    Scaffold.of(context).openDrawer(); // Open the sidebar
                  },
                ),
              );
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  "assets/images/Dashboard.png",
                  fit: BoxFit.fill,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 25),
                    const Text(
                      'Welcome Sara!',
                      style: TextStyle(
                        fontSize: 30,
                        color: AppColors.darkGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: screenWidth,
                      child: Card(
                        color: AppColors.lightGreen,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.circle_outlined, size: 20),
                                  SizedBox(width: 5),
                                  Text(
                                    "Buy material",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 9),
                              const Row(
                                children: [
                                  Icon(Icons.circle_outlined, size: 20),
                                  SizedBox(width: 5),
                                  Text(
                                    "Prepare cookies",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 9),
                              const Row(
                                children: [
                                  Icon(Icons.circle_outlined, size: 20),
                                  SizedBox(width: 5),
                                  Text(
                                    "Update status of client",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                "Today's Tasks",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 20),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "# tasks",
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 118, 117, 117),
                                        fontSize: 18),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                          255, 228, 239, 223),
                                      elevation: 0,
                                    ),
                                    child: const Text(
                                      "View Details",
                                      style: TextStyle(
                                          color: AppColors.darkGreen,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),

                    //DUE Dates
                    const SizedBox(height: 9),
                    SizedBox(
                      width: screenWidth,
                      child: Card(
                        color: const Color.fromARGB(212, 255, 252, 212),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Next Delivery Due",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              const Text(
                                "# tasks",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 118, 117, 117),
                                    fontSize: 18),
                              ),
                              const SizedBox(height: 9),
                              ElevatedButton(
                                onPressed: () {
                                  //MUST take us to the orders page
                                  Navigator.pushNamed(context, '/orders');
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 228, 239, 223),
                                  elevation: 0,
                                ),
                                child: const Text(
                                  "View Details",
                                  style: TextStyle(
                                      color: AppColors.darkGreen,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    //LOW STOCK ITEMS
                    const SizedBox(height: 16),
                    SizedBox(
                      width: screenWidth,
                      child: Card(
                        color: AppColors.lightGreen,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.circle, size: 10),
                                  SizedBox(width: 5),
                                  Text(
                                    "Buy material",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 9),
                              const Row(
                                children: [
                                  Icon(Icons.circle, size: 10),
                                  SizedBox(width: 5),
                                  Text(
                                    "Buy material",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 23),
                              const Text(
                                "Low Stock Items",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 20),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "# tasks",
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 118, 117, 117),
                                        fontSize: 18),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, '/inventory');
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                          255, 228, 239, 223),
                                      elevation: 0,
                                    ),
                                    child: const Text(
                                      "View Details",
                                      style: TextStyle(
                                          color: AppColors.darkGreen,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    //Transactions
                    SizedBox(
                      width: screenWidth,
                      child: const Card(
                        color: Color.fromARGB(255, 252, 249, 208),
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Recent Transactions",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: 4),
                              Text(
                                "# transactions",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 118, 117, 117),
                                    fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Shortcuts",
                      style: TextStyle(
                          color: AppColors.darkGreen,
                          fontSize: 23,
                          fontWeight: FontWeight.w800),
                    ),

                    //add a task
                    SizedBox(
                      width: screenWidth,
                      child: const Card(
                        color: AppColors.purpule,
                        child: Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Add a task",
                                style: TextStyle(fontSize: 19),
                              ),
                              Icon(Icons.add)
                            ],
                          ),
                        ),
                      ),
                    ),

                    //add a client
                    const SizedBox(height: 12),
                    SizedBox(
                      width: screenWidth,
                      child: Card(
                        color: AppColors.purpule,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Add a client",
                                style: TextStyle(fontSize: 19),
                              ),
                              GestureDetector(
                                  child: const Icon(Icons.add), onTap: () {}),
                              //it must show the add customer dialog
                            ],
                          ),
                        ),
                      ),
                    ),

                    //add an order
                    const SizedBox(height: 12),
                    SizedBox(
                      width: screenWidth,
                      child: const Card(
                        color: AppColors.purpule,
                        child: Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Add an order",
                                style: TextStyle(fontSize: 19),
                              ),
                              Icon(Icons.add)
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
