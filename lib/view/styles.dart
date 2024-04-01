import 'package:flutter/material.dart';

double get_scale_factor(BuildContext context){
  double screenWidth = MediaQuery.of(context).size.width;
  return screenWidth / 375.0;
}

double get_screenWidth(BuildContext context){
  return MediaQuery.of(context).size.width;
}

// Color myred = Color(0xFF1AB000);
Color myred = Color(0xFFD20062);
Color mypinkRed = Color(0xFFD6589F);
Color mylightblue = Color(0xFFC4E4FF);
Color myWhite = Color(0xFFFAFAFA);
Color myBlack = Color(0xff000000);

TextStyle normalTextStyle (BuildContext context, Color color) {
  return TextStyle(
    color: color,
    fontSize: get_screenWidth(context)*0.04,
    fontFamily: 'Myfont',
    // fontWeight: FontWeight.bold
  );
}

TextStyle boldTextStyle (BuildContext context, Color color) {
  return TextStyle(
      color: color,
      fontSize: get_screenWidth(context)*0.04,
      fontWeight: FontWeight.bold,
    fontFamily: 'Myfont',
  );
}

TextStyle nameTitleStyle (BuildContext context, Color color) {
  return TextStyle(
      color: color,
      fontFamily: 'Myfont',
      fontSize: 24*get_scale_factor(context),
      fontWeight: FontWeight.bold
  );
}

TextStyle hintTextStyle (BuildContext context, Color color) {
  return TextStyle(
      color: color,
      fontFamily: 'Myfont',
      fontSize: get_screenWidth(context)*0.03,
      fontWeight: FontWeight.bold
  );
}
