import 'package:flutter/material.dart';

class Searchbar extends StatefulWidget {
  const Searchbar({super.key});

  @override
  State<Searchbar> createState() => _SearchbarState();
}

class _SearchbarState extends State<Searchbar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
      ),
      child: const TextField(
        decoration: InputDecoration(
          hintText: 'Search...',
          border: InputBorder.none,
          prefixIcon: Icon(Icons.search),
          contentPadding: EdgeInsets.symmetric(vertical: 10),
        ),
      ),
    );
  }
}
