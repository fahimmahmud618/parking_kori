import 'dart:convert';
import 'dart:io';

import 'package:cache_manager/cache_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:parking_kori/cache_handler.dart';
import 'package:parking_kori/view/pages/infocard.dart';
import 'package:parking_kori/view/styles.dart';
import 'package:parking_kori/view/widgets/appbar.dart';
import 'package:parking_kori/view/widgets/dateInput.dart';
import 'package:parking_kori/view/widgets/profile_info_card.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

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
  DateTime currentTime = DateTime.now();
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now();
  int dif = 0;
  int parkin = 0;
  int parkout = 0;
  List<Map<String, dynamic>> totalIncome = []; // List of agent incomes

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
      print(location);
      print(loginTime);

      setState(() {
        currentUser = getUserNameFromChache(caesarCipherDecode(currentUser, 2));
        print(currentUser);
        currentTime = DateTime.now();
        print(currentTime);
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
    // return '${dateTime.day}/${dateTime.month}/${dateTime.year} $hour:$minute:$second $amPm';
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

  List<Widget> buildAgentIncomeList() {
  List<Widget> agentIncomeWidgets = [];
  
  // Keep track of added agent titles
  Set<String> addedTitles = Set<String>();

  for (var agentIncome in totalIncome) {
    // Check if the agent title has already been added
    if (!addedTitles.contains(agentIncome['agent'])) {
      agentIncomeWidgets.add(
        InfoCard(
          context,
          "Agent",
          agentIncome['agent'],
          "Income",
          "${agentIncome['income']} Taka",
        ),
      );

      // Add the agent title to the set of added titles
      addedTitles.add(agentIncome['agent']);
    } else {
      // If the agent title has already been added, only add the income
      agentIncomeWidgets.add(
        InfoCard(
          context,
          "", // Empty string for title
          "",
          "Income",
          "${agentIncome['income']} Taka",
        ),
      );
    }
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

  @override
  void initState() {
    fetchDataFromCache();
    load_data();
    super.initState();
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
                      SizedBox(
                        height: get_screenWidth(context) * 0.02,
                      ),
                      Text(
                        address,
                        style: nameTitleStyle(context, myBlack),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Agent: $currentUser",
                        style: normalTextStyle(context, myBlack),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Login Time: ${formatTime(DateTime.fromMillisecondsSinceEpoch(loginTime))}",
                        style: normalTextStyle(context, myBlack),
                      ),
                      Text(
                        "Currrent Time: ${formatTime(currentTime)}",
                        style: normalTextStyle(context, myBlack),
                      ),
                      const SizedBox(
                        height: 45,
                      ),
                      Row(
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
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: get_screenWidth(context) * 0.05,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ProfileInfoCard(context, "Park In", "$parkin", 1),
                          ProfileInfoCard(context, "Park Out", "$parkout", 1),
                        ],
                      ),
                      ...buildAgentIncomeList(),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ProfileInfoCard(context, "Total Income",
                              "${calculateTotalIncome()} Taka", 1),
                        ],
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
