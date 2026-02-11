

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthbuddy/planning/calender_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class calenderService {
  Future<List<dynamic>> getTasks() async {
    try{
      final prefs = await SharedPreferences.getInstance();
      String? uid = prefs.getString('uid');
      final response = await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .get() ;

      return response['tasks'] ?? [] ;
    }catch(e) {
      print("Something went wrong.$e");
      return [] ;
    }
  }

  Future<void> AddTask(Taskzuprovider event) async {
    try{
      String formattedDated ="${event.date.year}-${event.date.month.toString().padLeft(2, '0')}-${event.date.day.toString().padLeft(2, '0')}";
      final prefs = await SharedPreferences.getInstance();
      String? uid = prefs.getString('uid');
      final response = await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .update({
        'tasks': FieldValue.arrayUnion([
        {
          'date': formattedDated,
          'event': event.title,
        }])
      });
      print("Event added successfully");

    }catch(e) {
      print("Something went wrong.$e");
    }
  }

  Future<List<Taskzuprovider>> deleteTask(String date,String event) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? uid = prefs.getString('uid');
       final response = await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .get() ;

      List<dynamic> tasks = response['tasks'] ?? [];
      List<Taskzuprovider> tasksProvider = [] ;
      for (var item in tasks) {
        tasksProvider.add(Taskzuprovider(title: item['event'] ?? "", date: DateTime.parse(item['date'] ?? "1999-11-11"))) ;
      }

      tasksProvider.removeWhere((task) =>
        task.date == date &&
        task.title == event);

      tasks.removeWhere((task) =>
        task['date'] == date &&
        task['event'] == event);

      await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .update({
        'tasks' : tasks
      }) ;
      return tasksProvider ;
    }catch(e) {
      print("Something went wrong.$e");
      return [];
    }
  }
}