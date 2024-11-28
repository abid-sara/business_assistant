import 'package:flutter/material.dart';
import '../style/colors.dart';

class AddButton extends StatelessWidget {
  const AddButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: const ButtonStyle(
          backgroundColor: WidgetStatePropertyAll<Color>(AppColors.darkGreen),
        ),
        onPressed: () {},
        child: const Row(
          children: [
            Icon(Icons.add),
            Text(
              "Add order",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ));
  }
}

class exportPDF extends StatelessWidget {
  const exportPDF({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: const ButtonStyle(
          backgroundColor: WidgetStatePropertyAll<Color>(AppColors.darkGreen),
        ),
        onPressed: () {
          //we must add the logic that will export the correct PDF
          print("Exporting PDF... ");
        },
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.picture_as_pdf),
            Text(
              "Export PDF",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ));
  }
}
