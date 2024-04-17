import 'package:cache_manager/cache_manager.dart';
import 'package:flutter/material.dart';
import 'package:parking_kori/cache_handler.dart';
import 'package:parking_kori/view/styles.dart';
import 'package:parking_kori/view/widgets/appbar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String currentUser = "";
  String token = '';
  int loginTime = 0;
  late Duration difference;
  late DateTime currentTime= DateTime.now();
  int dif = 0;

  Future<void> fetchDataFromCache() async {
    try {
      currentUser = await ReadCache.getString(key: "cache");
      token = await ReadCache.getString(key: "token");
      loginTime = await ReadCache.getInt(key: "loginTime");
      print(loginTime);
      setState(() {
        currentUser = getUserNameFromChache(caesarCipherDecode(currentUser, 2));
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
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}';
  }

  @override
  void initState() {
    fetchDataFromCache();
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
                  Text(
                    "Hi, $currentUser",
                    style: nameTitleStyle(context, myred),
                  ),
                  Text(
                    "Login Time: ${loginTime != null ? formatDate(DateTime.fromMillisecondsSinceEpoch(loginTime)) : 'N/A'}",
                    style: nameTitleStyle(context, myred),
                  ),
                  Text(
                    "Current Time: ${formatDate(currentTime)}",
                    style: nameTitleStyle(context, myred),
                  ),
                  Text(
                    "Work Time: ${dif.toString()} hour(s)",
                    style: nameTitleStyle(context, myred),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
