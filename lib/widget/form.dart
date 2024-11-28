import 'package:flutter/material.dart';
import '../style/colors.dart';

var focused = OutlineInputBorder(
  borderRadius: BorderRadius.circular(10.0),
  borderSide: const BorderSide(
      color: Colors.grey), // Set the focused border color to grey
);

var normalBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(10.0),
  borderSide: const BorderSide(color: Colors.grey), // Normal border in grey
);

InputDecoration textFieldDecoration(String? hintText) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: const TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w500,
    ),
    focusedBorder: focused, // Apply focused border
    border: normalBorder, // Apply normal border
  );
}

Widget structure(String title, String hintText, TextEditingController control,
    FormFieldValidator<String> valid) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: AppColors.darkGreen),
      ),
      const SizedBox(height: 5),
      TextFormField(
        controller: control,
        validator: valid,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        decoration: textFieldDecoration(hintText),
      ),
      const SizedBox(height: 18)
    ],
  );
}

String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your email';
  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
    return 'Enter a valid email address';
  }
  return null;
}

String? validateName(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your name';
  } else if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
    return 'Name cannot contain special characters';
  }
  return null;
}
