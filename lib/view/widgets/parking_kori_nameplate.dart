import 'package:flutter/material.dart';
import 'package:parking_kori/view/image_file.dart';
import 'package:parking_kori/view/styles.dart';

Widget ParkingKoriNameplate(BuildContext context){
  return Container(
      child: Row(
        children: [
          Image.asset(carLogo,
          width: get_screenWidth(context)*0.05,
          ),
          Text("Parking Kori",style: TextStyle(
            fontSize: get_screenWidth(context)*0.05,
            fontFamily: 'Myfont',
          ),)
        ],
      ),
  );
}