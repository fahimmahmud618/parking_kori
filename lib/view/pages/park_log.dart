import 'dart:convert';
import 'dart:io';
import 'package:cache_manager/core/read_cache_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:parking_kori/model/booking.dart';
import 'package:parking_kori/view/styles.dart';
import 'package:parking_kori/view/widgets/action_button.dart';
import 'package:parking_kori/view/widgets/alert_dialog.dart';
import 'package:parking_kori/view/widgets/appbar.dart';
import 'package:parking_kori/view/widgets/park_log_history_card.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ParkLog extends StatefulWidget {
  const ParkLog({Key? key}) : super(key: key);

  @override
  State<ParkLog> createState() => _ParkLogState();
}

class _ParkLogState extends State<ParkLog> {
  List<Booking> presentBookings = [];
  List<Booking> notPresentBookings = [];
  List<Booking> showableList = [];
  bool isParkedInSelected = true;

  String? baseUrl = dotenv.env['BASE_URL'];
  String url = '';
  // String? finalURL = '$baseUrl/get-booking';
  String firstPageURLIn = '';
  String lastPageURLIn = '';
  String? prevPageURLIn;
  String? nextPageURLIn;
  int lastPageNumIn = 1;
  int currentPageIn = 0;

  String firstPageURLOut = '';
  String lastPageURLOut = '';
  String? prevPageURLOut;
  String? nextPageURLOut;
  int lastPageNumOut = 1;
  int currentPageOut = 0;

  String formatTime(DateTime dateTime) {
    String hour = (dateTime.hour > 12)
        ? (dateTime.hour - 12).toString()
        : dateTime.hour.toString();
    String minute = dateTime.minute.toString().padLeft(2, '0');
    String second = dateTime.second.toString().padLeft(2, '0');
    String amPm = (dateTime.hour >= 12) ? 'PM' : 'AM';

    return '${dateTime.day}/${dateTime.month}/${dateTime.year}   $hour:$minute:$second $amPm';
  }

  Future<void> loadParkInData(String url) async {
    try {
      presentBookings.clear();
      String token = await ReadCache.getString(key: "token");

      final client = HttpClient();
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;

      final requestParkIn = await client.getUrl(
        Uri.parse('$url&status=pending'),
      );
      requestParkIn.headers.set('Authorization', 'Bearer $token');
      final responseParkIn = await requestParkIn.close();
      if (responseParkIn.statusCode == 200) {
        if (mounted) {
          // Check if the widget is still mounted
          await handleResponseIn(responseParkIn, true);
        }
      } else {
        throw Exception('Failed to load park in data');
      }
    } catch (e) {
      print('Error loading park in data: $e');
    }
  }

  Future<void> loadParkOutData(String url) async {
    try {
      notPresentBookings.clear();
      String token = await ReadCache.getString(key: "token");

      final client = HttpClient();
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;

      final requestParkOut = await client.getUrl(
        Uri.parse('$url&status=park-out'),
      );
      requestParkOut.headers.set('Authorization', 'Bearer $token');
      final responseParkOut = await requestParkOut.close();
      if (responseParkOut.statusCode == 200) {
        if (mounted) {
          // Check if the widget is still mounted

          await handleResponseOut(responseParkOut, false);
        }
      } else {
        throw Exception('Failed to load park out data');
      }
    } catch (e) {
      print('Error loading park out data: $e');
    }
  }

