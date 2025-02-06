import 'package:business_assistant/cubits/Expense/expense_cubit.dart';
import 'package:business_assistant/cubits/Expense/expense_state.dart';
import 'package:business_assistant/cubits/Income/income_cubit.dart';
import 'package:business_assistant/cubits/Income/income_state.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

//import 'package:business_assistant/database/db_helper.dart';

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

  _CustomBarChartState createState() => _CustomBarChartState();
}

class _CustomBarChartState extends State<CustomBarChart> {
  @override
  void initState() {
    super.initState();

    //fetchEntries();
  }
/*
  Future<void> fetchEntries() async {
    try {
      final database = await DBHelper.getDatabase();
      String tableName = widget.isExpense ? 'Expense' : 'Income';
      List<Map<String, dynamic>> data = await database.query(tableName);

      setState(() {
        entries = data.map((item) {
          return {
            'amount': item['amount'] as double,
            'date': item['date'] as String,
          };
        }).toList();
      });
    } catch (e) {
      print('Error fetching entries: $e');
=======
    if (widget.isExpense) {
      context.read<ExpenseCubit>().loadExpensesGroupedByDate();
    } else {
      context.read<IncomeCubit>().loadIncomeGroupedByDate();
>>>>>>> bbcb0d9a5f723a488d00b1745e395e4b7b97491e
    }
  }*/

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
                        return getBottomTitles(value.toInt(), meta as String);
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
        periodKey = date.weekday; // Monday = 1, ..., Sunday = 7
      } 
      // Handle monthly aggregation
      else if (widget.viewType == 'monthly') {
        periodKey = ((date.day - 1) ~/ 7) + 1; // Week 1, Week 2, etc.
      } 
      // Handle yearly aggregation
      else if (widget.viewType == 'yearly') {
        periodKey = date.month; // January = 1, ..., December = 12
      } 
      else {
        throw Exception('Invalid view type');
      }

      amountsByPeriod[periodKey] = (amountsByPeriod[periodKey] ?? 0) + amount;
    }

    return amountsByPeriod;
  }

  List<BarChartGroupData> prepareBarChartData(Map<int, double> amountsByPeriod) {
    List<int> periods;
    if (widget.viewType == 'weekly') {
      periods = List.generate(7, (index) => index + 1); // Monday to Sunday
    } else if (widget.viewType == 'monthly') {
      periods = List.generate(4, (index) => index + 1); // Week 1 to Week 4
    } else if (widget.viewType == 'yearly') {
      periods = List.generate(12, (index) => index + 1); // January to December
    } else {
      throw Exception('Invalid view type');
    }

    return periods.map((period) {
      double amount = amountsByPeriod[period] ?? 0;
      return BarChartGroupData(
        x: period,
        barRods: [
          BarChartRodData(
            toY: amount,
            color: widget.isExpense ? Colors.red : Colors.green,
          ),
        ],
      );
    }).toList();
  }


  Widget getBottomTitles(int value, String viewType) {
    if (viewType == 'weekly') {
      List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return Text(days[value % 7], style: const TextStyle(fontSize: 10));
    } else if (viewType == 'monthly') {
      return Text('Week $value', style: const TextStyle(fontSize: 10));
    } else if (viewType == 'yearly') {
      return Text(DateFormat.MMM().format(DateTime(0, value)), style: const TextStyle(fontSize: 10));
    } else {
      return const Text('', style: TextStyle(fontSize: 10));
}}}