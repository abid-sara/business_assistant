import 'package:flutter/material.dart';
import 'package:business_assistant/style/colors.dart';

class buildTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? hint;
  final String? Function(String)? validator; // Validation function
  final String? errorText; // Error message to display
  final bool obscureText; // To mask text for passwords
  final TextInputType? keyboardType; // New parameter to define the keyboard type

  const buildTextField({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.validator,
    this.errorText,
    this.obscureText = false,
    this.keyboardType, // Allow keyboard type customization
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType, // Pass the keyboardType here
            decoration: InputDecoration(
              labelText: label,
              hintText: hint,
              labelStyle: const TextStyle(color: Color.fromARGB(255, 146, 146, 146)),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.green, width: 2.0),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.green, width: 2.0),
                borderRadius: BorderRadius.circular(8),
              ),
              errorText: errorText, // Display error text dynamically
            ),
          ),
          if (errorText != null) // Display error below the TextField if available
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                errorText!,
                style: const TextStyle(color: Colors.red, fontSize: 12.0),
              ),
            ),
        ],
      ),
    );
  }
}
