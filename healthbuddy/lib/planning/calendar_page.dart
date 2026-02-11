import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:healthbuddy/chatbot/chatbot_screen.dart';
import 'package:healthbuddy/home/homescreen.dart';
import 'package:healthbuddy/planning/calender_controller.dart';
import 'package:healthbuddy/settings/settings_screen.dart';
import 'package:provider/provider.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CalenderController(),
      child: Consumer<CalenderController> (builder: (context, controller, child) {
        return  Scaffold(
      appBar: AppBar(title: const Text("Planning Calendar")),
      body: SingleChildScrollView(
          child: Column(
        children: [
          /// ===== Month Header =====
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: controller.previousMonth,
                  icon: const Icon(Icons.chevron_left),
                ),

                Text(
                  "${controller.currentMonth.month}/${controller.currentMonth.year}",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),

                IconButton(
                  onPressed: controller.nextMonth,
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
          ),

          /// ===== Calendar Grid =====
          GridView.builder(
            shrinkWrap: true,
              padding: const EdgeInsets.all(12),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 1,
              ),
              itemCount: controller.daysInMonth,
              itemBuilder: (_, index) {
                final date = DateTime(
                  controller.currentMonth.year,
                  controller.currentMonth.month,
                  index + 1,
                );

                final provider = context.watch<CalenderController>();
final occupied = provider.hasTask(date);

return GestureDetector(
  onTap: () => _showTaskPopup(context, date),
  child: Card(
    elevation: occupied ? 6 : 2,
    color: occupied
        ? Colors.green.shade300
        : Colors.white,
    child: Center(
      child: Text(
        "${index + 1}",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: occupied ? Colors.white : Colors.black,
        ),
      ),
    ),
  ),
);
              },
            ),
          
    /// ===== Planned Tasks Column =====
    Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              "Planned Tasks",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            
            SizedBox(height:300,child: ListView.builder(itemBuilder: (_, index) {
              return TaskTile((controller.tasks[index]).title,controller.getDate(controller.tasks[index])) ;
            },
            itemCount: controller.tasks.length,))
          ],
        ),
      ),
          /// ===== Calendar Grid =====
        ],
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
          currentIndex: 1,
          onTap: (index) {
            if (index==3) {
              Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  const SettingsScreen()),
        );
            }else if (index == 2) {
              Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  const ChatPage()),
        );
              }else if (index==0) {
              Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Homescreen()),
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
}


void _showTaskPopup(BuildContext context, DateTime date) {
  final controller = TextEditingController();

  showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text("New Task — ${date.day}/${date.month}"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: "Task name",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text("Save"),
            onPressed: () {
              if (controller.text.isNotEmpty) {
                context.read<CalenderController>().addTask(
                      Taskzuprovider(title: controller.text, date: date),
                    );
              }
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}

class TaskTile extends StatelessWidget {
  final String title;
  final String date;

  const TaskTile(this.title, this.date, {super.key});

  @override
  Widget build(BuildContext context) {

    final controller = context.read<CalenderController>();

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        leading: const Icon(Icons.check_circle_outline),
        title: Text(title),
        subtitle: Text(date),
        trailing: GestureDetector(
          onTap: () {
            controller.deleteTask(date, title);
          },
          child: const Icon(Icons.delete, color: Colors.red),
        ),
      ),
    );
  }
}