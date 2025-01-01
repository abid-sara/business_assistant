import 'package:business_assistant/cubits/Expense/expense_cubit.dart';
import 'package:business_assistant/cubits/Expense/expense_repository.dart';
import 'package:business_assistant/cubits/Expense/expense_state.dart';
import 'package:business_assistant/models/expense.dart';
import 'package:business_assistant/models/income.dart';
import 'package:business_assistant/widget/bar_chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../style/colors.dart';

class SelectedButton extends StatelessWidget {
  final String label;
  final int index;
  final int selectedIndex;
  final VoidCallback onPressed;

  const SelectedButton({
    super.key,
    required this.label,
    required this.index,
    required this.selectedIndex,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    bool isSelected = selectedIndex == index;
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.white : AppColors.green,
        foregroundColor: isSelected ? AppColors.green : Colors.white,
        minimumSize: const Size(80, 40),
      ),
      child: Text(label),
    );
  }
}

class AnalysisWeek extends StatefulWidget {
  const AnalysisWeek({super.key});

  @override
  State<AnalysisWeek> createState() => _AnalysisWeekState();
}

class _AnalysisWeekState extends State<AnalysisWeek> {
  int selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    // No need to create the ExpenseCubit manually here.
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Modify this method to reload expenses when the user selects a different time period.
  void handleButtonPress(int index, String routeName) {
    setState(() {
      selectedIndex = index;
    });

    // Trigger the cubit to reload the expenses data
    context.read<ExpenseCubit>().loadExpenses();

    Navigator.pushReplacementNamed(context, routeName, arguments: index);
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Weekly Analysis'),
      ),
      body: BlocProvider(
        create: (context) => ExpenseCubit(repository: ExpenseRepository())..loadExpenses(),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
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
                        handleButtonPress(1, '/analysisweek');
                      },
                    ),
                    SelectedButton(
                      label: 'Month',
                      index: 2,
                      selectedIndex: selectedIndex,
                      onPressed: () {
                        handleButtonPress(2, '/analysismonth');
                      },
                    ),
                    SelectedButton(
                      label: 'Year',
                      index: 3,
                      selectedIndex: selectedIndex,
                      onPressed: () {
                        handleButtonPress(3, '/analysisyear');
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
                // Chart for Expenses
                _buildChart(screenWidth, true), // Display expenses chart
                const Padding(padding: EdgeInsets.all(10)),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Your Income',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                const Padding(padding: EdgeInsets.all(10)),
                // Chart for Incomes
                _buildChart(screenWidth, false), // Display income chart
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Function to display the chart based on expense or income
  Widget _buildChart(double screenWidth, bool isExpense) {
    return Container(
      width: screenWidth * 0.9,
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomBarChart(
          isExpense: isExpense,
          viewType: 'week', // Set the view type to 'week'
        ),
      ),
    );
  }
}

class CustomBarChart extends StatefulWidget {
  final bool isExpense;
  final String viewType;

  const CustomBarChart({
    super.key,
    required this.isExpense,
    required this.viewType,
  });

  @override
  _CustomBarChartState createState() => _CustomBarChartState();
}

class _CustomBarChartState extends State<CustomBarChart> {
  @override
  void initState() {
    super.initState();
    if (widget.isExpense) {
      context.read<ExpenseCubit>().loadExpenses();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpenseCubit, ExpenseState>(
      builder: (context, state) {
        print('Current expense state: $state');
        if (state is ExpenseLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ExpenseLoaded) {
          if (state.expenses.isEmpty) {
            return const Center(child: Text('No expenses found'));
          }
          return _buildBarChart(state.expenses);
        } else if (state is ExpenseError) {
          return Center(child: Text(state.error));
        }
        return const Center(child: Text('No data available'));
      }
    );
  }

  Widget _buildBarChart(List<Expense> expenses) {
    List<Map<String, dynamic>> entries = expenses
        .map((e) => {'amount': e.amount, 'date': e.date}).toList();

    Map<int, double> amountsByPeriod = aggregateAmountsByPeriod(entries);
    List<BarChartGroupData> barChartData = prepareBarChartData(amountsByPeriod);

    double maxY = amountsByPeriod.values.isNotEmpty
        ? amountsByPeriod.values.reduce((a, b) => a > b ? a : b)
        : 100.0;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: barChartData.isEmpty
          ? const Center(child: Text('No data available for the selected period.'))
          : BarChart(
              BarChartData(
                minY: 0,
                maxY: maxY,
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  drawHorizontalLine: true,
                  horizontalInterval: maxY / 5,
                  getDrawingHorizontalLine: (value) {
                    return const FlLine(color: Colors.grey, strokeWidth: 0.5);
                  },
                ),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      interval: maxY / 5,
                      getTitlesWidget: (value, meta) {
                        return Text(value.toInt().toString(), 
                          style: const TextStyle(fontSize: 10));
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        return getBottomTitles(value.toInt());
                      },
                    ),
                  ),
                ),
                groupsSpace: 10,
                barGroups: barChartData,
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        'Period: ${group.x}\nAmount: ${rod.toY.toStringAsFixed(2)}',
                        const TextStyle(color: Colors.white),
                      );
                    },
                  ),
                ),
              ),
            ),
    );
  }

 Map<int, double> aggregateAmountsByPeriod(List<Map<String, dynamic>> entries) {
  Map<int, double> amountsByPeriod = {};
  DateTime now = DateTime.now();

  for (var entry in entries) {
    DateTime date = entry['date'];
    double amount = entry['amount'];
    int periodKey;

    // Handle weekly aggregation
    if (widget.viewType == 'weekly') {
      // Get the start of the week (Monday)
      int startOfWeek = now.subtract(Duration(days: now.weekday - 1)).day;
      DateTime startOfWeekDate = DateTime(now.year, now.month, startOfWeek);
      int weekKey = (date.difference(startOfWeekDate).inDays ~/ 7) + 1;
      periodKey = weekKey;
    } 
    // Handle monthly aggregation
    else if (widget.viewType == 'monthly') {
      periodKey = date.month;
    } 
    // Handle yearly aggregation
    else if (widget.viewType == 'yearly') {
      periodKey = date.year;
    } 
    else {
      throw Exception('Invalid view type');
    }

    amountsByPeriod[periodKey] = (amountsByPeriod[periodKey] ?? 0) + amount;
  }

  return amountsByPeriod;
}

List<BarChartGroupData> prepareBarChartData(Map<int, double> amountsByPeriod) {
  return amountsByPeriod.entries
      .map((e) => BarChartGroupData(
            x: e.key,
            barRods: [
              BarChartRodData(
                toY: e.value,
                color: widget.isExpense ? Colors.red : Colors.green,
              ),
            ],
          ))
      .toList();
}

Widget getBottomTitles(int period) {
  if (widget.viewType == 'weekly') {
    // Display the start of the week
    DateTime firstDayOfWeek = DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
    DateTime weekStartDate = firstDayOfWeek.add(Duration(days: (period - 1) * 7));
    return Text('Week ${period}\n${DateFormat('MM/dd').format(weekStartDate)}', style: const TextStyle(fontSize: 10));
  } else if (widget.viewType == 'monthly') {
    return Text('Month $period', style: const TextStyle(fontSize: 10));
  } else if (widget.viewType == 'yearly') {
    return Text(DateFormat('MMM').format(DateTime(0, period)), style: const TextStyle(fontSize: 10));
  }
  return Container();
}

}
