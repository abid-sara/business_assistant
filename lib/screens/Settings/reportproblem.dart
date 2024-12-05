import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; 
import 'package:business_assistant/style/colors.dart';
import 'package:business_assistant/widget/back_arrow.dart';
import 'package:business_assistant/widget/button.dart';

class ReportProblemPage extends StatefulWidget {
  const ReportProblemPage({super.key});

  @override
  State<ReportProblemPage> createState() => _ReportProblemPageState();
}

class _ReportProblemPageState extends State<ReportProblemPage> {
  bool isCheckboxChecked = false;
  String? selectedCategory; 
  XFile? screenshot; 

  final ImagePicker _picker = ImagePicker(); 

  Future<void> _pickScreenshot() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        screenshot = pickedFile;
      });
    }
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
             BackArrow(title: 'Report a problem',),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        const Text(
                          "Describe the issue",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkGreen,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
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
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Attach screenshot:",
                              style: TextStyle(fontSize: 16),
                            ),
                             Flexible(
                               child: ElevatedButton(
                                  onPressed: _pickScreenshot,
                                  style: button, // Apply the button style here
                                  child: const Text("Choose File", style: TextStyle(color: Colors.white, fontSize: 15),),
                                ),
                             ),

                          ],
                        ),
                        if (screenshot != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              "Selected file: ${screenshot!.name}",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        const SizedBox(height: 16),
                        const Text(
                          "Select a category",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkGreen,
                          ),
                        ),
                        Wrap(
                            spacing: 8, // Space between chips
                            runSpacing: 8, // Space between lines of chips
                            children: [
                              _buildChoiceChip("Report a bug"),
                              _buildChoiceChip("Feature request"),
                              _buildChoiceChip("Other"),
                            ],
                        
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Checkbox(
                              value: isCheckboxChecked,
                              onChanged: (value) {
                                setState(() {
                                  isCheckboxChecked = value!;
                                });
                              },
                            ),
                            const Expanded(
                              child: Text("I consent to sharing my device information"),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: ElevatedButton(
                                onPressed: _submitForm,
                                style: button, // Apply the button style here
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

  Widget _buildChoiceChip(String label) {
    final isSelected = selectedCategory == label;
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
        setState(() {
          selectedCategory = selected ? label : null;
        });
      },
    );
  }

  void _submitForm() {
    if (selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a category")),
      );
      return;
    }
    if (!isCheckboxChecked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please consent to sharing device information")),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Form submitted successfully!")),
    );
  }
}
