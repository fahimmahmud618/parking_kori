import 'package:flutter/material.dart';
import 'package:parking_kori/view/styles.dart';

Widget ParkingInfoCard(BuildContext context, String icon, String vehicleType, int presentCount, int capacity, action){
  return InkWell(
    onTap: action,
    child: Container(
      width: get_screenWidth(context)*0.3,
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.all(10),

      decoration: BoxDecoration(
        color: myred,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Image.asset(icon,
          height: get_screenWidth(context)*0.1,
          ),
          Text(
            vehicleType,
            style: boldTextStyle(context, myWhite),
          ),
          SizedBox(height: 10,),
          Text(
            "$presentCount/$capacity",
            style: normalTextStyle(context, myWhite.withOpacity(0.6)),
          ),
        ],
      ),
    ),
  );
}