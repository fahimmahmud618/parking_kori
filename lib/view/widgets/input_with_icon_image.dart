import 'package:flutter/material.dart';
import 'package:parking_kori/view/styles.dart';

Widget InputWIthIconImage(
    BuildContext context,
    String icon,
    TextEditingController textEditingController,
    String title,
    String hinttext,
    bool isHide) {
  return Container(
    child: Column(
      children: [
        Row(
          children: [
            Image.asset(
              icon,
              height: get_screenWidth(context)*0.04,
              width: get_screenWidth(context)*0.04,
            ),
            SizedBox(width: 5,),
            Text(
              title,
              style: TextStyle(
                  color: myBlack,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Myfont',
                  fontSize: get_screenWidth(context)*0.04),
            ),
          ],
        ),


        Container(
          padding: EdgeInsets.symmetric(horizontal: 5),
          margin: EdgeInsets.symmetric(vertical: 2),
          decoration: BoxDecoration(
              // borderRadius: BorderRadius.circular(5),
              border: Border(
                bottom: BorderSide(
                  color: Colors.black.withOpacity(0.7), // Specify your desired color
                  width: 1, // Specify your desired width
                ),
              ),
          ),
          child: TextField(
            obscureText: isHide,
            controller: textEditingController,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hinttext,
              hintStyle: TextStyle(
                color: myBlack.withOpacity(0.5),
                fontSize: get_screenWidth(context)*0.03,
                fontFamily: 'Myfont',
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
