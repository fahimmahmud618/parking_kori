import 'package:flutter/material.dart';
import 'package:parking_kori/view/styles.dart';

Widget AppBarWidget(BuildContext context){
  return Container(
    padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
    color: myred,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Parking Kori", style: nameTitleStyle(context, myWhite),),
        Icon(Icons.logout, color: myWhite,),
      ],
    ),
  );
}