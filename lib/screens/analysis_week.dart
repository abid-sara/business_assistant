import 'package:flutter/material.dart';
import '../style/colors.dart';
import '../widget/bar_chart.dart';

class SelectedButton extends StatelessWidget{
  final String label;
  final VoidCallback onPressed;
  final Icon? icon;

  const SelectedButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon ,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.green, 
                      foregroundColor: Colors.white, 
                    ),
                    
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) icon!,
          Text(label),
        ],
      )
    );
  }
}
class AnalysisWeek extends StatelessWidget {
  const AnalysisWeek({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
       appBar: AppBar(
       
        centerTitle:true,
        title:  const Text(
          'Analytics',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
         
        ),
      ),
        
      
      body: SingleChildScrollView( 
      child:Padding(
        padding: const EdgeInsets.all(10),
        child:Center(
        child: Column(
          children: [ 
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
              SelectedButton(
                label: '24h',
                onPressed: () {},
              ),
              SelectedButton(
                label: 'Week',
                onPressed: () {},
              ),
              SelectedButton(
                label: 'Month',
                onPressed: () {},
              ),
              SelectedButton(
                label: 'Year',
                onPressed: () {},
              ),
             SelectedButton(label: ' ', onPressed: () {}, icon: const Icon(Icons.tune)),
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
            // child:CustomBarChart(),
       
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
            // child:CustomBarChart(),
       
      ),
    ),
              
                        ])),
                        
                        ))
                        
                        
                        
                        );
                      
                    
                }
              }