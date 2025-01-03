import 'package:business_assistant/cubits/goals/goal_cubit.dart';
import 'package:business_assistant/cubits/goals/goal_repository.dart';
import 'package:business_assistant/cubits/goals/goal_state.dart';
import 'package:business_assistant/screens/goallist/description.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:business_assistant/style/colors.dart';
import 'package:business_assistant/widget/goal_card.dart';
import 'package:business_assistant/data/goaldata.dart';
import 'package:business_assistant/widget/past_due_goal.dart';
import 'package:intl/intl.dart';
import 'package:business_assistant/widget/sidebar.dart';


class GoalList extends StatefulWidget {
  const GoalList({super.key});

  @override
  State<GoalList> createState() => _GoalListState();
}

class _GoalListState extends State<GoalList> {
  String _selectedDate = 'November 2024'; // Initial date to display

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GoalCubit(GoalRepository())..fetchGoals(),
      child: Scaffold(
        drawer: const Sidebar(),
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Goals List',
            style: TextStyle(fontSize: 20),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: BlocBuilder<GoalCubit, GoalState>(
              builder: (context, state) {
                if (state is GoalLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is GoalLoaded) {
                  final goals = state.goals;
                  final pastDueGoals = _checkPastDueGoals(goals);

                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios),
                            onPressed: _navigateToPreviousMonth,
                          ),
                          Text(
                            _selectedDate,
                            style: const TextStyle(fontSize: 20),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.arrow_forward_ios),
                                onPressed: _navigateToNextMonth,
                              ),
                              IconButton(
                                icon: const Icon(Icons.calendar_today),
                                onPressed: _selectDate,
                              ),
                            ],
                          ),
                        ],
                      ),
                      Expanded(
                        child: ListView(
                          children: [
                            ...goals.map((goal) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                child: GoalCard(
                                      goal: goal,
                                      title: goal.title,
                                      date:
                                          '${DateFormat('dd/MM/yyyy').format(goal.startDate)} - ${DateFormat('dd/MM/yyyy').format(goal.limitDate)}',
                                      status: goal.status,
                                      statusColor: goal.status == 'Completed' ? AppColors.green : AppColors.lightGreen,
                                      backgroundColor: Colors.white,
                                      onDelete: () {
                                        context.read<GoalCubit>().deleteGoal(goal.id!);
                                      },
                                      onUpdate: (updatedGoal) {
                                        context.read<GoalCubit>().updateGoal(updatedGoal);
                                      },
                                      onStatusChange: (newStatus) {
                                        final updatedGoal = Goal(
                                          id: goal.id,
                                          title: goal.title,
                                          description: goal.description,
                                          startDate: goal.startDate,
                                          limitDate: goal.limitDate,
                                          status: newStatus,
                                          deleted: goal.deleted,
                                        );
                                        context.read<GoalCubit>().updateGoal(updatedGoal);
                                      },
                                )
                              );
                            }).toList(),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                'Past Due Goals',
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                            ),
                            ...pastDueGoals,
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.add_circle,
                          color: AppColors.green,
                          size: 40,
                        ),
                        onPressed: () async {
                        final newGoal = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AddGoalPage()),
                        );
                        if (newGoal != null) {
                          // Add the goal via GoalCubit
                          context.read<GoalCubit>().addGoal(newGoal as Goal);
                        }
                      },


                      ),
                    ],
                  );
                } else if (state is GoalError) {
                  return Center(child: Text(state.message));
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToPreviousMonth() {
    setState(() {
      DateTime currentDate = DateFormat('MMMM yyyy').parse(_selectedDate);
      DateTime previousMonth =
          DateTime(currentDate.year, currentDate.month - 1);
      _selectedDate = DateFormat('MMMM yyyy').format(previousMonth);
    });
  }

  void _navigateToNextMonth() {
    setState(() {
      DateTime currentDate = DateFormat('MMMM yyyy').parse(_selectedDate);
      DateTime nextMonth = DateTime(currentDate.year, currentDate.month + 1);
      _selectedDate = DateFormat('MMMM yyyy').format(nextMonth);
    });
  }

  void _selectDate() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    ).then((pickedDate) {
      setState(() {
        if (pickedDate != null) {
          final formattedDate = DateFormat('MMMM yyyy').format(pickedDate);
          _selectedDate = formattedDate;
        }
      });
    });
  }

  List<PastDueGoalRow> _checkPastDueGoals(List<Goal> goals) {
    return goals
        .where((goal) => goal.limitDate.isBefore(DateTime.now()))
        .map((goal) {
      return PastDueGoalRow(
        title: goal.title,
        date: DateFormat('dd/MM/yyyy').format(goal.limitDate),
        icon: (goal.status == 'Completed')
            ? Icons.sentiment_satisfied_rounded
            : Icons.sentiment_dissatisfied_rounded,
        iconColor:
            (goal.status == 'Completed') ? AppColors.darkGreen : Colors.red,
      );
    }).toList();
  }
}
