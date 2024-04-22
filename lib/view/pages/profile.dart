// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cache_manager/cache_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:parking_kori/cache_handler.dart';
import 'package:parking_kori/sunmi.dart';
import 'package:parking_kori/view/pages/infocard.dart';
import 'package:parking_kori/view/pages/main_page.dart';
import 'package:parking_kori/view/styles.dart';
import 'package:parking_kori/view/widgets/action_button.dart';
import 'package:parking_kori/view/widgets/appbar.dart';
import 'package:parking_kori/view/widgets/dateInput.dart';
import 'package:parking_kori/view/widgets/profile_info_card.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String currentUser = "";
  int location = 0;
  String address = "";
  String token = '';
  int loginTime = 0;
  late Duration difference;
  late DateTime currentTime;
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now();
  int dif = 0;
  int parkin = 0;
  int parkout = 0;
  List<Map<String, dynamic>> totalIncome = [];
  late Timer _timer;

  String? baseUrl = dotenv.env['BASE_URL'];

  Future<void> load_data() async {
    String token = await ReadCache.getString(key: "token");

    final client = HttpClient();
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;

    final requestData = await client.getUrl(
      Uri.parse(
          '$baseUrl/report-summary?from_date=${formatDate(startTime)} && to_date=${formatDate(endTime)}'),
    );
    requestData.headers.add('Authorization', 'Bearer $token');
    final responseData = await requestData.close();

    final responseBody = await responseData.transform(utf8.decoder).join();

    if (responseData.statusCode == 200) {
      final responseData = json.decode(responseBody);
      setState(() {
        parkin = responseData['total_park_in'];
        parkout = responseData['total_park_out'];
        totalIncome =
            List<Map<String, dynamic>>.from(responseData['total_income']);
      });
    } else {
      throw Exception('Failed to load data present park log');
    }
  }

  Future<void> fetchDataFromCache() async {
    try {
      currentUser = await ReadCache.getString(key: "cache");
      print(currentUser);
      token = await ReadCache.getString(key: "token");
      loginTime = await ReadCache.getInt(key: "loginTime");
      location = await ReadCache.getInt(key: "locationId");
      address = await ReadCache.getString(key: "address");

      setState(() {
        currentUser = getUserNameFromChache(caesarCipherDecode(currentUser, 2));
        currentTime = DateTime.now();
        DateTime savedDateTime = DateTime.fromMillisecondsSinceEpoch(loginTime);
        difference = currentTime.difference(savedDateTime);
        dif = difference.inHours;
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  String formatTime(DateTime dateTime) {
    String hour = (dateTime.hour > 12)
        ? (dateTime.hour - 12).toString()
        : dateTime.hour.toString();
    String minute = dateTime.minute.toString().padLeft(2, '0');
    String second = dateTime.second.toString().padLeft(2, '0');
    String amPm = (dateTime.hour >= 12) ? 'PM' : 'AM';

    return '$hour:$minute:$second $amPm';
  }

  String formatDate(DateTime dateTime) {
    return '${dateTime.day}-${dateTime.month}-${dateTime.year}';
  }

  void _onFromDateSelected(DateTime selectedDate) {
    setState(() {
      startTime = selectedDate;
      endTime = selectedDate;
    });
  }

  void _onGoButtonPressed() {
    load_data();
  }

  List<DataRow> buildAgentIncomeList() {
    List<DataRow> agentIncomeWidgets = [];

    Set<String> addedTitles = Set<String>();

    for (var agentIncome in totalIncome) {
      agentIncomeWidgets.add(
        DataRow(cells: [
          DataCell(Text(agentIncome['agent'])),
          DataCell(Text("${agentIncome['income']} Taka")),
        ]),
      );
      addedTitles.add(agentIncome['agent']);
    }

    return agentIncomeWidgets;
  }

  int calculateTotalIncome() {
    int total = 0;
    for (var agentIncome in totalIncome) {
      total += (agentIncome['income'] as int); // Casting income to int
    }
    return total;
  }

  void print_summary(
    String total_park_out,
    String total_park_in,
    String total_income,
    
    DataTable dataTable,
    DateTime startTime,
    String address,

  ) async {
    Sunmi printer = Sunmi();
    printer.print_summary(total_park_in, total_park_out, total_income, dataTable, startTime, address);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainPage()),
      );
  }

  @override
  void initState() {
    fetchDataFromCache();
    load_data();
    currentTime = DateTime.now();
    // _startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        currentTime = DateTime.now();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppBarWidget(context, "Profile"),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(get_screenWidth(context) * 0.1),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // SizedBox(
                      //   height: get_screenWidth(context) * 0.005,
                      // ),
                      Text(
                        "$address ($currentUser)",
                        style: nameTitleStyle(context, myBlack),
                      ),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      // Text(
                      //   formatTime(currentTime),
                      //   style: normalTextStyle(context, myBlack),
                      // ),
                      SizedBox(
                        height: get_screenWidth(context) * 0.005,
                      ),
                      Container(
                        margin: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(
                            color: Colors.black.withOpacity(0.7),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            DateInputWidget(
                              label: 'Select Date',
                              onDateSelected: _onFromDateSelected,
                            ),
                            InkWell(
                              onTap: _onGoButtonPressed,
                              child: Icon(
                                Icons.arrow_circle_right_sharp,
                                color: myred,
                                size: 40,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // SizedBox(
                      //   height: get_screenWidth(context) * 0.04,
                      // ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ProfileInfoCard(context, "Park In", "$parkin"),
                          ProfileInfoCard(context, "Park Out", "$parkout"),
                        ],
                      ),
                      SizedBox(
                        height: get_screenWidth(context) * 0.05,
                      ),
                      Container(
                        height: get_screenWidth(context) * 0.7,
                        width: get_screenWidth(context) * 0.75,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                          ),
                          // borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: SingleChildScrollView(
                          child: DataTable(
                            columns: [
                              DataColumn(label: Text('AGENT')),
                              DataColumn(label: Text('TAKA')),
                            ],
                            rows: buildAgentIncomeList(),
                          ),
                        ),
                      ),
                      // SizedBox(
                      //   height: get_screenWidth(context) * 0.05,
                      // ),
                      InfoCard(context, "Total Income",
                          "${calculateTotalIncome()} Taka"),
                      ActionButton3(
                        context,
                        "Print",
                        () => print_summary(
                          "$parkin",
                          "$parkout",
                          
                          "${calculateTotalIncome()} Taka",
                          DataTable(
                            columns: [
                              DataColumn(label: Text('AGENT')),
                              DataColumn(label: Text('TAKA')),
                            ],
                            rows: buildAgentIncomeList(),
                          ) as DataTable,
                          DateTime.now(),
                         "$address",
                          
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
