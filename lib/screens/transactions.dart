import 'package:flutter/material.dart';
import '../style/colors.dart';

class CustomRow extends StatelessWidget {
  final Icon? icon; 
  final String title; 
  final String subtitle; 
  final String value; 

  const CustomRow({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    this.icon,
    
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            if ( icon != null) ...[
              icon!,
              const SizedBox(width: 10),
            ],
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 18),
        ),
      ],
    );
  }
}

class Transaction extends StatefulWidget {
  const Transaction({super.key});

  @override
  State<Transaction> createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
  @override
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
       
        centerTitle:true,
        title:  const Text(
          'Transactions',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
          ),
      ),
      body:  SingleChildScrollView(
         child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),  
                fit: BoxFit.cover, 
              ),
            ),
      
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Container(
                    margin:const EdgeInsets.only(top: 20) ,
                    width: 200, 
                    height: 200, 
                    decoration: BoxDecoration(
                      color: Colors.white, 
                      shape: BoxShape.circle, 
                       boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2), 
                      spreadRadius: 3,
                      blurRadius: 3,

                    ),
                  ],
                    ),
                    alignment: Alignment.center, 
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(//HERE THE BALANCE IS TOTAL INCOME - TOTAL EXPENSES
                          'Your total balance ', 
                          style: TextStyle(
                            color: Colors.black, 
                            fontWeight: FontWeight.bold, 
                            fontSize: 16, 
                          ),
                        ),
                        Padding(padding: EdgeInsets.all(10)),
                        Text(
                          ' 7,89999.0 DZD ', 
                          style: TextStyle(
                            color: AppColors.green, 
                            fontWeight: FontWeight.bold, 
                            fontSize: 16, 
                          ),
                        ),

                      Padding(padding: EdgeInsets.all(10)),
                      Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center, 
                    children: [
                      Text(
                        'Hide', 
                        style: TextStyle(
                          fontSize: 16, 
                          
                        ),
                      ),
                      SizedBox(width: 8), 
                      Icon(
                        Icons.visibility_off, 
                        size: 20, 
                        color: Colors.grey, 
                      ),
                    ],
                  ),
                 ] ),
                  ),
                ],
              ),

              Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: (){},
                 style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.green, 
                      foregroundColor: Colors.white, 
                    ),
                 child: const Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                 crossAxisAlignment: CrossAxisAlignment.center,
                 children:[
                 Icon(
                  Icons.north_east,
                  color: Colors.white,
                  size: 30,
                 ),
                Text('Expense '),
                 ],
               ),
           ),
           ElevatedButton(onPressed: (){},
                style: ElevatedButton.styleFrom(
                      backgroundColor:AppColors.purpule, 
                      foregroundColor: Colors.white, 
                    ),
                child: const Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                 crossAxisAlignment: CrossAxisAlignment.center,
                 children:[
                 Icon(
                  Icons.south_west,
                  color: Colors.white,
                  size: 30,
                 ),
                Text('Revenue '),
                 ],
               ),
           ),
            ],
            ),
            const Padding(padding: EdgeInsets.all(10)),
            const Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Recent transactions ',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(padding: EdgeInsets.all(10)),

              Column(
                children: [
                  CustomRow(
                        title: 'Order ',
                        subtitle: '20 Jan 2024 at 10:00 PM',
                        value: '+ 30000 DZD',
                        icon: Icon(
                          Icons.south_west,
                          size: 30,
                          color: AppColors.green,
                        ),
                      ),

                  SizedBox(height: 10), 
                  CustomRow(
                        title: 'Marketing ',
                        subtitle: '20 Jan 2024 at 10:00 PM',
                        value: '- 40000 DZD',
                        icon: Icon(
                          Icons.north_east,
                          size: 30,
                          color: AppColors.green,
                        ),
                      ),
                  SizedBox(height: 10), 
                 CustomRow(
                        title: 'Shopping ',
                        subtitle: '20 Jan 2024 at 10:00 PM',
                        value: '- 20000 DZD',
                        icon: Icon(
                          Icons.north_east,
                          size: 30,
                         color: AppColors.green,
                        ),
                      ),
                ],
              ),
            ],
          ),
        ]),
      ),
      ),
      
                       
                        
                        
                        
                        );
          }
}



              