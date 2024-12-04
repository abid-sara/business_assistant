import 'package:business_assistant/widget/back_arrow.dart';
import 'package:flutter/material.dart';
import '../../style/colors.dart';
import 'package:business_assistant/widget/bar_chart.dart';

class SelectedButton extends StatefulWidget {
  final String label;
  final String routeName;

  const SelectedButton({
    super.key,
    required this.label,
    required this.routeName,
  });

  @override
  State<SelectedButton> createState() => _SelectedButtonState();
}

class _SelectedButtonState extends State<SelectedButton> {
  bool _isPressed = false;

  void _handlePress() {
    setState(() {
      _isPressed = !_isPressed;
    });
     Navigator.pushNamed(context, widget.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        //if the button is pressed we need to diffrentiate it
        backgroundColor: _isPressed ? Colors.white : AppColors.green,
        foregroundColor: _isPressed ? AppColors.green : Colors.white,
        minimumSize: const Size(80, 40), 
      ),
      onPressed: _handlePress,
      child: Text(widget.label),
    );
  }
}
class AnalysisWeek extends StatelessWidget {
  const AnalysisWeek({super.key});

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
      child:Padding(
        padding: const EdgeInsets.all(10),
        child:Center(
        child: Column(
          children: [ 
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                        SelectedButton(
                          label: '24h',
                          routeName: '/transaction', 
                          
                        ),
                        
                        SelectedButton(
                          label: 'Week',
                          routeName:  '/analysis', 
                              
                        ),
                        SelectedButton(
                          label: 'Month',
                          routeName: '/analysisweek', 
                              
                        ),
                        SelectedButton(
                          label: 'Year',
                        routeName: '/analysisweek', 
                              
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