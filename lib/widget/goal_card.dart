import 'package:flutter/material.dart';

class GoalCard extends StatelessWidget {
  final String? title; 
  final String? date; 
  final String? status; 
  final Color? backgroundColor; 
  final Color? statusColor; 

  const GoalCard({
    super.key,
    this.title,
    this.date,
    this.status,
    this.backgroundColor,
    this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: backgroundColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title ?? 'Untitled Goal',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Icon(Icons.edit, color: Colors.black),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                date ?? '11/10/2024 - 12/10/2024',
                style: const TextStyle(fontSize: 16),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: statusColor,
                ),
                child: Text(
                  status ?? 'Missed',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
