

import 'package:flutter/material.dart';
import 'package:healthbuddy/settings/Edit/editservice.dart';

class EditController extends ChangeNotifier {
 EditService service = EditService() ;

 late final nameController = TextEditingController();
  late final emailController = TextEditingController();
  late final weightController = TextEditingController();
  late final heightController = TextEditingController();
  late final ageController = TextEditingController();

  EditController() {
    loadEdit();
  }

  void loadEdit() async{
    var steps = await service.getDetails();
    nameController.text = steps['name'] ;
    emailController.text = steps['email'] ;
    weightController.text = steps['gewicht'].toString() ;
    heightController.text = steps['grose'].toString() ;
    ageController.text = steps['alt'].toString() ;
  }

  void changeParameter(BuildContext context) async {
    Map<String,dynamic> newData = {
      'email' : emailController.text,
      'name' : nameController.text,
      'gewicht' : double.parse(weightController.text),
      'grose' : double.parse(heightController.text),
      'alt' : int.parse(ageController.text)
    };
    await service.changeDetails(newData);
    ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Daten wurden gespeichert!')),
                  );
  }
}