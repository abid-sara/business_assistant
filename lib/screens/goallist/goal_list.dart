import 'dart:core';

import 'package:business_assistant/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:business_assistant/widget/goal_card.dart';
import 'package:business_assistant/data/goaldata.dart';
import 'package:business_assistant/widget/past_due_goal.dart';
import 'package:intl/intl.dart';
import 'package:business_assistant/widget/sidebar.dart';
import 'package:business_assistant/database/goal_db.dart';

class GoalList extends StatefulWidget {
  const GoalList({super.key});

  @override
  State<GoalList> createState() => _GoalListState();
}

class _GoalListState extends State<GoalList> {
  String _selectedDate = 'November 2024'; // Initial date to display
  List<Goal> goals = [];
  final GoalDB _goalDB = GoalDB.instance;

  @override
  void initState() {
    super.initState();
    _loadGoals();
  }

  Future<void> _loadGoals() async {
  // Fetch only non-deleted goals from the database
  final loadedGoals = await _goalDB.fetchGoals();
  setState(() {
    goals = loadedGoals;
  });
}


  Future<void> _addGoal(Goal goal) async {
    await _goalDB.insertGoal(goal);
    _loadGoals();
  }

  void _deleteGoal(Goal goal) async {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Delete goal'),
        content: const Text('Are you sure you want to delete this goal?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              // Ensure the goal id is not null before deleting
              if (goal.id != null) {
                await _goalDB.deleteGoal(goal.id!);  // Use the null check operator here
                setState(() {
                  goals.remove(goal);
                });
              } else {
                // Handle the case where goal.id is null
                print('Goal ID is null, cannot delete.');
              }

              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      );
    },
  );
}




  Future<void> _updateGoal(Goal goal) async {
    await _goalDB.updateGoal(goal);
    _loadGoals();
  }
  Future<void> _updateGoalStatus(Goal goal, String newStatus) async {
  final updatedGoal = Goal(
    id: goal.id,
    title: goal.title,
    description: goal.description,
    startDate: goal.startDate,
    limitDate: goal.limitDate,
    status: newStatus,
  );

  await _goalDB.updateGoal(updatedGoal); // Update the status in the database
  await _loadGoals(); // Reload goals to refresh the UI
} 

  // Change the status according to the limit date
  String _getStatus(Goal goal) {
    if (goal.limitDate.isBefore(DateTime.now()) &&
        goal.status == 'In progress') return 'Missed';
    if (goal.status == 'Completed') return 'Completed';
    return goal.status;
  }

  // Function to determine status background color based on the getStatus function
  Color _getStatusColor(String status) {
    if (status == 'In progress') return AppColors.lightGreen;
    return AppColors.green;
  }

  // Function to determine status text color
  Color _getStatusTextColor(String status) {
    if (status == 'Missed' || status == 'In Progress') return AppColors.purpule;
    return AppColors.lightGreen;
  }

  List<PastDueGoalRow> _checkPastDueGoals() {
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

  @override
  Widget build(BuildContext context) {
    List<PastDueGoalRow> pastDueGoals = _checkPastDueGoals();

    return Scaffold(
      drawer: const Sidebar(),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Goals list',
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
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      setState(() {
                        DateTime currentDate =
                            DateFormat('MMMM yyyy').parse(_selectedDate);
                        DateTime previousMonth =
                            DateTime(currentDate.year, currentDate.month - 1);
                        _selectedDate =
                            DateFormat('MMMM yyyy').format(previousMonth);
                      });
                    },
                  ),
                  Text(
                    _selectedDate,
                    style: const TextStyle(fontSize: 20),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_ios),
                        onPressed: () {
                          setState(() {
                            DateTime currentDate =
                                DateFormat('MMMM yyyy').parse(_selectedDate);
                            DateTime nextMonth =
                                DateTime(currentDate.year, currentDate.month + 1);
                            _selectedDate =
                                DateFormat('MMMM yyyy').format(nextMonth);
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () {
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          ).then((pickedDate) {
                            setState(() {
                              if (pickedDate != null) {
                                final formattedDate =
                                    DateFormat('MMMM yyyy').format(pickedDate);
                                _selectedDate = formattedDate;
                              }
                            });
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              Expanded(
                child: ListView(
                  children: [
                    ...goals.map(
                      (goal) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: GoalCard(
                            goal: goal,
                            title: goal.title,
                            date:
                                '${DateFormat('dd/MM/yyyy').format(goal.startDate)} - ${DateFormat('dd/MM/yyyy').format(goal.limitDate)}',
                            status: _getStatus(goal),
                            statusColor: _getStatusTextColor(goal.status),
                            backgroundColor: _getStatusColor(goal.status),
                            onMarkAsCompleted: () => _updateGoalStatus(goal, 'Completed'),
                            onDelete: () => _deleteGoal(goal),
                            onStatusChange: (newStatus) => _updateGoalStatus(goal, newStatus),
                            onUpdate: (updatedGoal) {
                              // Update the goal in the list and refresh UI
                              setState(() {
                                final index = goals.indexWhere((g) => g.id == updatedGoal.id);
                                if (index != -1) {
                                  goals[index] = updatedGoal;
                                }
                              });
                            },
                          ),
                        );
                      },
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        'Past due goals',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ...pastDueGoals.map((pastDueGoal) {
                      return pastDueGoal;
                    }),
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
                  // Navigate to the AddGoalPage and wait for the result
                  final newGoal = await Navigator.pushNamed(
                    context,
                    '/description',
                  );

                  // Reload goals from the database to avoid duplicate entries
                  if (newGoal != null) {
                    await _loadGoals();
                  }
                },
              ),

            ],
          ),
        ),
      ),
    );
  }
}
