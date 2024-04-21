import 'package:flutter/material.dart';
import 'package:parking_kori/view/styles.dart';

Widget ProfileInfoCard(BuildContext context, String title, String data, int type) {
  return Container(
    alignment: Alignment.center,
    constraints: BoxConstraints(
    minWidth: get_screenWidth(context)*0.35*type,
    minHeight: 60,
   
  ),
    width: get_screenWidth(context) * 0.3*type,
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: myred,
        borderRadius: BorderRadius.circular(8),
      ),
    child: Column(children: [
      Text(title, style: normalTextStyle(context, myWhite),),
      SizedBox(height: 10,),
      Text(data, style: nameTitleStyle(context, myWhite),)
    ],),
  );
}
