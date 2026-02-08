

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditService {
  Future getDetails() async{
    try{
      final prefs = await SharedPreferences.getInstance();
      String? uid = prefs.getString('uid') ;
    DocumentSnapshot  instance = await  FirebaseFirestore.instance
    .collection('users')
    .doc(uid)
    .get();
    return instance;
    }on FirebaseAuthException catch (e) {
    return e.message;
    }catch(e) {
      return "Something went wrong.";
    }
  }

  Future changeDetails(Map<String,dynamic> newData) async {
    try{
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('uid') ;
    DocumentReference userDoc = FirebaseFirestore.instance.collection('users').doc(userId);
    await userDoc.update(newData);

    return "User details updated successfully.";
    }catch(e) {
      return "Something went wrong.";
    }
  }
}