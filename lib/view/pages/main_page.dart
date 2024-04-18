// ignore_for_file: prefer_const_constructors

import 'package:cache_manager/cache_manager.dart';
import 'package:flutter/material.dart';
import 'package:parking_kori/view/pages/home_page.dart';
import 'package:parking_kori/view/pages/park_log.dart';
import 'package:parking_kori/view/pages/profile.dart';
import 'package:parking_kori/view/styles.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int myIndex = 0;
  List<Widget> widgetList = const [
    HomePage(),
    //ShiftPage(),
    ParkLog(),
    //DashBoardPage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    // Check and delete cache when the MainPage is initialized
    checkAndDeleteCache();
  }

  Future<void> checkAndDeleteCache() async {
    int savedTime = await ReadCache.getInt(key: "loginTime");
    DateTime currentTime = DateTime.now();
    DateTime savedDateTime = DateTime.fromMillisecondsSinceEpoch(savedTime);
    Duration difference = currentTime.difference(savedDateTime);

    if (difference.inHours > 12) {
      DeleteCache.deleteKey("cache");
      DeleteCache.deleteKey("token");
      DeleteCache.deleteKey("id");
      DeleteCache.deleteKey("locationId");
      DeleteCache.deleteKey("loginTime");
    }
    }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (didPop) return;
        // When the back button is pressed, the controller.currentIndex.value will be 0 and that screen will show
        if (myIndex != 0) {
          setState(() {
              myIndex = 0;
            });
        } else {
         
          Navigator.pop(context);
        }},
      child: Scaffold(
        body: Container(
          child: widgetList[myIndex],
        ),
        bottomNavigationBar: BottomNavigationBar(
          elevation: 0,
          onTap: (index) {
            setState(() {
              myIndex = index;
            });
          },
          showUnselectedLabels: true,
          showSelectedLabels: true,
          currentIndex: myIndex,
          backgroundColor: myred,
          selectedItemColor: myWhite,
          unselectedItemColor: myWhite.withOpacity(0.6),
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
                label: "Parking",
                icon: Icon(
                  Icons.directions_bike,
                ),
                backgroundColor: myred),
            //  BottomNavigationBarItem(label: "Shift", icon: Icon(Icons.dataset_outlined), backgroundColor: myred),
            BottomNavigationBarItem(label: "Park log", icon: Icon(Icons.history)),
            //  BottomNavigationBarItem(label: "Dashboard", icon: Icon(Icons.dashboard)),
            BottomNavigationBarItem(label: "Profile", icon: Icon(Icons.person)),
          ],
        ),
      ),
    );
  }
}
