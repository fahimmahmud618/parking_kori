// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cache_manager/core/read_cache_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:parking_kori/model/booking.dart';
import 'package:parking_kori/service/database.dart';
import 'package:parking_kori/view/styles.dart';
import 'package:parking_kori/view/widgets/appbar.dart';
import 'package:parking_kori/view/widgets/park_log_history_card.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ParkLog extends StatefulWidget {
  const ParkLog({Key? key}) : super(key: key);

  @override
  State<ParkLog> createState() => _ParkLogState();
}

class _ParkLogState extends State<ParkLog> {
  List<Booking> notPresentBookings = [];
  List<Booking> presentBookings = [];
  List<Booking> allBookings = [];
  bool isParkedInSelected = true;
  late List<ConnectivityResult> _connectionStatus;
  final Connectivity _connectivity = Connectivity();
  // ignore: unused_field
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  String? baseUrl = dotenv.env['BASE_URL'];

  Future<void> selectDB() async {
    if (_connectionStatus.contains(ConnectivityResult.none)) {
      fetchAllBookings();
    } else {
      load_data();
    }
  }

  Future<void> fetchAllBookings() async {
    try {
      List<Booking>? bookings = await DatabaseHelper.getAllCars();
      if (bookings != null) {
        
        allBookings = bookings;

        for (var bookingData in bookings) {      
          bool isPresent = bookingData.isPresent;
          handleResponse(
            bookingData as Map<String, dynamic>,
            isPresent,
          );
        }
      } else {
        allBookings.clear();
      }
    } catch (e) {
      print('Error fetching all bookings: $e');
    }
  }

  Future<void> load_data() async {
    String token = await ReadCache.getString(key: "token");

    // HttpClient with badCertificateCallback to bypass SSL certificate verification
    final client = HttpClient();
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;

    try {
      final request = await client.getUrl(
        Uri.parse('$baseUrl/get-booking'),
      );
      request.headers.add('Authorization', 'Bearer $token');
      final response = await request.close();

      if (response.statusCode == 200) {
        final responseBody = await utf8.decoder.bind(response).join();
        final responseData = json.decode(responseBody);

        List<dynamic> bookings = responseData['booking'];

        for (var bookingData in bookings) {
          String status = bookingData['status'];
          bool isPresent = status == 'pending';

          handleResponse(
            bookingData,
            isPresent,
          );
        }
      } else {
        throw Exception('Failed to load data park log');
      }
    } catch (e) {
      print('Error loading data from remote: $e');
      throw Exception('Failed to load data from remote');
    }
  }

  Future<void> handleResponse(
      Map<String, dynamic> bookingData, bool isPresent) async {
    String vehicleType = bookingData['vehicle_type_id'].toString();
    String bookingNumber = bookingData['booking_number'];
    String registrationNumber = bookingData['vehicle_reg_number'];
    String inTime = bookingData['park_in_time'];
    String outTime = isPresent ? "" : bookingData['park_out_time'];

    Booking booking = Booking(
      booking_id: bookingNumber,
      vehicle_type: vehicleType,
      registration_number: registrationNumber,
      in_time: inTime,
      out_time: outTime,
      isPresent: isPresent,
    );

    if (isPresent) {
      presentBookings.add(booking);
    } else {
      notPresentBookings.add(booking);
    }
    try {
      await DatabaseHelper.addVehicle(booking);
    } catch (e) {
      print('Error adding booking to local database: $e');
      throw Exception('Failed to add booking to local database');
    }
  }

  @override
  void initState() {
    _connectionStatus = [ConnectivityResult.none];
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    selectDB();
    super.initState();
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    setState(() {
      _connectionStatus = result;
    });
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
                        ? presentBookings
                            .map((e) => ParkLogHistoryCard(context, e))
                            .toList()
                        : notPresentBookings
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
