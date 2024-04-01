import 'package:flutter/material.dart';
import 'package:parking_kori/view/styles.dart';

Widget PageTitle(BuildContext context, String title){
  return Container(
    // margin: EdgeInsets.fromLTRB(10, 10, 10, 20),
    margin: EdgeInsets.only(bottom: 40),
    padding: EdgeInsets.fromLTRB(10, 1, 10, 1),
    // padding: EdgeInsets.all(20),
    decoration: BoxDecoration(
      // gradient: LinearGradient(
      //   begin: Alignment.centerLeft,
      //   end: Alignment.centerRight,
      //   // colors: [Colors.blue, Colors.purple],
      //   colors: [myred.withOpacity(0.8), myWhite],
      // ),
      border: Border(
        bottom: BorderSide(
          color: Colors.black,
          width: 2.0,
        ),
      ),
    ),
    alignment: AlignmentDirectional.centerStart,
    child: Text(
      title,
      style: nameTitleStyle(context, myred)
    ),
  );
}