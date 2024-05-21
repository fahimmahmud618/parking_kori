// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:parking_kori/view/styles.dart';

Widget ActionButton(BuildContext context, String text, action) {
  return Container(
    width: get_screenWidth(context),
    constraints: BoxConstraints(minWidth: get_screenWidth(context) * 0.3),
    margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
    padding: EdgeInsets.all(2),
    decoration: BoxDecoration(
        color: myred,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.5), // Shadow color
        spreadRadius: 1, // Spread radius
        blurRadius: 8, // Blur radius
        offset: Offset(0, 3), // Offset in x and y directions
      ),
    ],),
    child: TextButton(
      onPressed: action,
      child: Text(
        text,
        style: boldTextStyle(context, myWhite),
      ),
    ),
  );
}

Widget ActionButton2(BuildContext context, String text, action) {
  return Container(
    width: get_screenWidth(context),
    constraints: BoxConstraints(minWidth: get_screenWidth(context) * 0.3),
    margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
    padding: EdgeInsets.fromLTRB(2, 10, 2, 10),
    decoration: BoxDecoration(
        color: myred,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.5), // Shadow color
        spreadRadius: 1, // Spread radius
        blurRadius: 8, // Blur radius
        offset: Offset(0, 3), // Offset in x and y directions
      ),
    ],),
    child: TextButton(
      onPressed: action,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.qr_code, color: myWhite,),
          SizedBox(width: get_screenWidth(context)*0.01,),
          Text(
            text,
            style: boldTextStyle(context, myWhite),
          ),
        ],
      ),
    ),
  );
}

Widget ActionButton3(BuildContext context, String text, action,double size) {
  return Container(
    width: get_screenWidth(context)*size,
    constraints: BoxConstraints(minWidth: get_screenWidth(context) * 0.3),
    margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
    padding: EdgeInsets.all(2),
    decoration: BoxDecoration(
        color: myred,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.5), // Shadow color
        spreadRadius: 1, // Spread radius
        blurRadius: 8, // Blur radius
        offset: Offset(0, 3), // Offset in x and y directions
      ),
    ],),
    child: TextButton(
      onPressed: action,
      child: Text(
        text,
        style: boldTextStyle(context, myWhite),
      ),
    ),
  );
}

Widget ActionButton4(BuildContext context, String text, Function()? action, double size, bool isDisable) {
  return Container(
    width: get_screenWidth(context) * size,
    // padding: EdgeInsets.all(1),
    decoration: BoxDecoration(
      color: isDisable ? myred.withOpacity(0.7) : myred, // Adjust opacity based on isDisable
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 1,
          blurRadius: 8,
          offset: Offset(0, 4), // Offset in x and y directions
        ),
      ],
    ),
    child: action != null ? TextButton(
      onPressed: isDisable ? null : action, // Disable onPressed based on isDisable
      child: Text(
        text,
        style: boldTextStyle(context, myWhite),
      ),
    ) : Text(
        text,
        style: boldTextStyle(context, myWhite),
      ),
  );
}

