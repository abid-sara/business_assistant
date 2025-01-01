import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:business_assistant/cubits/Expense/expense_cubit.dart';
import 'package:business_assistant/cubits/Expense/expense_repository.dart';
import 'package:business_assistant/widget/bar_chart.dart' as widget_bar_chart;
import 'package:business_assistant/screens/Analysis/analysis_week.dart';

class AnalysisYear extends StatefulWidget {
  const AnalysisYear({super.key});

  @override
  State<AnalysisYear> createState() => _AnalysisYearState();
}

class _AnalysisYearState extends State<AnalysisYear> {
  int selectedIndex = 3;

  void handleButtonPress(int index, String routeName) {
    setState(() {
      selectedIndex = index;
      Navigator.pushNamed(context, routeName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExpenseCubit(
        repository: ExpenseRepository(),
      )..loadExpenses(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
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
                  const SizedBox(height: 20),
                  Container(
                    height: 250,
                    child: const widget_bar_chart.CustomBarChart(
                      isExpense: true,
                      viewType: 'yearly',
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 250,
                    child: const widget_bar_chart.CustomBarChart(
                      isExpense: false,
                      viewType: 'yearly',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}