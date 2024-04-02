import 'package:flutter/material.dart';
import 'package:parking_kori/view/image_file.dart';
import 'package:parking_kori/view/pages/add_vehicle.dart';
import 'package:parking_kori/view/pages/dashboard.dart';
import 'package:parking_kori/view/pages/park_log.dart';
import 'package:parking_kori/view/pages/park_out_page.dart';
import 'package:parking_kori/view/pages/profile.dart';
import 'package:parking_kori/view/widgets/action_button.dart';
import 'package:parking_kori/view/widgets/appbar.dart';
import 'package:parking_kori/view/widgets/parking_info_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  void add_car(){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>AddVehicle(vehicleType: "car")));
  }
  void add_bike(){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>AddVehicle(vehicleType: "bike")));
  }
  void add_cycle(){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>AddVehicle(vehicleType: "cycle")));
  }
  void add_cng(){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>AddVehicle(vehicleType: "cng")));
  }

  void go_to_park_out(){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>ParkOut()));
  }

  void go_to_park_log(){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>ParkLog()));
  }
  void go_to_dashboard(){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>DashBoardPage()));
  }
  void go_to_profile(){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfilePage()));
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            AppBarWidget(context, "Home"),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ParkingInfoCard(context, carLogo, "Car", 18, 100,add_car ),
                SizedBox(width: 20,),
                ParkingInfoCard(context, bikeLogo, "Bike", 20, 30, add_bike),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ParkingInfoCard(context, cycleLogo, "Cycle", 18, 60, add_cycle),
                SizedBox(width: 20,),
                ParkingInfoCard(context, cngLogo, "CNG", 25, 50, add_cng),
              ],
            ),
            SizedBox(height: 40,),
            ActionButton(context, "Park Out", go_to_park_out),
            ActionButton(context, "Park log", go_to_park_log),
            ActionButton(context, "Dashboard", go_to_dashboard),
            ActionButton(context, "Profile", go_to_profile)
          ],
        )
      ),

    ));
  }
}
