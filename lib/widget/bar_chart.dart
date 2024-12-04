import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../style/colors.dart';
import 'package:business_assistant/data/transactiondata.dart';

class CustomBarChart extends StatefulWidget {
  final bool isExpense;

  const CustomBarChart({super.key, required this.isExpense});

  @override
  State<CustomBarChart> createState() => _CustomBarChartState();
}

class _CustomBarChartState extends State<CustomBarChart> {
  @override
  Widget build(BuildContext context) {
    // Filter the transactions to be able to draw the bar chart of expense/income
    List<TransactionData> filteredTransactions = filterTransactions(widget.isExpense);

    Map<int, double> amountsByDay = aggregateAmountsByDay(filteredTransactions);
    List<BarChartGroupData> barChartData = prepareBarChartData(amountsByDay);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
      child: BarChart(
        BarChartData(
          // Min and maximum value
          minY: 20000,
          maxY: 100000,
          borderData: FlBorderData(show: false),
          gridData: FlGridData(
            drawVerticalLine: true,
            verticalInterval: 500,
          ),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 60,
                interval: 20000,
                getTitlesWidget: (value, meta) {
                  return Text(value.toString());
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value, TitleMeta meta) {
                  switch (value.toInt()) {
                    case 1:
                      return const Text('Mon');
                    case 2:
                      return const Text('Tue');
                    case 3:
                      return const Text('Wed');
                    case 4:
                      return const Text('Thu');
                    case 5:
                      return const Text('Fri');
                    case 6:
                      return const Text('Sat');
                    case 7:
                      return const Text('Sun');
                    default:
                      return const Text('');
                  }
                },
              ),
            ),
          ),
          groupsSpace: 10, 
          barGroups: barChartData,
        ),
      ),
    );
  }

  // Filter transactions based on whether they are income or expense
  List<TransactionData> filterTransactions(bool isExpense) {
    return Transactionlist.where((transaction) => transaction.type == (isExpense ? 'expense' : 'income')).toList();
  }

  /// Assigns the values to the days in the bar chart widget.
  Map<int, double> aggregateAmountsByDay(List<TransactionData> transactions) {
    Map<int, double> amountsByDay = {1: 0.0, 2: 0.0, 3: 0.0, 4: 0.0, 5: 0.0, 6: 0.0, 7: 0.0};
    for (var transaction in transactions) {
      int dayOfWeek = transaction.date.weekday;
      amountsByDay[dayOfWeek] = (amountsByDay[dayOfWeek] ?? 0.0) + transaction.amount;
    }
    return amountsByDay;
  }

  // Assign the values to the bar chart widget
  List<BarChartGroupData> prepareBarChartData(Map<int, double> amountsByDay) {
    return amountsByDay.entries.map((entry) {
      int day = entry.key;
      double amount = entry.value;
      return BarChartGroupData(
        x: day,
        barRods: [
          BarChartRodData(
            toY: amount,
            width: 20, 
            color: AppColors.darkGreen,
          ),
        ],
      );
    }).toList();
  }
}
