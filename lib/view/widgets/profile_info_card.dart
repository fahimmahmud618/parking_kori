import 'package:flutter/material.dart';
import 'package:parking_kori/view/styles.dart';

Widget ProfileInfoCard(BuildContext context, String title, String data) {
  return Container(
    alignment: Alignment.center,
    constraints: BoxConstraints(
    minWidth: get_screenWidth(context)*0.35,
    minHeight: 60,
   
  ),
    width: get_screenWidth(context) * 0.3,
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: myred,
        borderRadius: BorderRadius.circular(8),
      ),
    child: Column(children: [
      Text(title, style: normalTextStyle(context, myWhite),),
      SizedBox(height: 5,),
      Text(data, style: nameTitleStyle(context, myWhite),)
    ],),
  );
}
