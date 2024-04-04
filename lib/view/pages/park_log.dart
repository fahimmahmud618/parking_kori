// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'package:cache_manager/core/read_cache_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:parking_kori/model/booking.dart';
import 'package:parking_kori/view/styles.dart';
import 'package:parking_kori/view/widgets/appbar.dart';
import 'package:parking_kori/view/widgets/park_log_history_card.dart';

class ParkLog extends StatefulWidget {
  const ParkLog({Key? key}) : super(key: key);

  @override
  State<ParkLog> createState() => _ParkLogState();
}

class _ParkLogState extends State<ParkLog> {
  List<Booking> notPresentBookings = [];
  List<Booking> presentBookings = [];
  bool isParkedInSelected = true;

  Future<void> load_data() async {
    String token = await ReadCache.getString(key: "token");
    final responseParkin = await http.get(
      Uri.parse(
          'https://parking-kori.rpu.solutions/api/v1/get-booking?status=pending'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (responseParkin.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(responseParkin.body);
      List<dynamic> bookingsData = responseData['booking'];
      for (var bookingData in bookingsData) {
        String bookingId = bookingData['id'].toString();
        String vehicleType = bookingData['vehicle_type_id'].toString();
        String registrationNumber = bookingData['vehicle_reg_number'];
        String inTime = bookingData['park_in_time'];
        String outTime = "";
        bool isPresent = bookingData['status'] == 'pending';

        presentBookings.add(Booking(
          booking_id: bookingId,
          vehicle_type: vehicleType,
          registration_number: registrationNumber,
          in_time: inTime,
          out_time: outTime,
          isPresent: isPresent,
        ));
      }

      // Print the present bookings
      for (var booking in presentBookings) {
        print('Booking ID: ${booking.booking_id}');
        print('Vehicle Type: ${booking.vehicle_type}');
        print('Is Present: ${booking.isPresent}');
        print('---------------------------------');
      }
    } else {
      throw Exception('Failed to load data present park log');
    }

     final responseParkOut = await http.get(
      Uri.parse(
          'https://parking-kori.rpu.solutions/api/v1/get-booking?status=park-out'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (responseParkin.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(responseParkin.body);
      List<dynamic> bookingsData = responseData['booking'];
      for (var bookingData in bookingsData) {
        String bookingId = bookingData['id'].toString();
        String vehicleType = bookingData['vehicle_type_id'].toString();
        String registrationNumber = bookingData['vehicle_reg_number'];
        String inTime = bookingData['park_in_time'];
        String outTime =  bookingData['park_out_time'];
        bool isPresent = bookingData['status'] == 'pending';

        presentBookings.add(Booking(
          booking_id: bookingId,
          vehicle_type: vehicleType,
          registration_number: registrationNumber,
          in_time: inTime,
          out_time: outTime,
          isPresent: isPresent,
        ));
      }

      // Print the present bookings
      for (var booking in presentBookings) {
        print('Booking ID: ${booking.booking_id}');
        print('Vehicle Type: ${booking.vehicle_type}');
        print('Is Present: ${booking.isPresent}');
        print('---------------------------------');
      }
    } else {
      throw Exception('Failed to load data pared out park log');
    }
  }

  @override
  void initState() {
    load_data();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            AppBarWidget(context, "Park Log"),
            Container(
              padding: EdgeInsets.all(get_screenWidth(context) * 0.1),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              isParkedInSelected = true;
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            constraints: BoxConstraints(
                                minWidth: get_screenWidth(context) * 0.35),
                            padding:
                                EdgeInsets.all(get_screenWidth(context) * 0.02),
                            decoration: isParkedInSelected
                                ? selectedBox(context)
                                : unselectedBox(context),
                            child: Text(
                              "Parked In",
                              style: isParkedInSelected
                                  ? boldTextStyle(context, myWhite)
                                  : boldTextStyle(context, myBlack),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              isParkedInSelected = false;
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            constraints: BoxConstraints(
                                minWidth: get_screenWidth(context) * 0.35),
                            padding:
                                EdgeInsets.all(get_screenWidth(context) * 0.02),
                            decoration: !isParkedInSelected
                                ? selectedBox(context)
                                : unselectedBox(context),
                            child: Text(
                              "Parked Out",
                              style: !isParkedInSelected
                                  ? boldTextStyle(context, myWhite)
                                  : boldTextStyle(context, myBlack),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: isParkedInSelected
                        ? notPresentBookings
                            .map((e) => ParkLogHistoryCard(context, e))
                            .toList()
                        : presentBookings
                            .map((e) => ParkLogHistoryCard(context, e))
                            .toList(),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
