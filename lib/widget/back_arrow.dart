import 'package:flutter/material.dart';
import '../style/colors.dart';

class BackArrow extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onPressed;
  String title;

  BackArrow({super.key, this.onPressed, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 23, top: 23),
            child: Container(
              padding: const EdgeInsets.all(2), // Padding within the circle
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.yellowGreen, // Background color
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.keyboard_arrow_left,
                  size: 30,
                  color: AppColors.darkGreen, // Icon color
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
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