  Future<void> handleResponseIn(
      HttpClientResponse response, bool isPresent) async {
    final responseBody = await utf8.decoder.bind(response).join();
    final responseData = json.decode(responseBody);
    final bookingsData = responseData['booking']['data'];

    for (var bookingData in bookingsData) {
      String vehicleType = bookingData['vehicle_type_id'].toString();
      String bookingNumber = bookingData['booking_number'];
      String registrationNumber = bookingData['vehicle_reg_number'];
      DateTime inTime = DateTime.parse(bookingData['park_in_time']);
      String formattedInTime = formatTime(inTime);
      String formattedOutTime = "";

      setState(() {
        (isPresent ? presentBookings : notPresentBookings).add(
          Booking(
            booking_id: bookingNumber,
            vehicle_type: vehicleType,
            registration_number: registrationNumber,
            in_time: formattedInTime,
            out_time: formattedOutTime,
            isPresent: isPresent,
          ),
        );
      });
    }

    setState(() {
      firstPageURLIn = responseData['booking']['first_page_url'];
      // print("First page url: ${firstPageURLIn}");
      lastPageURLIn = responseData['booking']['last_page_url'];
      // print("last page url: ${lastPageURLIn}");

      prevPageURLIn = responseData['booking']['prev_page_url'];
      // print("Prev page url: ${prevPageURLIn}");
      nextPageURLIn = responseData['booking']['next_page_url'];
      // print("Next page url: ${nextPageURLIn}");

      lastPageNumIn = responseData['booking']['last_page'];

      currentPageIn = responseData['booking']['current_page'];
      // print("Current Page Park In:   $currentPageIn");
    });
  }

  Future<void> handleResponseOut(
      HttpClientResponse response, bool isPresent) async {
    final responseBody = await utf8.decoder.bind(response).join();
    final responseData = json.decode(responseBody);
    final bookingsData = responseData['booking']['data'];

    for (var bookingData in bookingsData) {
      String vehicleType = bookingData['vehicle_type_id'].toString();
      String bookingNumber = bookingData['booking_number'];
      String registrationNumber = bookingData['vehicle_reg_number'];

      DateTime inTime = DateTime.parse(bookingData['park_in_time']);
      String formattedInTime = formatTime(inTime);
      DateTime? outTime = bookingData['park_out_time'] != null
          ? DateTime.parse(bookingData['park_out_time'])
          : null;

      String formattedOutTime = outTime != null ? formatTime(outTime) : "";

      setState(() {
        (isPresent ? presentBookings : notPresentBookings).add(
          Booking(
            booking_id: bookingNumber,
            vehicle_type: vehicleType,
            registration_number: registrationNumber,
            in_time: formattedInTime,
            out_time: formattedOutTime,
            isPresent: isPresent,
          ),
        );
      });
    }

    setState(() {
      firstPageURLOut = responseData['booking']['first_page_url'];
      // print("First page url: ${firstPageURLOut}");
      lastPageURLOut = responseData['booking']['last_page_url'];
      // print("last page url: ${lastPageURLOut}");

      prevPageURLOut = responseData['booking']['prev_page_url'];
      // print("Prev page url: ${prevPageURLOut}");
      nextPageURLOut = responseData['booking']['next_page_url'];
      // print("Next page url: ${nextPageURLOut}");
      lastPageNumOut = responseData['booking']['last_page'];
      currentPageOut = responseData['booking']['current_page'];
      // print("Current Page Park Out:   $currentPageOut");
    });
  }

  void firstPageLoader() {
    loadParkInData(firstPageURLIn);
    loadParkOutData(firstPageURLOut);
  }

  void lastPageLoader() {
    loadParkInData(lastPageURLIn);
    loadParkOutData(lastPageURLOut);
  }

  void prevPageLoaderIn() {
    if (prevPageURLIn != null) {
      loadParkInData(prevPageURLIn!);
    } else {
      pageNotFound();
    }
  }

  void nextPageLoaderIn() {
    if (nextPageURLIn != null) {
      loadParkInData(nextPageURLIn!);
    } else {
      pageNotFound();
    }
  }

  void prevPageLoaderOut() {
    if (prevPageURLOut != null) {
      loadParkOutData(prevPageURLOut!);
    } else {
      pageNotFound();
    }
  }

  void nextPageLoaderOut() {
    if (nextPageURLOut != null) {
      loadParkOutData(nextPageURLOut!);
    } else {
      pageNotFound();
    }
  }

