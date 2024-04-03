import 'dart:convert';
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
  List<Booking> bookings = [];
   List<Booking> notPresentBookings = [];
   List<Booking> presentBookings = [];
  bool isParkedInSelected = true;

  void load_data() {
    // Fetch data from API or use dummy data
  }

  Future<void> createBooking() async {
    // Parameters for creating a new booking
    Map<String, dynamic> bookingData = {
      "vehicle_type": "1", // Replace with actual vehicle type ID
      "car_reg": "6523", // Replace with actual car registration number
      "agent_id": "2", // Replace with actual agent ID
      "location": "1" // Replace with actual location ID
    };

    // Make POST request to create a new booking
    final response = await http.post(
      Uri.parse('https://parking-kori.rpu.solutions/api/v1/new-booking'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        // Add authorization token if required
        // 'Authorization': 'Bearer your_access_token_here',
      },
      body: jsonEncode(bookingData),
    );

    if (response.statusCode == 200) {
      // If booking created successfully, reload data or show success message
      load_data();
    } else {
      // If booking creation failed, show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create booking')),
      );
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
                  padding: EdgeInsets.all( get_screenWidth(context)*0.1),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: (){ setState(() {
                                isParkedInSelected=true;
                              });},
                              child: Container(
                                alignment: Alignment.center,
                                constraints: BoxConstraints(minWidth: get_screenWidth(context)*0.35),
                                padding: EdgeInsets.all(get_screenWidth(context)*0.02),
                                decoration: isParkedInSelected? selectedBox(context):unselectedBox(context),
                                child: Text("Parked In",
                                style: isParkedInSelected? boldTextStyle(context, myWhite):boldTextStyle(context, myBlack),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: (){ setState(() {
                                isParkedInSelected=false;
                              });},
                              child: Container(
                                alignment: Alignment.center,
                                constraints: BoxConstraints(minWidth: get_screenWidth(context)*0.35),
                                padding: EdgeInsets.all(get_screenWidth(context)*0.02),
                                decoration: !isParkedInSelected? selectedBox(context):unselectedBox(context),
                                child: Text("Parked Out",
                                  style: !isParkedInSelected? boldTextStyle(context, myWhite):boldTextStyle(context, myBlack),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: isParkedInSelected
                            ? notPresentBookings.map((e) => ParkLogHistoryCard(context, e)).toList()
                            : presentBookings.map((e) => ParkLogHistoryCard(context, e)).toList(),
                      )

                    ],
                  ),
                ),

              ],
            ),
          ),
      )
    );
  }
}