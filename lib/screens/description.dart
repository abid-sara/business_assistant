import 'package:flutter/material.dart';
import '../style/colors.dart';

class DataField extends StatelessWidget {
  final String text;
  final String description;
  final bool isDescription;//to make the description of the goal bigger than other fields

   const DataField({
    super.key,
    required this.text,
    required this.description,
    this.isDescription = false,
    
  });

  @override
  Widget build(BuildContext context) {
    
    return Column(
                children: [
                    Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        text,
                        style:  const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    ),
                  
                  TextField(
                    maxLines: isDescription ? 5 : 1, 
                    decoration: InputDecoration(
                      fillColor: AppColors.lightGreen,
                       filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,

                      ),
                      
                      hintText: description,
                      hintStyle: const TextStyle(color: Colors.grey),
                      contentPadding: const EdgeInsets.symmetric(vertical :12),
                    ),
                  )]);
    
  }
}
class Description extends StatelessWidget {
  
  const Description({super.key});
  
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
       appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: AppColors.green,
          onPressed: () {},
        ),
        centerTitle:true,
        title:  const Text(
          'Goal description',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      
      body: 
      Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),  
                fit: BoxFit.cover, 
              ),
            ),
      child :Padding(
        padding: const EdgeInsets.all(16),
        child:Center(
        child: Column(
          children: [
           Expanded(
             child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color:AppColors.green,
                borderRadius:BorderRadius.circular(12),),
                width :screenWidth * 0.8,
                height: screenHeight * 0.5,
                child: const Column(
                  children: [
                    DataField(
                      text: 'Title',
                      description: 'Enter the title',
                    ),

                  Padding(padding: EdgeInsets.all(16)),

                    DataField(
                      text: 'Description',
                      description: 'Enter the description',
                      isDescription: true,
                      ),
                      
                     Padding(padding: EdgeInsets.all(16)),
                     Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  DataField(text: 'Start date', description: 'DD/MM/YYYY'),
                                ],
                              ),
                            ),
                            
                            SizedBox(width: 16), 
                            
                            Expanded(
                              child: Column(
                                children: [
                                  DataField(text: 'Limit date', description: 'DD/MM/YYYY'),
                                ],
                              ),
                            ),
                          ],
                        ),
               
             
                  ],
                ),
              ),
           ),
            
            const Padding(padding: EdgeInsets.all(16)),
            ElevatedButton(
             style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.yellowGreen,
             ),
              onPressed: () {},
              child: const Text('Add', style: TextStyle(color: Colors.black)),
            ),
            const Padding(padding: EdgeInsets.all(16)),

                  BottomNavigationBar(
                    type: BottomNavigationBarType.fixed,

                    currentIndex: 0, 
                    onTap: (index) {},
                    items: <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                        icon: SizedBox(
                          height: 20,  
                          width: 20,   
                          child: Image.asset('assets/images/analysis.png'), 
                        ),
                        label: 'Analysis',
                      ),
                      BottomNavigationBarItem(
                        icon: SizedBox(
                          height: 20,  
                          width: 20,   
                          child: Image.asset('assets/images/monitoring.png'), 
                        ),
                        label: 'inventory',
                      ),
                      BottomNavigationBarItem(
                        icon: SizedBox(
                          height: 20,  
                          width: 20,   
                          child: Image.asset('assets/images/star_filled.png'), 
                        ),
                        label: 'Goal',
                      ),
                      BottomNavigationBarItem(
                        icon: SizedBox(
                          height: 20,  
                          width: 20,   
                          child: Image.asset('assets/images/settings.png'), 
                        ),
                        label: 'Settings',
                      ),
                    ],
                  )


          ],
        ),
        ),

        )
        
        )
      ));
    
  }
}
