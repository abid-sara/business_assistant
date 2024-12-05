import 'package:flutter/material.dart';
import '../style/colors.dart';

class BackArrow extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onPressed;
  String title;

  BackArrow({super.key, this.onPressed, required this.title});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return AppBar(
      title: Text(title),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: Row(
        children: [
          SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                  left: screenWidth * 0.04, top: screenHeight * 0.03),
              child: Container(
                padding: const EdgeInsets.all(2), // Padding within the circle
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.yellowGreen, // Background color
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.keyboard_arrow_left,
                    size: screenWidth * 0.1,
                    color: AppColors.darkGreen, // Icon color
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}
