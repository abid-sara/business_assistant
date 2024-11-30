import 'package:flutter/material.dart';


class PastDueGoalRow extends StatelessWidget {
  final String title;
  final String date;
  final IconData icon;
  final Color iconColor;

  const PastDueGoalRow({
    super.key,
    required this.title,
    required this.date,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                date,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
        
        Align(
          alignment: Alignment.centerRight,
          child: Icon(
            icon,
            size: 30,
            color: iconColor,
          ),
        ),
      ],
    );
  }
}
