import 'package:flutter/material.dart';
import '../style/colors.dart';

//button that adds something
class AddButton extends StatelessWidget {
  String thing;
  AddButton({super.key, required this.thing});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: const ButtonStyle(
          backgroundColor: WidgetStatePropertyAll<Color>(AppColors.lightGreen),
        ),
        onPressed: () {},
        child: Row(
          children: [
            const Icon(Icons.add),
            Text(
              "Add $thing",
              style: const TextStyle(fontWeight: FontWeight.bold),
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
