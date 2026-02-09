import 'package:flutter/material.dart';
import 'package:healthbuddy/planning/calender_controller.dart';
import 'package:provider/provider.dart';

class TaskFormPage extends StatefulWidget {
  final DateTime selectedDate;

  const TaskFormPage({super.key, required this.selectedDate});

  @override
  State<TaskFormPage> createState() => _TaskFormPageState();
}

class _TaskFormPageState extends State<TaskFormPage> {
  final title = TextEditingController();
  final description = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("New Task")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text("Date: ${widget.selectedDate.toLocal()}"),

            TextField(
              controller: title,
              decoration: const InputDecoration(labelText: "Title"),
            ),

            TextField(
              controller: description,
              decoration: const InputDecoration(labelText: "Description"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                context.read<CalenderController>().addTask(
                      Taskzuprovider(
                        title: title.text,
                        date: widget.selectedDate,
                      ),
                    );

                Navigator.pop(context);
              },
              child: const Text("Save Task"),
            )
          ],
        ),
      ),
    );
  }
}

class Task1 {
  final String title;
  final String description;
  final DateTime date;

  Task1({
    required this.title,
    required this.description,
    required this.date,
  });
}
