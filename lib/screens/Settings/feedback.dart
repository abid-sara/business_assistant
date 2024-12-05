import 'package:flutter/material.dart';
import 'package:business_assistant/style/colors.dart';
import 'package:business_assistant/widget/back_arrow.dart';
import 'package:business_assistant/widget/button.dart';

class Feedback extends StatefulWidget {
  const Feedback({super.key});

  @override
  State<Feedback> createState() => _FeedbackState();
}

class _FeedbackState extends State<Feedback> {
  int selectedRating = 0;
  String selectedLikedOption = '';
  String selectedImprovementOption = '';
  final TextEditingController feedbackController = TextEditingController();

  void onRatingSelected(int rating) {
    setState(() {
      selectedRating = rating;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
             BackArrow(title: 'Rate us',),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "How would you rate the prototyping kit?",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkGreen,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: List.generate(5, (index) {
                            return IconButton(
                              icon: Icon(
                                Icons.star,
                                color: index < selectedRating
                                    ? Colors.amber
                                    : Colors.grey,
                              ),
                              onPressed: () => onRatingSelected(index + 1),
                            );
                          }),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "What did you like about it?",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkGreen,
                          ),
                        ),
                        Wrap(
                          spacing: 8,
                          children: ["Easy to use", "Complete", "Helpful", "Looks good"]
                              .map((option) => _buildChoiceChip(
                                    option,
                                    selectedLikedOption,
                                    (value) => setState(() {
                                      selectedLikedOption = value;
                                    }),
                                  ))
                              .toList(),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "What could be improved?",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkGreen,
                          ),
                        ),
                        Wrap(
                          spacing: 8,
                          children: [
                            "Not interactive",
                            "Only English",
                            "Could use more content",
                          ].map((option) => _buildChoiceChip(
                                option,
                                selectedImprovementOption,
                                (value) => setState(() {
                                  selectedImprovementOption = value;
                                }),
                              ))
                              .toList(),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Anything else?",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkGreen,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: feedbackController,
                          maxLines: 5,
                          decoration: InputDecoration(
                            hintText: "Write here",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            fillColor: Colors.white,
                            filled: true,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: ElevatedButton(
                                onPressed: () {
                                  
                                  print("Rating: $selectedRating");
                                  print("Liked: $selectedLikedOption");
                                  print("Improved: $selectedImprovementOption");
                                  print("Feedback:${feedbackController.text}");
                                },
                                style: button,
                                child: const Text(
                                'Submit',
                                style: TextStyle(color: Colors.white, fontSize: 20),
                              ),
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChoiceChip(String label, String selectedOption, Function(String) onSelected) {
    final isSelected = selectedOption == label;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: AppColors.green,
      backgroundColor: const Color.fromARGB(97, 224, 224, 224),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black,
        fontWeight: FontWeight.w500,
      ),
      onSelected: (bool selected) {
        if (selected) onSelected(label);
      },
    );
  }
}
