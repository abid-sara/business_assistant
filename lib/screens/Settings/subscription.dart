import 'package:flutter/material.dart';
import 'package:business_assistant/style/colors.dart';
import 'package:business_assistant/widget/back_arrow.dart';
import 'package:business_assistant/widget/button.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({super.key});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  String selectedPlan = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'), 
                fit: BoxFit.cover, 
              ),
            ),
          ),

          SingleChildScrollView(
            child: Column(
              children: [
                BackArrow(title: 'Subscription'),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        const Text(
                          "Choose your subscription plan",
                          style: TextStyle(
                            fontSize: 33,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkGreen,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "And get a 7-day free trial",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 24),
                        _buildPlanOption(
                          title: "Yearly",
                          price: "DZD 94.80",
                          value: "year",
                          description: "every year",
                        ),
                        _buildPlanOption(
                          title: "Monthly",
                          price: "DZD 10.30",
                          value: "month",
                          description: "every month",
                        ),
                        _buildPlanOption(
                          title: "Weekly",
                          price: "DZD 5.90",
                          value: "week",
                          description: "every week",
                        ),
                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "You'll get:",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.darkGreen,
                                ),
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.star,
                                  color: Colors.amber,),
                                  Text("Unlimited access"),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(Icons.star,
                                  color: Colors.amber,),
                                  Text("Analyze your business"),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(Icons.star,
                                  color: Colors.amber,),
                                  Text("More control over your stock"),
                                ],
                              ),
                            ]
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: ElevatedButton(
                              onPressed: _subscribe,
                              style: button, 
                              child: const Text(
                              'Subscribe',
                              style: TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            ),
                            
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget for Plan Option
  Widget _buildPlanOption({
  required String title,
  required String price,
  required String value,
  required String description,
}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 16),
    decoration: BoxDecoration(
      color: selectedPlan == value ? AppColors.green : Colors.white.withOpacity(0.8),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(
        color: selectedPlan == value ? AppColors.green : Colors.black26,
        width: 2,
      ),
    ),
    child: RadioListTile<String>(
      value: value,
      groupValue: selectedPlan,
      onChanged: (String? newValue) {
        setState(() {
          selectedPlan = newValue!;
        });
      },
      activeColor: Colors.white,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: selectedPlan == value ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                price,
                style: TextStyle(
                  color: selectedPlan == value ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  color: selectedPlan == value ? Colors.white : Colors.black54,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}



  // Subscribe Logic
  void _subscribe() {
    if (selectedPlan.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a subscription plan")),
      );
      return;
    }

    // Subscription logic goes here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Subscribed to $selectedPlan plan!")),
    );
  }
}
