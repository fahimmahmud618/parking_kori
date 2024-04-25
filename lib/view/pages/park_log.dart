import 'dart:convert';
import 'dart:io';
import 'package:cache_manager/core/read_cache_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:parking_kori/model/booking.dart';
import 'package:parking_kori/view/styles.dart';
import 'package:parking_kori/view/widgets/appbar.dart';
import 'package:parking_kori/view/widgets/park_log_history_card.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ParkLog extends StatefulWidget {
  const ParkLog({Key? key}) : super(key: key);

  @override
  State<ParkLog> createState() => _ParkLogState();
}

class _ParkLogState extends State<ParkLog> {
  List<Booking> notPresentBookings = [];
  List<Booking> presentBookings = [];
  List<Booking> showableList = [];
  bool isParkedInSelected = true;
  int currentPage = 1;
  int perPage = 10; // Number of items per page
  bool isLoading = false;
  Future<void> loadNextPage() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    String token = await ReadCache.getString(key: "token");
    final client = HttpClient();
    client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;

    final request = await client.getUrl(
      Uri.parse('$baseUrl/get-booking?status=park-out&page=$currentPage&per_page=$perPage'),
    );
    request.headers.add('Authorization', 'Bearer $token');
    final response = await request.close();

    if (response.statusCode == 200) {
      await handleResponse(response, false);
      currentPage++; // Increment page number for next request
    } else {
      // Handle error
    }

    setState(() {
      isLoading = false;
    });
  }

  String? baseUrl = dotenv.env['BASE_URL'];

  String formatTime(DateTime dateTime) {
    String hour = (dateTime.hour > 12)
        ? (dateTime.hour - 12).toString()
        : dateTime.hour.toString();
    String minute = dateTime.minute.toString().padLeft(2, '0');
    String second = dateTime.second.toString().padLeft(2, '0');
    String amPm = (dateTime.hour >= 12) ? 'PM' : 'AM';

    return '${dateTime.day}/${dateTime.month}/${dateTime.year}   $hour:$minute:$second $amPm';
  }

  Future<void> load_data() async {
    if (isLoading) return;

    String token = await ReadCache.getString(key: "token");
    setState(() {
      isLoading = true;
    });

    final client = HttpClient();
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;

    final request = await client.getUrl(
      Uri.parse('$baseUrl/get-booking?status=park-out&page=$currentPage&per_page=$perPage'),
    );
    request.headers.add('Authorization', 'Bearer $token');
    final response = await request.close();

    if (response.statusCode == 200) {
      await handleResponse(response, false);
      currentPage++; // Increment page number for next request
    } else {
      // Handle error
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> handleResponse(
      HttpClientResponse response, bool isPresent) async {
    final responseBody = await utf8.decoder.bind(response).join();
    final responseData = json.decode(responseBody);
    final bookingsData = responseData['booking'];
    for (var bookingData in bookingsData) {
      String vehicleType = bookingData['vehicle_type_id'].toString();
      String bookingNumber = bookingData['booking_number'];
      String registrationNumber = bookingData['vehicle_reg_number'];
      DateTime inTime = DateTime.parse(bookingData['park_in_time']);
      String formattedInTime = formatTime(inTime);
      DateTime outTime = isPresent
          ? DateTime.now()
          : DateTime.parse(bookingData['park_out_time']);
      String formattedOutTime = isPresent ? "" : formatTime(outTime);

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
  }

  void _runFilter(String enteredKeyword) {
    List<Booking> results = [];
    if (enteredKeyword.isEmpty) {
      if (isParkedInSelected)
        results = presentBookings;
      else
        results = notPresentBookings;
      // results = todoList;
    } else {
      if (isParkedInSelected) {
        results = presentBookings
            .where((element) =>
                element.booking_id
                    .toLowerCase()
                    .contains(enteredKeyword.toLowerCase()) ||
                element.registration_number
                    .toLowerCase()
                    .contains(enteredKeyword.toLowerCase()))
            .toList();
      } else {
        results = notPresentBookings
            .where((element) =>
                element.booking_id
                    .toLowerCase()
                    .contains(enteredKeyword.toLowerCase()) ||
                element.registration_number
                    .toLowerCase()
                    .contains(enteredKeyword.toLowerCase()))
            .toList();
      }
    }

    setState(() {
      showableList = results;
    });
  }

  @override
  void initState() {
    load_data();
    showableList = presentBookings;
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
              searchBox(),
              FutureBuilder<void>(
                future: load_data(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Container(
                        height: 100,
                        width: 100,
                        child: LoadingAnimationWidget.fourRotatingDots(
                          color: myred,
                          size: 50,
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return Container(
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
                                      showableList = presentBookings;
                                    });
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    constraints: BoxConstraints(
                                        minWidth:
                                            get_screenWidth(context) * 0.35),
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
                                        minWidth:
                                            get_screenWidth(context) * 0.35),
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
                          Column(
                            children: showableList
                                .map((e) => ParkLogHistoryCard(context, e))
                                .toList(),
                          ),
                          if (isLoading)
                            CircularProgressIndicator(), // Show loading indicator while loading next page
                          ElevatedButton(
                            onPressed: loadNextPage,
                            child: Text('Load Next Page'),
                          ),
                        ],
                      ),
                    );
                  }
                },
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
              width: 10 *
                  get_scale_factor(context)), // Adjust the spacing as needed
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
