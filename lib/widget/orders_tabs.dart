import 'package:flutter/material.dart';
import 'package:business_assistant/widget/searchBar.dart';

class FilterTabs extends StatefulWidget {
  const FilterTabs({super.key});

  @override
  State<FilterTabs> createState() => _FilterTabsState();
}

class _FilterTabsState extends State<FilterTabs> {
  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Searchbar(),
          TabButton(title: "All", color: Colors.green),
          TabButton(title: "Delivered", color: Colors.grey),
          TabButton(title: "Non-delivered", color: Colors.red)
        ],
      ),
    );
  }
}

class TabButton extends StatelessWidget {
  final String title;
  final Color color;

  const TabButton({super.key, required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: color), // Outline color
        backgroundColor: Colors.transparent, // Background color
      ),
      child: Text(title, style: TextStyle(color: color)),
    );
  }
}
