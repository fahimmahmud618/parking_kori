import 'package:flutter/material.dart';
import 'package:parking_kori/view/styles.dart';

Widget InfoCard(BuildContext context, String title1, String data1, String title2, String data2) {
  return Container(
    width: 285, // Adjust width as needed
    height: 100, // Adjust height as needed
    margin: EdgeInsets.only(top: 20),
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: myred,
      borderRadius: BorderRadius.circular(8),
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
                  title1,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: myWhite,
                  ),
                ),
                SizedBox(height: 1), // Reduce the height here
                Text(
                  data1,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: myWhite,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title2,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: myWhite,
                  ),
                ),
                SizedBox(height: 1), // Reduce the height here
                Text(
                  data2,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: myWhite,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}
