
import 'package:flutter/material.dart';
import '../../style/colors.dart';
import 'package:business_assistant/data/transactiondata.dart';
import 'package:intl/intl.dart';
import 'package:business_assistant/widget/sidebar.dart';


class CustomRow extends StatelessWidget {
  final Icon? icon; 
  final String title; 
  final String subtitle; 
  final String value; 

  const CustomRow({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    this.icon,
    
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      
      children: [
        Row(
          children: [
            if ( icon != null) ...[
              icon!,
              const SizedBox(width: 10),
            ],
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 18),
        ),
      ],
    );
  }
}
class Transaction extends StatefulWidget {
  const Transaction({super.key});

  @override
  State<Transaction> createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
  bool isBalanceVisible = false;
  double totalBalance = 0.0;
  List<TransactionData> transactions=[];

  @override
  void initState() {
    super.initState();
    _initializeTransaction();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        totalBalance = _getTotalBalance();
        
      });
    });
  }
  void _initializeTransaction(){
    transactions = List.from(Transactionlist);
  }
  //the trasation list needs to be updated according to the data in transactionData

  List<Widget> buildTransactionRows() {
    return transactions.map((transaction) {
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

  double _getTotalIncome() {
    double totalIncome = 0.0;
    for (var transaction in  transactions) {
      if (transaction.type == 'income') {
        totalIncome += transaction.amount;
      }
    }
    return totalIncome;
  }

  double _getTotalExpense() {
    double totalExpense = 0.0;
    for (var transaction in  transactions) {
      if (transaction.type == 'expense') {
        totalExpense += transaction.amount;
      }
    }
    return totalExpense;
  }

  double _getTotalBalance() {
    return _getTotalIncome() - _getTotalExpense();
  }

  @override
  Widget build(BuildContext context) {
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
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20),
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 3,
                      blurRadius: 3,
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Your total balance',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      isBalanceVisible ? '$totalBalance DZD' : 'Total Balance',
                      style: const TextStyle(
                        color: AppColors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          isBalanceVisible ? 'Hide' : 'Show',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: Icon(
                            isBalanceVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                            size: 20,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              isBalanceVisible = !isBalanceVisible;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Recent transactions',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              Column(
                children: buildTransactionRows(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}




              