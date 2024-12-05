import 'package:business_assistant/style/colors.dart';
import 'package:business_assistant/widget/back_arrow.dart';
import 'package:flutter/material.dart';

class HelpSupportPage extends StatefulWidget {
  const HelpSupportPage({super.key});

  @override
  State<HelpSupportPage> createState() => _HelpSupportPageState();
}

class _HelpSupportPageState extends State<HelpSupportPage> {
  final List<Map<String, dynamic>> _helpTopics = [
    {
      "title": "How to create orders?",
      "description": "To create an order, navigate to the Orders section, click the '+' icon, fill in the details, and submit.",
      "isExpanded": false,
    },
    {
      "title": "How to create a task?",
      "description": "Go to the Tasks section, click 'Add Task', set the deadline, assign it to a team member, and save.",
      "isExpanded": false,
    },
    {
      "title": "How to manage the inventory?",
      "description": "Visit the Inventory page, where you can view, add, or update items in your stock.",
      "isExpanded": false,
    },
  ];

  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final filteredTopics = _helpTopics
        .where((topic) =>
            topic["title"].toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'), // Replace with your image path
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Content
          Column(
            children: [
              BackArrow(title: 'Help & Support',),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center( // Center the logo
                child: Image.asset(
                  'assets/images/logo.png', // Replace with your logo path
                  height: 165, // Adjust height as necessary
                ),
              ),
                    const SizedBox(height: 16),
                    TextField(
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        hintText: "Search for help topics",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Help topics",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkGreen,
                      ),
                    ),
                    const SizedBox(height: 8),
                    filteredTopics.isEmpty
                        ? const Center(
                            child: Text(
                              "No results found.",
                              style: TextStyle(color: Colors.red),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: filteredTopics.length,
                            itemBuilder: (context, index) {
                              final topic = filteredTopics[index];
                              return Column(
                                children: [
                                  ListTile(
                                    title: Text(topic["title"]),
                                    trailing: Icon(
                                      topic["isExpanded"]
                                          ? Icons.expand_less
                                          : Icons.expand_more,
                                    ),
                                    onTap: () {
                                      setState(() {
                                        topic["isExpanded"] =
                                            !topic["isExpanded"];
                                      });
                                    },
                                  ),
                                  if (topic["isExpanded"])
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: Text(
                                        topic["description"],
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            },
                          ),
                    const Divider(),
                    const Text(
                      "Contact us",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkGreen,
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.email),
                      title: const Text("Email us"),
                      onTap: () {
                        // Implement contact functionality
                      },
                    ),
                    const Divider(),
                    const Text(
                      "Learn more",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkGreen,
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.play_circle_fill),
                      title: const Text("User Documentation"),
                      onTap: () {
                        // Implement user documentation functionality
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
