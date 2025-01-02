import 'package:business_assistant/cubits/Expense/expense_cubit.dart';
import 'package:business_assistant/cubits/Expense/expense_state.dart';
import 'package:business_assistant/cubits/Income/income_cubit.dart';
import 'package:business_assistant/cubits/Income/income_state.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

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
    // Trigger the cubit to load data for expenses or income
    if (widget.isExpense) {
      context.read<ExpenseCubit>().loadExpensesGroupedByDate();
    } else {
      context.read<IncomeCubit>().loadIncomeGroupedByDate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.isExpense
        ? BlocBuilder<ExpenseCubit, ExpenseState>(
            builder: (context, state) {
              if (state is ExpenseLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ExpenseGroupedByDateLoaded) {
                return _buildBarChart(state.expenses);
              } else if (state is ExpenseError) {
                return Center(child: Text(state.message));
              }
              return _buildBarChart({});
            },
          )
        : BlocBuilder<IncomeCubit, IncomeState>(
            builder: (context, state) {
              if (state is IncomeLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is IncomeGroupedByDateLoaded) {
                return _buildBarChart(state.income);
              } else if (state is IncomeError) {
                return Center(child: Text(state.message));
              }
              return _buildBarChart({});
            },
          );
  }

  Widget _buildBarChart(Map<String, double> data) {
    List<Map<String, dynamic>> entries = data.entries
        .map((e) => {'amount': e.value, 'date': DateTime.parse(e.key)})
        .toList();

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
                        return Text(value.toInt().toString(), style: const TextStyle(fontSize: 10));
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
      int periodKey = 0;

      // Handle weekly aggregation
      if (widget.viewType == 'weekly') {
        DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        int weekKey = ((date.difference(startOfWeek).inDays) ~/ 7) + 1;
        periodKey = weekKey;
      } 
      // Handle monthly aggregation: Aggregate by week within current month
      else if (widget.viewType == 'monthly') {
        DateTime startOfMonth = DateTime(now.year, now.month, 1); // First day of current month
        int weekOfMonth = ((date.difference(startOfMonth).inDays) ~/ 7) + 1;
        if (date.month == now.month) {
          periodKey = weekOfMonth; // Aggregate by week of current month
        }
      } 
      // Handle yearly aggregation: Aggregate by week within the current year
      else if (widget.viewType == 'yearly') {
        DateTime startOfYear = DateTime(now.year, 1, 1); // First day of current year
        int weekOfYear = ((date.difference(startOfYear).inDays) ~/ 7) + 1;
        if (date.year == now.year) {
          periodKey = weekOfYear; // Aggregate by week of the current year
        }
      } 
      else {
        throw Exception('Invalid view type');
      }

      // Add the amount to the corresponding period
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
      // Show the start of the week (Monday) to end (Sunday)
      DateTime now = DateTime.now();
      DateTime firstDayOfWeek = now.subtract(Duration(days: now.weekday - 1));  // Monday of this week
      DateTime weekStartDate = firstDayOfWeek.add(Duration(days: (period - 1) * 7)); // Start of the desired week
      DateTime weekEndDate = weekStartDate.add(Duration(days: 6));  // Sunday of the desired week

      return Text(
        'Mon ${DateFormat('MM/dd').format(weekStartDate)}\nSun ${DateFormat('MM/dd').format(weekEndDate)}',
        style: const TextStyle(fontSize: 10),
      );
    } else if (widget.viewType == 'monthly') {
      // Show weeks within the current month (Week 1, Week 2, etc.)
      return Text('Week $period', style: const TextStyle(fontSize: 10));
    } else if (widget.viewType == 'yearly') {
      // Show weeks of the current year (Week 1, Week 2, etc.)
      return Text('Week $period', style: const TextStyle(fontSize: 10));
    }
    return Container();
  }
}
