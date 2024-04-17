import 'package:flutter/material.dart';

double get_scale_factor(BuildContext context){
  double screenWidth = MediaQuery.of(context).size.width;
  return screenWidth / 375.0;
}

double get_screenWidth(BuildContext context){
  return MediaQuery.of(context).size.width;
}

Color myred = Color(0xFFb01b40);
// Color myred = Color(0xFFe1136e);
// Color myred = Color(0xFFD20062);
Color mypinkRed = Color(0xFFD6589F);
Color mylightblue = Color(0xFFC4E4FF);
Color myWhite = Color(0xFFFAFAFA);
Color myBlack = Color(0xff000000);

TextStyle normalTextStyle (BuildContext context, Color color) {
  return TextStyle(
    color: color,
    fontSize: 15*get_scale_factor(context),
    fontFamily: 'Myfont',
    // fontWeight: FontWeight.bold
  );
}

TextStyle boldTextStyle (BuildContext context, Color color) {
  return TextStyle(
      color: color,
      fontSize: get_screenWidth(context)*0.035,
      fontWeight: FontWeight.bold,
    fontFamily: 'Myfont',
  );
}

TextStyle nameTitleStyle (BuildContext context, Color color) {
  return TextStyle(
      color: color,
      fontFamily: 'Myfont',
      fontSize: 20*get_scale_factor(context),
      fontWeight: FontWeight.bold
  );
}

TextStyle hintTextStyle (BuildContext context, Color color) {
  return TextStyle(
      color: color,
      fontFamily: 'Myfont',
      fontSize: get_screenWidth(context)*0.025,
      fontWeight: FontWeight.bold
  );
}

BoxDecoration selectedBox(BuildContext context){
  return BoxDecoration(
    color: myred,
      border: Border.all(
        color: myBlack,
        width: 1.0,
      )
  );
}
BoxDecoration unselectedBox(BuildContext context){
  return BoxDecoration(
    color: myWhite,
    border: Border.all(
      color: myBlack,
      width: 1.0,
    )
  );
}
