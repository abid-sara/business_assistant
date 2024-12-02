import 'package:flutter/material.dart';
import 'package:business_assistant/main.dart';
import 'package:business_assistant/style/colors.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Row(
            children: [
             Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 70,
              height: 70,   
              child: const DrawerHeader(
                decoration: BoxDecoration(
                  color: AppColors.darkGreen,
                  shape: BoxShape.circle, 
                ),
                child: SizedBox.shrink(), 
              ),
                
              ),
            ),
             Align(
                  alignment: Alignment.centerLeft,
                child: Text(
                  'Sara ABID',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Icon(Icons.keyboard_arrow_right),

                )
               
            ]
          ),
          Container(
            height: 1,
            color: Colors.grey,
            
          ),
        
         
          ListTile(
            leading:  SizedBox(
               width: 24,
              height: 23,
            child: Image.asset('assets/images/home.png' , fit : BoxFit.cover) ),
            title: const Text('Dashboard',style: TextStyle(fontSize: 20)),
            onTap: () {

              
            },
          

            ),
             
          Padding(padding: EdgeInsets.all(16)),
         
          ListTile(
            leading:  SizedBox(
               width: 24,
              height: 23,
            child: Image.asset('assets/images/box.png' , fit : BoxFit.cover) ),
            title: const Text('Orders',style: TextStyle(fontSize: 20)),
            onTap: () {
              
              
            },
          ),

          Padding(padding: EdgeInsets.all(16)),

          ListTile(
            leading:  SizedBox(
               width: 24,
              height: 23,
            child: Image.asset('assets/images/to-do-list.png' , fit : BoxFit.cover) ),
            title: const Text('To do',style: TextStyle(fontSize: 20)),
            onTap: () {
              
            },
          ),

          Padding(padding: EdgeInsets.all(16)),

          ListTile(
            leading:  SizedBox(
               width: 24,
              height: 23,
            child: Image.asset('assets/images/Customers.png' , fit : BoxFit.cover) ),
            title: const Text('Customers',style: TextStyle(fontSize: 20)),
            onTap: () {
              
            },
          ),

          Padding(padding: EdgeInsets.all(16)),

          ListTile(
            leading:  SizedBox(
               width: 24,
              height: 23,
            child: Image.asset('assets/images/analysis.png' , fit : BoxFit.cover) ),
            title: const Text('Analysis',style: TextStyle(fontSize: 20),),
            onTap: () {
              
             
            },
          ),

          Padding(padding: EdgeInsets.all(16)),

          ListTile(
           leading:  SizedBox(
               width: 24,
              height: 23,
            child: Image.asset('assets/images/monitoring.png' , fit : BoxFit.cover) ),
            title: const Text('Inventory',style: TextStyle(fontSize: 20)),
            onTap: () {
              
             
            },
          ),

          Padding(padding: EdgeInsets.all(16)),

          ListTile(
            leading:  SizedBox(
               width: 24,
              height: 23,
            child: Image.asset('assets/images/wishlist.png' , fit : BoxFit.cover) ),
            title: const Text('Goals',style: TextStyle(fontSize: 20)),
            onTap: () {
              
              
            },
          ),

          Padding(padding: EdgeInsets.all(20)),

          ListTile(
            leading:  SizedBox(
               width: 24,
              height: 23,
            child: Image.asset('assets/images/settings.png' , fit : BoxFit.cover) ),
            title: const Text('Settings',style: TextStyle(fontSize: 20)),
            onTap: () {
              
              
            },
          ),
          Padding(padding: EdgeInsets.all(16)),

          ListTile(
            leading: 
            Icon(Icons.exit_to_app , size: 24, color: Colors.red),
            title: const Text('Logout account',style: TextStyle(fontSize: 20)),
            onTap: () {
              
              
            },
          ),
          
        ],
      ),
    );
  }
}
