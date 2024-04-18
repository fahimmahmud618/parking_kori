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

