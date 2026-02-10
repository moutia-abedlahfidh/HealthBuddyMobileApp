import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:healthbuddy/home/homescreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'body.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userId = prefs.getString('uid');

  runApp(MainApp(isLoggedIn: userId != null));
}

class MainApp extends StatelessWidget {
  final bool isLoggedIn;
  const MainApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: InternetChecker(
        isLoggedIn: isLoggedIn,
      ),
    );
  }
}

// This replaces ConnectivityWrapper
class InternetChecker extends StatefulWidget {
  final bool isLoggedIn;
  const InternetChecker({super.key, required this.isLoggedIn});

  @override
  _InternetCheckerState createState() => _InternetCheckerState();
}

class _InternetCheckerState extends State<InternetChecker> {
  bool _dialogShown = false;

  @override
  void initState() {
    super.initState();
    _startInternetCheckLoop();
  }

  void _startInternetCheckLoop() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 3)); 
      bool connected = await _hasInternet();
      if (!connected && !_dialogShown) {
        _dialogShown = true;
        _showNoInternetDialog();
      } else if (connected) {
        _dialogShown = false;
      }
      return true; // continue loop
    });
  }

  Future<bool> _hasInternet() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  void _showNoInternetDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Es gibt keine Verbingung'),
        content: const Text('Bitte überprüfen Sie Ihre Internet Verbingung'),
        actions: [
          TextButton(
            onPressed: () {
              SystemNavigator.pop();
            },
            child: const Text('Schließen'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.isLoggedIn ? Homescreen() : const Body();
  }
}