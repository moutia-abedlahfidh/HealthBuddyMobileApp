import 'dart:async';
import 'package:flutter/material.dart';
import 'package:healthbuddy/schafseite/schlafservice.dart';

class Sclafcontroller extends ChangeNotifier {

  bool aufzeichnung = false;
  bool isLoading = true;

  Timer? _timer;
  Duration _duration = Duration.zero;

  schlafService service = schlafService();
  List<dynamic> schlafaufzeichnung = [];

  // 👇 UI kann Dauer lesen
  Duration get laufzeit => _duration;

  Sclafcontroller() {
    init();
  }

  void init() async {
    var response = await service.getInfo();
    schlafaufzeichnung = response['schlafzeit'];
    isLoading = false;
    notifyListeners();
  }

  // ===============================
  // START
  // ===============================

  void counterstarten() {
    if (_timer != null) return;

    _duration = Duration.zero;
    aufzeichnung = true;
    notifyListeners();

    // ⭐ Jede Sekunde aktualisieren
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _duration += const Duration(seconds: 1);
      notifyListeners(); // <<< WICHTIG
    });
  }

  // ===============================
  // STOP
  // ===============================

  void counterstoppen() {
    aufzeichnung = false;

    final now = DateTime.now();

    _timer?.cancel();
    _timer = null;

    service.sendInfo(now, _duration);

    notifyListeners();
  }
}