import 'package:flutter/material.dart';
import '../../style/colors.dart';
import 'analysis_week.dart';
import 'transactions.dart';
import 'package:business_assistant/data/transactiondata.dart';
import 'package:intl/intl.dart';
import 'package:business_assistant/widget/bar_chart.dart';
import 'package:business_assistant/widget/sidebar.dart';
class Analysis extends StatefulWidget {
  
   const Analysis({super.key});

  @override
  State<Analysis> createState() => _AnalysisState();
}

class _AnalysisState extends State<Analysis> {
   List<TransactionData> transactions=[];
   

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
            selectedIndex = index; // Update selectedIndex locally when a button is pressed
          });
          Navigator.pushNamed(context, routeName, arguments: index); // Pass selectedIndex when navigating
        }


   @override
  void initState() {
    super.initState();
    _initializeTransaction();
    
    }
void _initializeTransaction() {
  transactions = List.from(Transactionlist);
}
  //get the row object to be displayed in the recent transactions list
  List<Widget> buildTransactionRows() {
  return Transactionlist.map((transaction) {
      return CustomRow(
        title: transaction.source,
        subtitle: DateFormat('dd MMM yyyy at hh:mm a').format(transaction.date),
        value: '${transaction.type == 'income' ? '+' : '-'} ${transaction.amount} DZD',
        icon: Icon(
          transaction.type == 'income' ? Icons.south_west : Icons.north_east,
          size: 30,
          color: transaction.type == 'income' ? AppColors.green : Colors.red,
        ),
      );
    }).toList();
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
                  child: const CustomBarChart(isExpense: true), 
                ),
                const Padding(padding: EdgeInsets.all(10)),
                Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'May 2024',
                        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(10)),
                    Column(
                      children: buildTransactionRows(),
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