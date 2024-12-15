import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:business_assistant/database/db_helper.dart';
import 'package:intl/intl.dart';

import '../style/colors.dart';



class CustomBarChart extends StatefulWidget {
  final bool isExpense;
  final String viewType; 

  const CustomBarChart({super.key, required this.isExpense, required this.viewType});

  @override
  State<CustomBarChart> createState() => _CustomBarChartState();
}

class _CustomBarChartState extends State<CustomBarChart> {
  List<Map<String, dynamic>> entries = []; 

  @override
  void initState() {
    super.initState();
    fetchEntries();
  }

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
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<int, double> amountsByPeriod = aggregateAmountsByPeriod(entries, widget.viewType);

    List<BarChartGroupData> barChartData = prepareBarChartData(amountsByPeriod);

    double maxY = amountsByPeriod.values.isNotEmpty
        ? amountsByPeriod.values.reduce((a, b) => a > b ? a : b)
        : 100.0;
    double minY = 0;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: barChartData.isEmpty
          ? Center(child: Text('No data available for the selected period.'))
          : BarChart(
              BarChartData(
                minY: minY,
                maxY: maxY,
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  drawHorizontalLine: true,
                  horizontalInterval: maxY / 5,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(color: Colors.grey, strokeWidth: 0.5);
                  },
                ),
                titlesData: FlTitlesData(
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      interval: maxY / 5,
                      getTitlesWidget: (value, meta) {
                        return Text(value.toInt().toString(), style: TextStyle(fontSize: 10));
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        return getBottomTitles(value.toInt(), widget.viewType);
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
                        TextStyle(color: Colors.white),
                      );
                    },
                  ),
                ),
              ),
            ),
    );
  }

  Map<int, double> aggregateAmountsByPeriod(List<Map<String, dynamic>> entries, String viewType) {
    Map<int, double> amountsByPeriod = {};
    DateTime now = DateTime.now();

    for (var entry in entries) {
      DateTime date = DateTime.parse(entry['date']);
      double amount = entry['amount'];
      int periodKey;

      if (viewType == 'weekly') {
        DateTime startOfWeek = now.subtract(Duration(days: now.weekday % 7));
        int daysDifference = date.difference(startOfWeek).inDays;
        periodKey = (daysDifference >= 0 && daysDifference < 7) ? daysDifference : -1;
      } else if (viewType == 'monthly') {
        DateTime startOfMonth = DateTime(now.year, now.month, 1);
        int weekOfMonth = ((date.day - 1) ~/ 7) + 1;
        periodKey = weekOfMonth;
      } else if (viewType == 'yearly') {
        periodKey = date.month;
      } else {
        throw Exception('Invalid view type');
      }

      if (periodKey >= 0) {
        amountsByPeriod[periodKey] = (amountsByPeriod[periodKey] ?? 0) + amount;
      }
    }

    return amountsByPeriod;
  }

  List<BarChartGroupData> prepareBarChartData(Map<int, double> amountsByPeriod) {
    return amountsByPeriod.entries.map((entry) {
      int period = entry.key;
      double amount = entry.value;
      return BarChartGroupData(
        x: period,
        barRods: [
          BarChartRodData(
            toY: amount,
            width: 20,
            color: AppColors.darkGreen,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    }).toList();
  }

  Widget getBottomTitles(int value, String viewType) {
    if (viewType == 'weekly') {
      List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return Text(days[value % 7], style: TextStyle(fontSize: 10));
    } else if (viewType == 'monthly') {
      return Text('Week $value', style: TextStyle(fontSize: 10));
    } else if (viewType == 'yearly') {
      return Text(DateFormat.MMM().format(DateTime(0, value)), style: TextStyle(fontSize: 10));
    } else {
      return Text('', style: TextStyle(fontSize: 10));
    }
  }
}
