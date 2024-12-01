import 'package:business_assistant/widget/back_arrow.dart';
import 'package:business_assistant/widget/button.dart';
import 'package:flutter/material.dart';

import '../style/colors.dart';
import '../widget/form.dart';

class Businessdetails extends StatefulWidget {
  const Businessdetails({super.key});

  @override
  State<Businessdetails> createState() => _BusinessdetailsState();
}

class _BusinessdetailsState extends State<Businessdetails> {
  String? selectedBusinessType = 'Small-home based business';

  final List<String> businessTypes = [
    'Small-home based business',
    'Retail business',
    'Online store',
    'Consulting',
    'Service-based business'
  ];

  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const BackArrow(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                const Text(
                  'Add the details of your business',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkGreen,
                  ),
                ),
                const SizedBox(height: 19),
                const Text(
                  "Add the type and the title of your business to help us customize the app for you",
                  style: TextStyle(color: Colors.grey, fontSize: 17),
                ),
                const SizedBox(height: 52),
                Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        "Type of business",
                        style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkGreen),
                      ),
                      const SizedBox(height: 5),
                      DropdownButtonFormField<String>(
                        dropdownColor: AppColors.lightGreen,
                        value: selectedBusinessType,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedBusinessType = newValue;
                          });
                        },
                        items: businessTypes
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        isExpanded: true,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: AppColors.darkGreen),
                            )),
                      ),
                      const SizedBox(height: 20),
                      structure(
                        "Name of your business",
                        "Enter the name",
                        _nameController,
                        validateName,
                      ),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {},
                            style: button,
                            child: const Text(
                              "Save information",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(100, 48),
                              backgroundColor: Colors.grey,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                            ),
                            child: const Text(
                              "Skip for now",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
