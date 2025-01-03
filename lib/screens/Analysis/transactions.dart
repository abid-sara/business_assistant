import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../style/colors.dart';
import 'package:business_assistant/data/transactiondata.dart';
import 'package:intl/intl.dart';
import 'package:business_assistant/widget/sidebar.dart';
import 'package:business_assistant/cubits/Expense/expense_cubit.dart';
import 'package:business_assistant/cubits/Income/income_cubit.dart';
import 'package:business_assistant/models/expense.dart';
import 'package:business_assistant/models/income.dart';

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
            if (icon != null) ...[
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
  List<TransactionData> transactions = [];

  @override
  void initState() {
    super.initState();
    _initializeTransaction();
    _calculateBalance();
    _fetchLatestTransactions();
  }

  void _initializeTransaction() {
    transactions = List.from(Transactionlist);
  }

  Future<void> _calculateBalance() async {
    final expenseCubit = context.read<ExpenseCubit>();
    final incomeCubit = context.read<IncomeCubit>();

    final totalExpenses = await expenseCubit.repository.calculateTotalExpenses();
    final totalIncome = await incomeCubit.repository.calculateTotalIncome();

    setState(() {
      totalBalance = totalIncome - totalExpenses;
    });
  }

  Future<void> _fetchLatestTransactions() async {
    final expenseCubit = context.read<ExpenseCubit>();
    final incomeCubit = context.read<IncomeCubit>();

    final latestExpenses = await expenseCubit.repository.getLatestExpenses(5);
    final latestIncome = await incomeCubit.repository.getLatestIncome(5);

    setState(() {
      transactions = [
        ...latestExpenses.map((e) => TransactionData(
          source: 'Expense',
          date: e.date,
          amount: e.amount,
          type: 'expense',
        )),
        ...latestIncome.map((i) => TransactionData(
          source: 'Income',
          date: i.date,
          amount: i.amount,
          type: 'income',
        )),
      ];
      transactions.sort((a, b) => b.date.compareTo(a.date));
      if (transactions.length > 5) {
        transactions = transactions.sublist(0, 5);
      }
    });
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Sidebar(),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Transactions',
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