import 'package:flutter/material.dart';
import 'package:cache_manager/cache_manager.dart';
import 'package:parking_kori/view/pages/flash_page.dart';
import 'package:parking_kori/view/styles.dart';

myAlertDialog(String title, String description, BuildContext context,) {
  // Create button
  Widget okButton = TextButton(
    child: Text("OK", style: normalTextStyle(context, myWhite),),
    onPressed: () {
      Navigator.of(context).pop();
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
myConfirmationDialog(String title, String description, BuildContext context,) {
  // Create button
  Widget yesButton = TextButton(
    child: Text("Yes", style: normalTextStyle(context, myWhite),),
    onPressed: () {
      print("log outtted");
      Navigator.of(context).pop();
      DeleteCache.deleteKey("cache", Navigator.push(context, MaterialPageRoute(builder: (context)=>FlashPage())));
    },
  );

  Widget noButton = TextButton(
    child: Text("No", style: normalTextStyle(context, myWhite),),
    onPressed: () {
      Navigator.of(context).pop();
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
      yesButton,
      noButton
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