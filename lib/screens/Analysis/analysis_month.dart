import 'package:flutter/material.dart';
import '../../style/colors.dart';
import 'analysis_week.dart';
import 'transactions.dart';
import 'package:business_assistant/data/transactiondata.dart';
import 'package:intl/intl.dart';
import 'package:business_assistant/widget/bar_chart.dart';
import 'package:business_assistant/widget/sidebar.dart';

class AnalysisMonth extends StatefulWidget {
  const AnalysisMonth({super.key});

  @override
  State<AnalysisMonth> createState() => _AnalysisMonthState();
}

class _AnalysisMonthState extends State<AnalysisMonth> {
  List<TransactionData> transactions = [];

  int selectedIndex = -1;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final int? index = ModalRoute.of(context)!.settings.arguments as int?;
    if (index != null && selectedIndex != index) {
      setState(() {
        selectedIndex = index; // Ensure selectedIndex is updated from arguments
      });
    }
  }

  void handleButtonPress(int index, String routeName) {
    setState(() {
      selectedIndex =
          index; 
    });
    Navigator.pushNamed(context, routeName,
        arguments: index); 
  }

  @override
  void initState() {
    super.initState();
    _initializeTransaction();
  }

  void _initializeTransaction() {
    transactions = List.from(Transactionlist);
  }

  

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      drawer: const Sidebar(),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Analytics',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Center(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SelectedButton(
                      label: 'Week',
                      index: 1,
                      selectedIndex: selectedIndex,
                      onPressed: () {
                        handleButtonPress(1, '/analysis');
                      },
                    ),
                    SelectedButton(
                      label: 'Month',
                      index: 2,
                      selectedIndex: selectedIndex,
                      onPressed: () {
                        handleButtonPress(2, '/analysisweek');
                      },
                    ),
                    SelectedButton(
                      label: 'Year',
                      index: 3,
                      selectedIndex: selectedIndex,
                      onPressed: () {
                        handleButtonPress(3, '/analysisweek');
                      },
                    ),
                  ],
                ),
                const Padding(padding: EdgeInsets.all(10)),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Your expenses',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                const Padding(padding: EdgeInsets.all(10)),
                Container(
                  width: screenWidth * 0.9,
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(0),
                    color: Colors.white,
                  ),
                  child: const CustomBarChart(isExpense: true ,viewType: "monthly",),
                ),
                const Padding(padding: EdgeInsets.all(10)),
                Column(
                  children: [
                    const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Your Income',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                const Padding(padding: EdgeInsets.all(10)),
                Container(
                  width: screenWidth * 0.9,
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(0),
                    color: Colors.white,
                  ),
                  child: const CustomBarChart(isExpense: false ,viewType: "monthly",),
                ),
                    
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
