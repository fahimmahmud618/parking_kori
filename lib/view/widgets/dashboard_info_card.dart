import 'package:flutter/material.dart';
import 'package:parking_kori/view/styles.dart';

Widget DashboardInfoCard(BuildContext context, String title, String data){
  return Container(
    padding: EdgeInsets.all(get_screenWidth(context)*0.02),
    margin: EdgeInsets.only(bottom: get_screenWidth(context)*0.02),
    decoration: BoxDecoration(
      color: myred,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      children: [
        Expanded(flex:2, child: Text("$title ", style: boldTextStyle(context, myWhite),)),
        Expanded(flex:1, child: Text(": $data", style: normalTextStyle(context, myWhite.withOpacity(0.8)),)),
      ],
    ),
  );
}