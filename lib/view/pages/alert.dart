import 'package:flutter/material.dart';
import 'package:parking_kori/view/pages/main_page.dart';
import 'package:parking_kori/view/styles.dart';

myAlert(String title, String description, BuildContext context,) {
  // Create button
  Widget okButton = TextButton(
    child: Text("OK", style: normalTextStyle(context, myWhite),),
    onPressed: () {
      Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainPage()),
    );
    },
  );

  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    backgroundColor: myred,
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Nameplate(context),
        Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Text(title, style: nameTitleStyle(context, myWhite)),
        ),
      ],
    ),
    content: Text(description, style: normalTextStyle(context,myWhite ),),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

 