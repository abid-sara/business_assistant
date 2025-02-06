import 'package:business_assistant/cubits/Expense/expense_repository.dart';
import 'package:business_assistant/cubits/Income/income_repository.dart';
import 'package:flutter/material.dart';
import '../../style/colors.dart';
import 'package:intl/intl.dart';
import 'package:business_assistant/widget/sidebar.dart';

class Transaction extends StatefulWidget {
  const Transaction({super.key});

  @override
  State<Transaction> createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
  final ExpenseRepository expenseRepository = ExpenseRepository();
  final IncomeRepository incomeRepository = IncomeRepository();

  List<Map<String, dynamic>> transactions = [];
  double totalBalance = 0.0;
  bool isBalanceVisible = true;
  DateTimeRange? selectedDateRange;

  @override
  void initState() {
    super.initState();
    fetchLatestTransactions();
    calculateBalance();
  }

  Future<void> fetchLatestTransactions() async {
    final latestExpensesFuture = expenseRepository.getLatestExpenses(3);
    final latestIncomesFuture = incomeRepository.getLatestIncome(3);

    final results = await Future.wait([latestExpensesFuture, latestIncomesFuture]);

    final latestExpenses = results[0] as List<Map<String, dynamic>>;
    final latestIncomes = results[1] as List<Map<String, dynamic>>;

    setState(() {
      transactions = [
        ...latestExpenses,
        ...latestIncomes,
      ];
      transactions.sort((a, b) => DateTime.parse(b['date']).compareTo(DateTime.parse(a['date']))); // Sort by date
      print('Transactions: $transactions'); // Debugging line
    });
  }

  Future<void> calculateBalance() async {
    double totalExpenses;
    double totalIncome;

    if (selectedDateRange != null) {
      totalExpenses = await expenseRepository.calculateTotalExpensesInRange(
        selectedDateRange!.start,
        selectedDateRange!.end,
      );
      totalIncome = await incomeRepository.calculateTotalIncomeInRange(
        selectedDateRange!.start,
        selectedDateRange!.end,
      );
    } else {
      totalExpenses = await expenseRepository.calculateTotalExpenses();
      totalIncome = await incomeRepository.calculateTotalIncome();
    }

    setState(() {
      totalBalance = totalIncome - totalExpenses;
    });
  }

  Future<void> selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDateRange) {
      setState(() {
        selectedDateRange = picked;
      });
      calculateBalance();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Sidebar(),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Transactions',
          style: TextStyle(fontSize: 16),
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
              BalanceWidget(
                balance: totalBalance,
                isBalanceVisible: isBalanceVisible,
                onToggleVisibility: () {
                  setState(() {
                    isBalanceVisible = !isBalanceVisible;
                  });
                },
                onSelectDateRange: () => selectDateRange(context),
                selectedDateRange: selectedDateRange,
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
                children: transactions.isEmpty
                    ? [const Center(child: Text("No transactions available."))]
                    : transactions.map((transaction) {
                        final isIncome = transaction['type'] == 'income';
                        return CustomRow(
                          title: isIncome ? "Income" : "Expense",
                          subtitle: DateFormat('yyyy-MM-dd').format(DateTime.parse(transaction['date'])),
                          value: '${isIncome ? '+' : '-'} ${transaction['amount']} DZD',
                          icon: Icon(
                            isIncome ? Icons.south_west : Icons.north_east,
                            size: 30,
                            color: isIncome ? AppColors.green : Colors.red,
                          ),
                        );
                      }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BalanceWidget extends StatelessWidget {
  final double balance;
  final bool isBalanceVisible;
  final VoidCallback onToggleVisibility;
  final VoidCallback onSelectDateRange;
  final DateTimeRange? selectedDateRange;

  const BalanceWidget({
    super.key,
    required this.balance,
    required this.isBalanceVisible,
    required this.onToggleVisibility,
    required this.onSelectDateRange,
    this.selectedDateRange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            isBalanceVisible ? '$balance DZD' : '******',
            style: const TextStyle(
              color: AppColors.green,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(
                  isBalanceVisible ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: onToggleVisibility,
              ),
              IconButton(
                icon: const Icon(Icons.calendar_today, color: Colors.grey),
                onPressed: onSelectDateRange,
              ),
            ],
          ),
          if (selectedDateRange != null)
            Text(
              '${DateFormat('yyyy-MM-dd').format(selectedDateRange!.start)} - ${DateFormat('yyyy-MM-dd').format(selectedDateRange!.end)}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
        ],
      ),
    );
  }
}

class CustomRow extends StatelessWidget {
  final String title; // "Income" or "Expense"
  final String subtitle; // Fetched from Income/Expense model
  final String value; // Transaction amount
  final Icon icon; // Arrow icon for transaction type

  const CustomRow({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              icon,
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: value.startsWith('+') ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}