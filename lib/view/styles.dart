import 'package:flutter/material.dart';

double get_scale_factor(BuildContext context){
  double screenWidth = MediaQuery.of(context).size.width;
  return screenWidth / 375.0;
}

double get_screenWidth(BuildContext context){
  return MediaQuery.of(context).size.width;
}

Color red = Color(0xFFD20062);
Color pinkRed = Color(0xFFD6589F);
Color lightblue = Color(0xFFC4E4FF);
Color myWhite = Color(0xFFFAFAFA);
Color lighhtblue = Color(0xff000000);
