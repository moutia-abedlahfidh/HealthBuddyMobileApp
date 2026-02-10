

import 'package:flutter/material.dart';
import 'package:healthbuddy/chatbot/chatbot_screen.dart';
import 'package:healthbuddy/home/homescreen.dart';
import 'package:healthbuddy/body.dart';
import 'package:healthbuddy/notifications/notificationscreen.dart';
import 'package:healthbuddy/planning/calendar_page.dart';
import 'package:healthbuddy/privatheit/privatheitscreen.dart';
import 'package:healthbuddy/settings/Edit/editscreen.dart';
import 'package:provider/provider.dart';
import 'settings_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key}) ;
  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create : (_)=> SettingsController(),
      child :Consumer<SettingsController>(
        builder: (context,controller,_) 
      {
        return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        
        child: SingleChildScrollView(
          child: Padding(padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30,),
              const Text(
                  "Settings ",
                  textAlign:TextAlign.center,
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 25,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 30,),
                ItemSetting(icon: const Icon(Icons.person),name: "Account",description: "Change parameters", onTap: () {
                  Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DataEditScreen()),
        );
                },),
                ItemSetting(icon: const Icon(Icons.notifications),name: "Benachrichtung",description: "Neuigkeiten sehen...",onTap: () {
                  Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NotificationScreen()),
        );
                },),
                ItemSetting(icon: const Icon(Icons.privacy_tip),name: "Privatheit",description: "mehr Lesen",onTap: () {
                  Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PrivacyPolicyPage()),
        );
                }),
                ItemSetting(icon: const Icon(Icons.logout),name: "Ausloggen",description: "Bis nachste mal",onTap: () {
                  controller.ausloggen(context) ;
                }),
            ],
          ),),
        ),
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.black,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey.shade400,
          type: BottomNavigationBarType.fixed,
          currentIndex: 3,
          onTap: (index) {
            if (index==0) {
              Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  Homescreen()),
        );
            }else if (index == 2) {
              Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  ChatPage()),
        );
              }else if (index==1) {
              Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  const CalendarPage()),
        );
            }else  {

            }
          },
          showUnselectedLabels: false,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: 'Plannung'),
            BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'ChatBot'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Einstellungen'),
          ],
        ),
      ),
    
    );
      }));
  }


}


// Widget für die einzelnen Einstellungs-Elemente
class ItemSetting extends StatelessWidget{
  final Icon icon ;
  final String name ;
  final String description ;
  final VoidCallback onTap; // Neu: Callback für die Aktion

  const ItemSetting({
    super.key, 
    required this.icon,
    required this.name,
    required this.description,
    required this.onTap,
  }) ;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ]
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 15),
          child: Row(
            children: [
              Icon(icon.icon, color: icon.color ?? Colors.indigo.shade400),
              const SizedBox(width: 20,),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    textAlign : TextAlign.left,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: const TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 14,
                    ),
                  )
                ],
              ),
              const Spacer(),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}




class ItemSetting1 extends StatelessWidget{
  final Icon icon ;
  final String name ;
  final String description ;
  const ItemSetting1({super.key, required this.icon,required this.name,required this.description}) ;

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsController>(builder: (context, controller, child) {
      return  GestureDetector(
      onTap :() {
        if (name=='Ausloggen') {
          controller.ausloggen(context);
          Navigator.push(context,MaterialPageRoute(builder: (context) => const Body()));
        }
      },
      child: Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10)
      ),
      child: Padding(padding: const EdgeInsets.symmetric(vertical: 11,horizontal: 15),
      child: Row(
        children: [
          icon,
          const SizedBox(width: 30,),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(name,textAlign : TextAlign.left,style: const TextStyle(
                color: Colors.black,
                fontSize: 21,
              ),),
              ),
              Text(description,
              style: const TextStyle(
                //fontWeight:FontWeight.w400,
                color: Colors.blueGrey
              ),)
            ],
          )
        ],
      ),),
    ),
    );
    },);}

}