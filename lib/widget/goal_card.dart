import 'package:flutter/material.dart';
import 'package:business_assistant/data/goaldata.dart';

class GoalCard extends StatefulWidget {
  final Goal goal;
  final String? title; 
  final String? date; 
  final String? status; 
  final Color? backgroundColor; 
  final Color? statusColor; 
  final Function(String)? onStatusChange;

  const GoalCard({
    super.key,
    required this.goal,
    this.title,
    this.date,
    this.status,
    this.backgroundColor,
    this.statusColor,
    this.onStatusChange,
  });

  @override
  State<GoalCard> createState() => _GoalCardState();
}

class _GoalCardState extends State<GoalCard> {

  @override
  Widget build(BuildContext context) {
    return Container(
       padding: const EdgeInsets.all( 11),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: widget.backgroundColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  widget.title ?? 'Untitled Goal',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis, // Ensures text truncates if too long
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.black),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/description', 
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  widget.date ?? '11/10/2024 - 12/10/2024',
                  style: const TextStyle(fontSize: 16),
                  overflow: TextOverflow.ellipsis, // Ensures date text truncates if too long
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: widget.statusColor,
                ),
                child: PopupMenuButton<String>(
                  child: Text(
                    widget.status ?? 'In progress',
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                    overflow: TextOverflow.ellipsis, // Prevents overflow in status text
                  ),
                  onSelected: (String newStatus) {
                    setState(() {
                      widget.goal.setStatus(newStatus);
                    });
                    if (widget.onStatusChange != null) {
                      widget.onStatusChange!(newStatus); 
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return ['Completed', 'In progress'].map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
