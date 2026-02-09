import 'package:flutter/material.dart';
import 'package:healthbuddy/chatbot/chatbot_controller.dart';
import 'package:healthbuddy/home/homescreen.dart';
import 'package:healthbuddy/planning/calendar_page.dart'; 
import 'package:healthbuddy/settings/settings_screen.dart';
import 'package:provider/provider.dart';


class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChatController(),
      child: Consumer<ChatController>(builder: (context, controller, child) {
        return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Chatbot"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
  width: double.infinity,
  padding: const EdgeInsets.all(16),
  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  decoration: BoxDecoration(
    color: Colors.green.shade100,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 6,
        offset: const Offset(0, 3),
      ),
    ],
  ),
  child: const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.health_and_safety, color: Colors.green, size: 28),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                "Hello! I'm your Health Assistant 💚\n"
                "I can help you with topics like sleep, nutrition, exercise, and stress management.\n"
                "Ask me anything related to your health and wellness!",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
          /// Messages
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.all(12),
              itemCount: controller.messages.length,
              itemBuilder: (_, i) => buildMessage(controller.messages[i]),
            ),
          ),

          Container(
    padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
    
    child: Column(children: [
      SizedBox(height: 65,child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
          children: (controller.category == 1 ? controller.options_questions_Sport : controller.category == 2 ? controller.options_questions_Ernahrung : controller.category == 3 ? controller.options_questions_Schlaf : controller.options).map((topic) {
            return Padding(
              padding: const EdgeInsets.only(right: 4),
              child: GestureDetector(
                onTap: () {
                  if (controller.options_is_opened == false) {
                    controller.changeOptions(topic);
                    controller.options_is_opened = true ;
                  }else {
                    controller.text.text = topic;
                    controller.notifyListeners();
                  }
                  
                  
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.green.shade400,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    topic,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        )),
      Row(
      children: [
        Flexible(
      child: TextField(
        controller: controller.text,
        decoration: const InputDecoration(
          hintText: "Type a message...",
        ),
      ),
    ),

        /// Send Button
        GestureDetector(
          onTap: () {            
            controller.sendMessage();
            controller.text.clear();
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.send,
              color: Colors.white,
            ),
          ),
        ),
      ],
    ),
      ]),
  ),
        ],
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
          currentIndex: 2,
          onTap: (index) {
            if (index==3) {
              Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  const SettingsScreen()),
        );
            }else if (index == 1) {
              Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  const CalendarPage()),
        );
              }else if (index==0) {
              Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  const Homescreen()),
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
      )
    );
      },),
    );
  }

  Widget buildMessage(Message msg) {
    return Align(
      alignment:
          msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: msg.isUser ? Colors.blue : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          msg.text,
          style: TextStyle(
            color: msg.isUser ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}

class Message {
  final String text;
  final bool isUser;

  Message({required this.text, required this.isUser});
}