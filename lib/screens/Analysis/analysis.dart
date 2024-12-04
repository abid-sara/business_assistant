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
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                        SelectedButton(
                          label: '24h',
                          routeName: '/transaction', 
                          
                        ),
                        
                        SelectedButton(
                          label: 'Week',
                          routeName:  '/analysis', 
                              
                        ),
                        SelectedButton(
                          label: 'Month',
                          routeName: '/analysisweek', 
                              
                        ),
                        SelectedButton(
                          label: 'Year',
                        routeName: '/analysisweek', 
                              
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
                        '10 May Fri',
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