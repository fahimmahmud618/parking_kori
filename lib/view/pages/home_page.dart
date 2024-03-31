import 'package:flutter/material.dart';
import 'package:parking_kori/view/image_file.dart';
import 'package:parking_kori/view/widgets/appbar.dart';
import 'package:parking_kori/view/widgets/parking_info_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  void add_car(){

  }
  void add_bike(){

  }
  void add_cycle(){

  }
  void add_cng(){

  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            AppBarWidget(context),
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
            )
          ],
        )
      ),
    ));
  }
}
