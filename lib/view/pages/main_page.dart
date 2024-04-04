import 'package:flutter/material.dart';
import 'package:parking_kori/view/pages/dashboard.dart';
import 'package:parking_kori/view/pages/home_page.dart';
import 'package:parking_kori/view/pages/login_page.dart';
import 'package:parking_kori/view/pages/park_log.dart';
import 'package:parking_kori/view/pages/profile.dart';
import 'package:parking_kori/view/pages/shift.dart';
import 'package:parking_kori/view/styles.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int myIndex=0;
  List<Widget> widgetList = const[
    // LoginPage(),
    HomePage(),
    ShiftPage(),
    ParkLog(),
    DashBoardPage(),
    ProfilePage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: widgetList[myIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        onTap: (index){
          setState(() {
            myIndex=index;
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
          BottomNavigationBarItem(label: "Parking", icon: Icon(Icons.directions_bike, ), backgroundColor: myred),
          BottomNavigationBarItem(label: "Shift", icon: Icon(Icons.dataset_outlined), backgroundColor: myred),
          BottomNavigationBarItem(label: "Park log", icon: Icon(Icons.history)),
          BottomNavigationBarItem(label: "Dashboard", icon: Icon(Icons.dashboard)),
          BottomNavigationBarItem(label: "Profile", icon: Icon(Icons.person)),
        ],
      ),
    );
  }
}
