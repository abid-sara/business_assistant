import 'package:flutter/material.dart';

import '../style/colors.dart';

var button = ElevatedButton.styleFrom(
  minimumSize: const Size(300, 48),
  backgroundColor: AppColors.darkGreen, // Dark green
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(50.0),
  ),
);
