import 'dart:convert';
import 'dart:io';

import 'package:cache_manager/cache_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:parking_kori/cache_handler.dart';
import 'package:parking_kori/view/styles.dart';
import 'package:parking_kori/view/widgets/appbar.dart';
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
  late DateTime currentTime = DateTime.now();
  int dif = 0;
  int income = 0;
  int parkin = 0;
  int parkout = 0;

  String? baseUrl = dotenv.env['BASE_URL'];

  Future<void> load_data() async {
    String token = await ReadCache.getString(key: "token");

    // HttpClient with badCertificateCallback to bypass SSL certificate verification
    final client = HttpClient();
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;

    final requestData = await client.getUrl(
      Uri.parse('$baseUrl/report-summary'),
    );
    requestData.headers.add('Authorization', 'Bearer $token');
    final responseData = await requestData.close();

    final responseBody = await responseData.transform(utf8.decoder).join();

    if (responseData.statusCode == 200) {
      final responseData = json.decode(responseBody);
      setState(() {
        parkin = responseData['total_park_in'];
        parkout = responseData['total_park_out'];
        income = responseData['total_income'];
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

  String formatDate(DateTime dateTime) {
  String hour = (dateTime.hour > 12) ? (dateTime.hour - 12).toString() : dateTime.hour.toString();
  String minute = dateTime.minute.toString().padLeft(2, '0');
  String second = dateTime.second.toString().padLeft(2, '0');
  String amPm = (dateTime.hour >= 12) ? 'PM' : 'AM';
  
  return '${dateTime.day}/${dateTime.month}/${dateTime.year} $hour:$minute:$second $amPm';
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
            Container(
              padding: EdgeInsets.all(get_screenWidth(context) * 0.1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 30,
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
                    "Login Time: ${formatDate(DateTime.fromMillisecondsSinceEpoch(loginTime))}",
                    style: normalTextStyle(context, myBlack),
                  ),
                  const SizedBox(
                    height: 45,
                  ),
                  // DashboardInfoCard(context, "Location", address),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ProfileInfoCard(
                          context, "Work Hour", "${dif.toString()} hour(s)"),
                      ProfileInfoCard(context, "Park In", "$parkin"),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ProfileInfoCard(context, "Park Out", "$parkout"),
                      ProfileInfoCard(context, "Income", "$income Taka"),
                    ],
                  )

                  //ProfileInfoCard(context, "Work Hour", data)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
