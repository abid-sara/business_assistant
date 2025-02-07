import 'package:business_assistant/cubits/Expense/expense_cubit.dart';
import 'package:business_assistant/cubits/Expense/expense_repository.dart';
import 'package:business_assistant/cubits/Income/income_cubit.dart';
import 'package:business_assistant/cubits/Income/income_repository.dart';
import 'package:business_assistant/widget/bar_chart.dart' as widget;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:business_assistant/widget/sidebar.dart';
import 'package:business_assistant/style/colors.dart';

class AnalysisYear extends StatefulWidget {
  const AnalysisYear({super.key});

  @override
  State<AnalysisYear> createState() => _AnalysisYearState();
}

class _AnalysisYearState extends State<AnalysisYear> {
  int selectedIndex = 3;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  final arguments = ModalRoute.of(context)!.settings.arguments;
  if (arguments is int) {
    final int index = arguments;
    if (selectedIndex != index) {
      setState(() {
        selectedIndex = index; 
      });
    }
  } 
  }

  void handleButtonPress(int index, String routeName) {
    setState(() {
      selectedIndex = index;
    });
    Navigator.pushNamed(context, routeName, arguments: index);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      drawer: const Sidebar(),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Analysis of the year',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ExpenseCubit(repository: ExpenseRepository())..loadExpensesGroupedByDate(),
          ),
          BlocProvider(
            create: (context) => IncomeCubit(repository: IncomeRepository())..loadIncomeGroupedByDate(),
          ),
        ],
        child: SingleChildScrollView(
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
                  const Padding(padding: EdgeInsets.all(10)),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Your expenses',
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.all(10)),
                  Container(
                    width: screenWidth * 0.9,
                    height: 250,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(0),
                      color: Colors.white,
                    ),
                    child: const widget.CustomBarChart(isExpense: true, viewType: "yearly"),
                  ),
                  const Padding(padding: EdgeInsets.all(10)),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Your Income',
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.all(10)),
                  Container(
                    width: screenWidth * 0.9,
                    height: 250,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(0),
                      color: Colors.white,
                    ),
                    child: const widget.CustomBarChart(isExpense: false, viewType: "yearly"),
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
