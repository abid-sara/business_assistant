import 'package:flutter/material.dart';
import '../style/colors.dart';
import '../widget/bar_chart.dart';
import 'analysis_week.dart';
import 'transactions.dart';

class Analysis extends StatelessWidget {
  const Analysis({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Analytics',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: Center(
                  child: Column(children: [
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
                        SelectedButton(
                            label: ' ',
                            onPressed: () {},
                            icon: const Icon(Icons.tune)),
                      ],
                    ),
                    const Padding(padding: EdgeInsets.all(10)),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Your expenses',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(10)),
                    Container(
                      width: screenWidth * 0.9,
                      height: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(0),
                        color: Colors.white,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child:CustomBarChart(),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(8)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.green,
                            foregroundColor: Colors.white,
                          ),
                          child: const Align(
                            alignment: Alignment.center,
                            child: Text('Item '),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 163, 71, 202),
                            foregroundColor: Colors.white,
                          ),
                          child: const Align(
                            alignment: Alignment.center,
                            child: Text('Ensurence '),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.green,
                            foregroundColor: Colors.white,
                          ),
                          child: const Align(
                            alignment: Alignment.center,
                            child: Text('Ads '),
                          ),
                        )
                      ],
                    ),
                    const Padding(padding: EdgeInsets.all(10)),
                    Column(children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '10 May Fri',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.all(10)),
                      Column(
                        children: [
                          const CustomRow(
                            title: 'Client',
                            subtitle: 'Order',
                            value: '5300 DZD',
                          ),
                          const SizedBox(height: 10),
                          const CustomRow(
                            title: 'Amazon',
                            subtitle: 'Purchase',
                            value: '77540 DZD',
                          ),
                          const SizedBox(height: 10),
                          const CustomRow(
                            title: 'Client',
                            subtitle: 'order',
                            value: '19000 DZD',
                          ),
                          SizedBox(
                            width: 120,
                            height: 40,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.darkGreen,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Export pdf'),
                            ),
                          ),
                        ],
                      ),
                      const Padding(padding: EdgeInsets.all(10)),
                      BottomNavigationBar(
                        type: BottomNavigationBarType.fixed,
                        currentIndex: 0,
                        onTap: (index) {},
                        items: <BottomNavigationBarItem>[
                          BottomNavigationBarItem(
                            icon: SizedBox(
                              height: 20,
                              width: 20,
                              child: Image.asset(
                                  'assets/images/analysis_filled.png'),
                            ),
                            label: 'Analysis',
                          ),
                          BottomNavigationBarItem(
                            icon: SizedBox(
                              height: 20,
                              width: 20,
                              child:
                                  Image.asset('assets/images/monitoring.png'),
                            ),
                            label: 'inventory',
                          ),
                          BottomNavigationBarItem(
                            icon: SizedBox(
                              height: 20,
                              width: 20,
                              child: Image.asset('assets/images/star.png'),
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
                    ])
                  ]),
                ))));
  }
}
