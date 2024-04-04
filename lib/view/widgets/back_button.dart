import 'package:flutter/material.dart';
import 'package:parking_kori/view/styles.dart';

Widget BackOption(BuildContext context, action){
  return InkWell(
    onTap: action,
    child: Container(
      margin: EdgeInsets.symmetric(vertical: get_screenWidth(context)*0.01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(Icons.arrow_back_ios_new_outlined, color: myred,
          size: get_screenWidth(context) * 0.05,
          ),
          Text("Back", style: normalTextStyle(context, myBlack),)
        ],
      ),
    ),
  );
}