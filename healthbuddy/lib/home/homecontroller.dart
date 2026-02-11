import 'package:flutter/material.dart';
import 'package:healthbuddy/home/homescreen.dart';
import 'package:healthbuddy/home/homeservice.dart';
import 'package:healthbuddy/model/user.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Homecontroller extends ChangeNotifier {
  late Stream<StepCount> _stepCountStream;
  HomeService service = HomeService();
  final PageController pageController = PageController();
  int steps = 0;
  int _baseline = 0;
  bool isLoading = true ;
  String _lastDate = "";
  var _currentuser ;
  double km = 0.0;
  double kcal = 0.0 ;
  userModel useraktif =  userModel();

  List<DailyData> fitnessData = [];
  List<DailyData> thisweek = [] ;

int totalSteps = 0;
  double totalCalories = 0.0;

  int todaySteps = 0;
  double todayCalories = 0.0;

  double todayKM = 0.0;

  Homecontroller() {
    _init();
  }

  void _init() async {
  _initPedometer();
  //scheduleDailyUpload();
  final prefs = await SharedPreferences.getInstance();
  String? uid = prefs.getString('uid') ;
  _currentuser = await service.getUser(); 
  final data = _currentuser.data() as Map<String, dynamic>;
  useraktif = userModel.fromJson(data) ;
  useraktif.userid = uid ;
  loadSteps();
  isLoading = false ;
  notifyListeners(); 
  await service.uploadDailySteps(DateTime.now() ,steps,kcal,km);
}

 /*Future<void> scheduleDailyUpload() async{
  final now = DateTime.now();
  final tomorrow = DateTime(now.year, now.month, now.day + 1);
  final durationUntilMidnight = tomorrow.difference(now);

  Future.delayed(durationUntilMidnight, () async {
    await service.uploadDailySteps(now ,steps,kcal,km);
    sendNotificationMotivation() ;
    sendNotificationWasseraufnahme();
    // Timer erneut planen für nächsten Tag
    scheduleDailyUpload();
  });
}*/

Future<void> sendNotificationSchritte() async {
  final now = DateTime.now();
  await service.uploadNotificationSchritte(now) ;
}

Future<void> sendNotificationKalorien() async {
  final now = DateTime.now();
  await service.uploadNotificationKalorien(now) ;
}

/*Future<void> sendNotificationMotivation() async {
  final now = DateTime.now();
  await service.uploadNotificationMotivation(now) ;
}

Future<void> sendNotificationWasseraufnahme() async {
  final now = DateTime.now();
  await service.uploadNotificationWasser(now) ;
}*/





  // 🔹 Initialize permissions and load saved state
  Future<void> _initPedometer() async {
    var activity = await Permission.activityRecognition.request();
    var sensors = await Permission.sensors.request();

    if (activity.isGranted && sensors.isGranted) {
      await _loadBaseline();
      _stepCountStream = Pedometer.stepCountStream;
      _stepCountStream.listen(onStepCount).onError(onStepCountError);
    } else {
      print("❌ Permissions denied");
    }
  }

  // 🔹 Load baseline and reset if it's a new day
  Future<void> _loadBaseline() async {
    final prefs = await SharedPreferences.getInstance();
    final savedDate = prefs.getString('lastDate') ?? "";
    final savedBaseline = prefs.getInt('baseline') ?? 0;
    final today = DateTime.now().toIso8601String().substring(0, 10);

    if (savedDate != today) {
      _baseline = 0;
      steps = 0;
      await prefs.setString('lastDate', today);
      await prefs.setInt('baseline', 0);
    } else {
      _baseline = savedBaseline;
      _lastDate = savedDate;
    }
    notifyListeners();
  }

  // 🔹 Handle new step events
  void onStepCount(StepCount event) async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().substring(0, 10);

    if (_lastDate != today) {
      // New day → reset baseline
      _baseline = event.steps;
      _lastDate = today;
      steps = 0;
      km = 0;
      kcal = 0;
      await prefs.setString('lastDate', today);
      await prefs.setInt('baseline', _baseline);
    } else if (_baseline == 0 || event.steps < _baseline) {
      // Device reboot or app restart
      _baseline = event.steps;
      await prefs.setInt('baseline', _baseline);
    }

    // Calculate today's steps
    steps = event.steps - _baseline;
    if (steps < 0) steps = 0;
    km = steps * 0.0008;
    kcal = steps * 0.045;

    // Save for background upload
    await prefs.setInt("todaySteps", steps);
    await prefs.setDouble("todayKcal", kcal);
    await prefs.setDouble("todayKm", km);
    await prefs.setInt("lastDeviceSteps", event.steps);
    if (steps >= 10000) {
      sendNotificationSchritte();
    }
    if (kcal >= 500.0) {
      sendNotificationKalorien();
    }

    notifyListeners();
  }

  void onStepCountError(error) {
    print("⚠️ Step count error: $error");
  }

  String getDayName(DateTime date) {
  const names = ["Mo", "Tu", "Wed", "Thu", "Fr", "Sa", "Su"];
  return names[date.weekday - 1];
}

DateTime parseDate(String dateString) {
  final parts = dateString.split('-'); 
  final day = int.parse(parts[0]);
  final month = int.parse(parts[1]);
  final year = int.parse(parts[2]);
  return DateTime(year, month, day);
}


  List<DailyData> thisWeekData() {
      final now = DateTime.now();
      final sevenDaysAgo = now.subtract(const Duration(days: 7));

      return fitnessData.where((d) {
        final dayDate = parseDate(d.day); 
        return dayDate.isAfter(sevenDaysAgo);
      }).toList();
    }


  void loadSteps() async {
  var steps = await service.getSteps();
  for (var s in steps) {
      fitnessData.add(DailyData(s['date'],s['steps'],double.parse(s['kalorien'].toString()),double.parse(s['km'].toString())));
    }

      todaySteps = fitnessData.last.steps;
      todayCalories = fitnessData.last.calories;

      thisweek = thisWeekData() ;
      totalSteps = thisweek.fold(0, (sum, d) => sum + d.steps);
      totalCalories = thisweek.fold(0.0, (sum, d) => sum + d.calories);
      todayKM = thisweek.fold(0.0, (sum, d) => sum + d.km);
      notifyListeners();
}




}