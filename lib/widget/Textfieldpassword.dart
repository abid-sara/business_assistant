import 'package:flutter/material.dart';
import 'package:business_assistant/style/colors.dart';  // Assuming your AppColors are defined here

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? Function(String)? validator;
  final String? errorText;
  final bool obscureText;
  final VoidCallback? onChanged;

  const CustomTextField({
    super.key,
    required this.label,
    required this.controller,
    this.validator,
    this.errorText,
    this.obscureText = false,  // By default, we mask the text for passwords
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: controller,
            obscureText: obscureText,
            onChanged: (_) {
              if (onChanged != null) onChanged!();  // Trigger the onChanged callback if provided
            },
            decoration: InputDecoration(
              labelText: label,
              labelStyle: const TextStyle(color: Color.fromARGB(255, 146, 146, 146)),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.green, width: 2.0),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.green, width: 2.0),
                borderRadius: BorderRadius.circular(8),
              ),
              errorText: errorText,  // Displays error text if provided
            ),
          ),
          if (errorText != null) // If errorText is not null, display it below the field
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
