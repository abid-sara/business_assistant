import 'package:business_assistant/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:business_assistant/screens/goallist/update_goal.dart';
import 'package:business_assistant/data/goaldata.dart';

class GoalCard extends StatelessWidget {
  final Goal goal;
  final String title;
  final String date;
  final String status;
  final Color backgroundColor;
  final Color statusColor;
  final VoidCallback? onMarkAsCompleted;
  final VoidCallback? onDelete;
  final Function(String)? onStatusChange;
  final Function(Goal)? onUpdate;  // Add callback to update goal

  const GoalCard({
    Key? key,
    required this.goal,
    required this.title,
    required this.date,
    required this.status,
    required this.backgroundColor,
    required this.statusColor,
    this.onMarkAsCompleted,
    this.onDelete,
    this.onStatusChange,
    this.onUpdate,  // Pass the callback
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: backgroundColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(
                 mainAxisAlignment: MainAxisAlignment.end,
                children:[
                 IconButton(
                  icon: const Icon(Icons.edit, color: Colors.black),
                  onPressed: () {
                    // Navigate to UpdateGoalPage and pass the goal for updating
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UpdateGoalPage(
                          goal: goal,
                          onUpdate: (updatedGoal) {
                            // Use the onUpdate callback to update the goal in the list
                            if (onUpdate != null) {
                              onUpdate!(updatedGoal);  // Call onUpdate
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),
              
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: onDelete ?? () {},
              ),
                ]
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  date,
                  style: const TextStyle(fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: statusColor,
                ),
                child: PopupMenuButton<String>(
  child: Text(
    status,
    style: const TextStyle(fontSize: 16, color: Colors.black),
    overflow: TextOverflow.ellipsis,
  ),
  onSelected: (String newStatus) {
    if (onStatusChange != null) {
      onStatusChange!(newStatus); // Trigger the callback with the new status
    }
  },
  itemBuilder: (BuildContext context) {
    return [
      PopupMenuItem<String>(
        value: 'Completed',
        child: Text(
          'Completed',
          style: TextStyle(color: AppColors.green),
        ),
      ),
      PopupMenuItem<String>(
        value: 'In progress',
        child: Text(
          'In Progress',
          style: TextStyle(color: AppColors.lightGreen),
        ),
      ),
    ];
  },
),

                ),
        ]
        ),
            ],
          ),
    );
  }
}
