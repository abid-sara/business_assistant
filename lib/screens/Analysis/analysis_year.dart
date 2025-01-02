import 'package:business_assistant/cubits/Expense/expense_cubit.dart';
import 'package:business_assistant/cubits/Expense/expense_repository.dart';
import 'package:business_assistant/cubits/Expense/expense_state.dart';
import 'package:business_assistant/cubits/Income/income_cubit.dart';
import 'package:business_assistant/cubits/Income/income_repository.dart';
import 'package:business_assistant/cubits/Income/income_state.dart';
import 'package:business_assistant/widget/bar_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

class AnalysisYear extends StatefulWidget {
  const AnalysisYear({super.key});

  @override
  State<AnalysisYear> createState() => _AnalysisYearState();
}

class _AnalysisYearState extends State<AnalysisYear> {
  int selectedIndex = 1;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void handleButtonPress(int index, String routeName) {
    setState(() {
      selectedIndex = index;
    });

    // Trigger the cubit to reload the expenses data
    context.read<ExpenseCubit>().loadExpensesGroupedByDate();

    Navigator.pushReplacementNamed(context, routeName, arguments: index);
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Weekly Analysis'),
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
                // Always render the CustomBarChart, even if the data is empty
                BlocBuilder<ExpenseCubit, ExpenseState>(
                  builder: (context, state) {
                    if (state is ExpenseLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is ExpenseLoaded) {
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
                            isExpense: true,
                            viewType: 'yearly',
                            
                          ),
                        ),
                      );
                    } else {
                      // Display an empty chart when there is no data loaded yet
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
                            isExpense: true,
                            viewType: 'yearly',
                     
                          ),
                        ),
                      );
                    }
                  },
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
                // Always render the CustomBarChart for income, even if the data is empty
                BlocBuilder<IncomeCubit, IncomeState>(
                  builder: (context, state) {
                    if (state is IncomeLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is IncomeLoaded) {
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
                            isExpense: false,
                            viewType: 'yearly',
                           
                          ),
                        ),
                      );
                    } else {
                      // Display an empty chart when there is no data loaded yet
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
                            isExpense: false,
                            viewType: 'yearly',
                           
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
