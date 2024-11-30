import 'package:business_assistant/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:business_assistant/widget/goal_card.dart';
import 'package:business_assistant/widget/past_due_goal.dart';
import 'package:business_assistant/widget/back_arrow.dart';

class GoalList extends StatefulWidget {
  const GoalList({super.key});

  @override
  State<GoalList> createState() => _GoalListState();
}

class _GoalListState extends State<GoalList> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Goals list',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
        leading: const Flexible(child: BackArrow()),

        
      ),
      extendBodyBehindAppBar: true, 
      body: SingleChildScrollView(
        child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),  
                fit: BoxFit.cover, 
              ),
            ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Navigation Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      
                    },
                  ),
                  const Text(
                    'November 2024',
                    style: TextStyle(fontSize: 20),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_ios),
                        onPressed: () {
                          
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () {
                          
                        },
                      ),
                    ],
                  ),
                ],
              ),

        
         const SizedBox(height: 20),


              // Goal Cards
              const GoalCard(
                title: 'Goal 1',
                date: '23 Jan - 24 Jan',
                status: 'Missed',
                backgroundColor: Color.fromARGB(255, 232, 156, 151),
                statusColor: AppColors.lightGreen,
              ),
              const SizedBox(height: 10),
              const GoalCard(
                title: 'Goal 2',
                date: '23 Jan - 24 Jan',
                status: 'In Progress',
                backgroundColor: AppColors.yellowGreen,
                statusColor: AppColors.lightGreen,
              ),
              const SizedBox(height: 10),
              const GoalCard(
                title: 'Goal 3',
                date: '23 Jan - 24 Jan',
                status: 'Completed',
                backgroundColor: AppColors.green,
                statusColor: AppColors.lightGreen,
              ),

              const SizedBox(height: 20),

              // Past Due Goals 
              const Text(
                'Past due goals',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const PastDueGoalRow(
                title: 'Revenue Growth',
                date: '01 Jan - 02 Jan',
                icon: Icons.sentiment_satisfied_alt_rounded,
                iconColor: AppColors.darkGreen,
              ),
              const SizedBox(height: 10),
              const PastDueGoalRow(
                title: 'Customer Acquisition',
                date: '01 Jan - 02 Jan',
                icon: Icons.sentiment_dissatisfied_rounded,
                iconColor: Colors.red,
              ),
              const SizedBox(height: 10),
              const PastDueGoalRow(
                title: 'Cost Reduction',
                date: '01 Jan - 02 Jan',
                icon: Icons.sentiment_dissatisfied_rounded,
                iconColor: Colors.red,
              ),
              const SizedBox(height: 10),
              const PastDueGoalRow(
                title: 'Digital Transformation',
                date: '01 Jan - 02 Jan',
                icon: Icons.sentiment_satisfied_alt_rounded,
                iconColor: AppColors.darkGreen,
              ),
              const Align(
                alignment: Alignment.centerRight,
                child: Icon(
                  Icons.add_circle_rounded,
                  color: AppColors.green,
                  size: 40,
                ),
              ),

              //Bottom bar
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
            
      ),
      
    ));
  }
}
