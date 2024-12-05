import 'package:business_assistant/style/colors.dart';
import 'package:flutter/material.dart';
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
  String _selectedDate =
      'November 2024'; //initiale date to be displayed at the top of the page

  List<Goal> goals = [];

  @override
  void initState() {
    super.initState();
    _initializeGoals();
  }

  void _initializeGoals() {
    goals = List.from(goallist);
  }

  //change the status according to the limit date
  String _getStatus(Goal goal) {
    if (goal.limit_date.isBefore(DateTime.now()) &&
        goal.status == 'In progress') return 'Missed';
    if (goal.status == 'Completed') return 'Completed';
    return goal.status;
  }

  // Function to determine status background color based on the getstatus function
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
    List<PastDueGoalRow> pastDueRows = [];
    for (Goal goal in goals) {
      if (goal.limit_date.isBefore(DateTime.now())) {
        pastDueRows.add(
          PastDueGoalRow(
            title: goal.title,
            date: DateFormat('dd/MM/yyyy').format(goal.limit_date),
            icon: (goal.status == 'Completed')
                ? Icons.sentiment_satisfied_rounded
                : Icons.sentiment_dissatisfied_rounded,
            iconColor:
                (goal.status == 'Completed') ? AppColors.darkGreen : Colors.red,
          ),
        );
      }
    }
    return pastDueRows;
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
                            DateTime previousMonth = DateTime(
                                currentDate.year, currentDate.month + 1);
                            _selectedDate =
                                DateFormat('MMMM yyyy').format(previousMonth);
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
                                '${DateFormat('dd/MM/yyyy').format(goal.startDateOnly)} - ${DateFormat('dd/MM/yyyy').format(goal.limitDateOnly)}',
                            status: goal.status,
                            backgroundColor: _getStatusColor(goal.status),
                            statusColor: _getStatusTextColor(goal.status),
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
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/description',
                  ).then((newGoal) {
                    if (newGoal != null) {
                      setState(() {
                        goals.add(newGoal as Goal);
                      });
                    }
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
