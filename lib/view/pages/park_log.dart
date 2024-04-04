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
  List<Booking> bookings = [];
  List<Booking> notPresentBookings = [];
  List<Booking> presentBookings = [];
  bool isParkedInSelected = true;

  Future<void> load_data() async {
    String token = await ReadCache.getString(key: "token");
    final response = await http.get(
      Uri.parse(
          'https://parking-kori.rpu.solutions/api/v1/get/booking'), //api not created yet
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      bookings = json.decode(response.body);
      // print(bookings);
    } else {
      throw Exception('Failed to load data park log');
    }

    //****** asumme kortesi je sob data bookings array te chole eseche setstate er maddhome *********
    setState(() {
      notPresentBookings =
          bookings.where((element) => !element.isPresent).toList();
      presentBookings =
          bookings.where((element) => element.isPresent).toList();
    });
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
