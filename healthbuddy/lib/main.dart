import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:healthbuddy/home/homescreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'body.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  );

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userId = prefs.getString('uid');


  runApp(MainApp(isLoggedIn: userId!=null,));
}

class MainApp extends StatelessWidget {
  final bool isLoggedIn;
  const MainApp({super.key,required this.isLoggedIn});

  @override
  Widget build(BuildContext context){
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isLoggedIn ? Homescreen() : const Body(),
    );
  }
}
