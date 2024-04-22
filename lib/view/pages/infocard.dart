// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:parking_kori/view/styles.dart';

Widget InfoCard(BuildContext context, String data1, String data2) {
  return Container(
    width: get_screenWidth(context) * 0.75,
    height: get_screenWidth(context) * 0.12,
    margin: const EdgeInsets.only(top: 5),
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: myred,
      // borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data1,
                  style: normalTextStyle(context, myWhite),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data2,
                  style: normalTextStyle(context, myWhite),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}
