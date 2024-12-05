import 'package:business_assistant/widget/back_arrow.dart';
import 'package:flutter/material.dart';
import '../../style/colors.dart';
import 'package:business_assistant/widget/bar_chart.dart';

class SelectedButton extends StatefulWidget {
  final String label;
  final int index;  // Add index to identify each button
  final int selectedIndex;  // Add selectedIndex to track the currently selected button
  final VoidCallback onPressed;

  const SelectedButton({super.key, 
    required this.label,
    required this.index,
    required this.selectedIndex,
    required this.onPressed,
  });

  @override
  _SelectedButtonState createState() => _SelectedButtonState();
}

class _SelectedButtonState extends State<SelectedButton> {
  @override
  Widget build(BuildContext context) {
    // Check if the button is selected based on the selectedIndex
    bool isSelected = widget.selectedIndex == widget.index;

    return ElevatedButton(
      onPressed: widget.onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.white : AppColors.green, // Change background color
        foregroundColor: isSelected ? AppColors.green : Colors.white, // Change text color
        minimumSize: const Size(80, 40),
      ),
      child: Text(widget.label),
    );
  }
}

 
class AnalysisWeek extends StatefulWidget {
  const AnalysisWeek({super.key});

  @override
  State<AnalysisWeek> createState() => _AnalysisWeekState();
}
class _AnalysisWeekState extends State<AnalysisWeek> {
  int selectedIndex = -1;

      @override
      void didChangeDependencies() {
        super.didChangeDependencies();
        final int? index = ModalRoute.of(context)!.settings.arguments as int?;
        if (index != null && selectedIndex != index) {
          setState(() {
            selectedIndex = index; // Ensure selectedIndex is updated from arguments
          });
        }
      }

      void handleButtonPress(int index, String routeName) {
        setState(() {
          selectedIndex = index; // Update selectedIndex locally when a button is pressed
        });
        Navigator.pushNamed(context, routeName, arguments: index); // Pass selectedIndex when navigating
      }

      @override
      Widget build(BuildContext context) {
        double screenWidth = MediaQuery.of(context).size.width;

        return Scaffold(
          appBar: BackArrow(
            onPressed: () {
              Navigator.pushNamed(context, '/analysis');
            },
            title: 'Analytics',
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Center(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SelectedButton(
                          label: 'Week',
                          index: 1,
                          selectedIndex: selectedIndex,
                          onPressed: () {
                            handleButtonPress(1, '/analysis');
                          },
                        ),
                        SelectedButton(
                          label: 'Month',
                          index: 2,
                          selectedIndex: selectedIndex,
                          onPressed: () {
                            handleButtonPress(2, '/analysisweek');
                          },
                        ),
                        SelectedButton(
                          label: 'Year',
                          index: 3,
                          selectedIndex: selectedIndex,
                          onPressed: () {
                            handleButtonPress(3, '/analysisweek');
                          },
                        ),
                      ],
            ),

            const Padding(padding: EdgeInsets.all(10)) ,
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Your expenses',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                
              ),
            ),
            const Padding(padding: EdgeInsets.all(10)) ,
            Container(
          width: screenWidth * 0.9, 
          height: 250,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(0), 
            color: Colors.white, 
          ),
          child: const Padding(
            padding: EdgeInsets.all(8.0),  
            child: CustomBarChart(isExpense: true),
       
      ),
    ),
     const Padding(padding: EdgeInsets.all(10)) ,
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Your Income',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                
              ),
            ),
            const Padding(padding: EdgeInsets.all(10)) ,
            Container(
          width: screenWidth * 0.9, 
          height: 250,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(0), 
            color: Colors.white, 
          ),
          child: const Padding(
            padding: EdgeInsets.all(8.0),  
            child:CustomBarChart(isExpense: false,),
       
      ),
    ),
              
                        ])),
                        
                        ))
                        
                        
                        
                        );
                      
                    
                }
              }