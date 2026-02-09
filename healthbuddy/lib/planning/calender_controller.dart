import 'package:flutter/material.dart';
import 'package:healthbuddy/planning/calender_service.dart';

class CalenderController extends ChangeNotifier {
  List<Taskzuprovider> tasks = [];
  calenderService service = calenderService() ;
  DateTime currentMonth = DateTime.now();
 int  daysInMonth =DateUtils.getDaysInMonth(DateTime.now().year, DateTime.now().month);

  void addTask(Taskzuprovider task) async{
    //String formattedDated ="${task.date.year}-${task.date.month.toString().padLeft(2, '0')}-${task.date.day.toString().padLeft(2, '0')}";
    tasks.add(Taskzuprovider(title: task.title, date: DateTime(task.date.year, task.date.month, task.date.day)));
    await service.AddTask(Taskzuprovider(title: task.title, date: task.date));
    notifyListeners();
  }

  /// ⭐ NEW — check if a day already has tasks
  bool hasTask(DateTime date) {
    return tasks.any((t) =>
        t.date.year == date.year &&
        t.date.month == date.month &&
        t.date.day == date.day);
  }

  String getDate(Taskzuprovider task) {
    String formattedDated ="${task.date.year}-${task.date.month.toString().padLeft(2, '0')}-${task.date.day.toString().padLeft(2, '0')}";
    return formattedDated ;
  }

  

  void nextMonth() {
      currentMonth = DateTime(
        currentMonth.year,
        currentMonth.month + 1,
      );
      daysInMonth =
        DateUtils.getDaysInMonth(currentMonth.year, currentMonth.month );
      notifyListeners();
  }

  void previousMonth() {
      currentMonth = DateTime(
        currentMonth.year,
        currentMonth.month - 1,
      );
      daysInMonth =
        DateUtils.getDaysInMonth(currentMonth.year, currentMonth.month );
      notifyListeners();
  }

  CalenderController () {
    _init() ;
    
  }

  void _init() async {
    List<dynamic> dynamicList = await service.getTasks() ;
    for (var item in dynamicList) {
      tasks.add(Taskzuprovider(title: item['event'], date: DateTime.parse(item['date']),));
    }
    print(tasks);
    notifyListeners();
  }
}

class Taskzuprovider {
  final String title;
  final DateTime date;

  Taskzuprovider({required this.title, required this.date});
}