  void _runFilter(String enteredKeyword) {
    List<Booking> results = [];
    List<Booking> sourceList =
        isParkedInSelected ? presentBookings : notPresentBookings;

    if (enteredKeyword.isEmpty) {
      results = sourceList;
    } else {
      results = sourceList
          .where((element) =>
              element.booking_id
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()) ||
              element.registration_number
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      showableList = results;
    });
  }

  @override
  void initState() {
    setState(() {
      url = '$baseUrl/get-booking';
    });
    loadParkInData('${url}?page=1');
    loadParkOutData('${url}?page=1');
    showableList = presentBookings;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void pageNotFound() {
    myAlertDialog("Parking Kori", "Page Not Found", context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              AppBarWidget(context, "Park Log"),
              searchBox(),
              if (showableList.isEmpty)
                Center(
                  child: Container(
                    height: get_screenWidth(context) * 1.5,
                    width: get_screenWidth(context),
                    child: LoadingAnimationWidget.fourRotatingDots(
                      color: myred,
                      size: 50,
                    ),
                  ),
                )
              else
                Padding(
                  padding: EdgeInsets.all(get_screenWidth(context) * 0.05),
                  child: Column(
                    children: [
                      // Displaying Park In and Park Out tabs
                      Container(
                        margin: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  isParkedInSelected = true;
                                  showableList = presentBookings;
                                });
                              },
                              child: Container(
                                alignment: Alignment.center,
                                constraints: BoxConstraints(
                                  minWidth: get_screenWidth(context) * 0.35,
                                ),
                                padding: EdgeInsets.all(
                                    get_screenWidth(context) * 0.02),
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
                                  showableList = notPresentBookings;
                                });
                              },
                              child: Container(
                                alignment: Alignment.center,
                                constraints: BoxConstraints(
                                  minWidth: get_screenWidth(context) * 0.35,
                                ),
                                padding: EdgeInsets.all(
                                    get_screenWidth(context) * 0.02),
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
                      // Displaying Park Log History Cards
                      Column(
                        children: showableList
                            .map((e) => ParkLogHistoryCard(context, e))
                            .toList(),
                      ),
                      // Displaying Pagination buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ActionButton4(
                              context, "1", firstPageLoader, 0.1, false),
                          ActionButton4(
                            context,
                            "<",
                            isParkedInSelected
                                ? prevPageLoaderIn
                                : prevPageLoaderOut,
                            0.1,
                            (isParkedInSelected && prevPageURLIn == null) ||
                                (!isParkedInSelected && prevPageURLOut == null),
                          ),
                          ActionButton4(
                            context,
                            ">",
                            isParkedInSelected
                                ? nextPageLoaderIn
                                : nextPageLoaderOut,
                            0.1,
                            (isParkedInSelected && nextPageURLIn == null) ||
                                (!isParkedInSelected && nextPageURLOut == null),
                          ),
                          ActionButton4(
                              context,
                              isParkedInSelected
                                  ? lastPageNumIn.toString()
                                  : lastPageNumOut.toString(),
                              lastPageLoader,
                              0.1,
                              false),
                        ],
                      ),
                      SizedBox(
                        height: 10 * get_scale_factor(context),
                      ),
                      isParkedInSelected
                          ? Text(
                              "Showing page $currentPageIn out of $lastPageNumIn",
                              style: normalTextStyle(context, myBlack))
                          : Text(
                              "Showing page $currentPageOut out of $lastPageNumOut",
                              style: normalTextStyle(context, myBlack)),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget searchBox() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.fromLTRB(2, 0, 1, 2),
      margin: EdgeInsets.fromLTRB(20 * get_scale_factor(context),
          15 * get_scale_factor(context), 20 * get_scale_factor(context), 0),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: myred.withOpacity(0.5), // Set the desired border color
          width: 2, // Set the desired border width
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(10, 8, 0, 0),
            child: Icon(
              Icons.search,
              color: myred,
              size: 20 * get_scale_factor(context),
            ),
          ),
          SizedBox(
            width: 10 * get_scale_factor(context),
          ), // Adjust the spacing as needed
          Expanded(
            child: TextField(
              onChanged: (value) => _runFilter(value),
              decoration: InputDecoration(
                hintText: "Search Booking number or Registration number",
                hintStyle: hintTextStyle(context, myBlack.withOpacity(0.6)),
                contentPadding: EdgeInsets.all(0),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
