import 'package:business_assistant/style/colors.dart';
import 'package:business_assistant/widget/button.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                "assets/images/Welome_Page.jpg",
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.04),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 35.0),
                  child: Text(
                    "My Business\nAssistant",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: AppColors.darkGreen, // Your custom color
                      fontWeight: FontWeight.w900,
                      fontSize: 40,
                    ),
                  ),
                ),
                const SizedBox(height: 9),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 35.0),
                  child: Text(
                    "Your All-in-One Digital App for Smarter Business Management",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: AppColors.darkGreen,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                ),
                 SizedBox(height: screenHeight * 0.5),
                Padding(
                  padding: EdgeInsets.fromLTRB(screenWidth*0.35, 0, 0, 0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/signIn');
                    },
                    style: button,
                    child: const Text(
                      'Get Started',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
