import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../style/colors.dart';


class CustomBarChart extends StatefulWidget {
    const CustomBarChart( {super.key});

  @override
  State<CustomBarChart> createState() => _CustomBarChartState();
}

class _CustomBarChartState extends State<CustomBarChart> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: BarChart(
        BarChartData(
            minY: 0,
            maxY: 1000,
            
            borderData: FlBorderData(show: false), 
            gridData: FlGridData(
              drawVerticalLine: true,
              drawHorizontalLine: true,
              getDrawingHorizontalLine: (value) {
                return const FlLine(
                  color: Colors.grey,
                  strokeWidth: 1,
                  dashArray: [2, 2],
                );
              },
              getDrawingVerticalLine: (value) {
                return const FlLine(
                  color: Colors.grey,
                  strokeWidth: 1,
                  dashArray: [2, 2],
                );
              },
            ),
            titlesData: FlTitlesData(
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  interval: 200,
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
            barGroups: [
              BarChartGroupData(x: 1, barRods: [
                BarChartRodData(toY: 400, width: 40, color:Colors.grey),
              ]),
              BarChartGroupData(x: 2, barRods: [
                BarChartRodData(toY: 900, width: 40, color:Colors.grey),
              ]),
              BarChartGroupData(x: 3,barRods: [
                 BarChartRodData(
      toY: 600,
      width: 40,
      rodStackItems: [
        BarChartRodStackItem(0, 200, Colors.grey),
        BarChartRodStackItem(200, 400, AppColors.green),
        BarChartRodStackItem(400, 600, const Color.fromARGB(255, 163, 71, 202) ),
      ],
    ),
  ],
),


              BarChartGroupData(x: 4, barRods: [
                BarChartRodData(toY: 240, width: 30, color:Colors.grey),
              ]),
              BarChartGroupData(x: 5, barRods: [
                BarChartRodData(toY: 670, width: 30, color:Colors.grey),
              ]),
              BarChartGroupData(x: 6, barRods: [
                BarChartRodData(toY: 880, width: 30,color:Colors.grey),
              ]),
              BarChartGroupData(x: 7, barRods: [
                BarChartRodData(toY: 786, width: 30, color:Colors.grey),
              ]),
            ],
        ),
      ),
    );
  }
} 