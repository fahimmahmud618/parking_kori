import 'package:flutter/material.dart';
import 'package:parking_kori/model/booking.dart';
import 'package:parking_kori/view/styles.dart';



Widget ParkLogHistoryCard(BuildContext context, Booking booking) {
  return Container(
    padding: EdgeInsets.all(get_screenWidth(context) * 0.03),
    margin: EdgeInsets.only(bottom: get_screenWidth(context) * 0.02),
    decoration: BoxDecoration(
      color: myred,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Boooking Number : ${booking.booking_id}",
                  style: boldTextStyle(context, myWhite),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Registration Number: ${booking.registration_number}",
                  style: boldTextStyle(context, myWhite),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "In time: ${booking.in_time}",
                  style: normalTextStyle(context, myWhite.withOpacity(0.6)),
                ),
                booking.isPresent
                    ? Text(
                        "Present",
                        style:
                            normalTextStyle(context, myWhite.withOpacity(0.6)),
                      )
                    : Text(
                        "Out time: ${booking.out_time}",
                        style: boldTextStyle(context, myWhite.withOpacity(0.6)),
                      ),
              ],
            )),
        // Expanded(flex: 1, child: Icon(Icons.delete, color: myWhite,))
      ],
    ),
  );
}
