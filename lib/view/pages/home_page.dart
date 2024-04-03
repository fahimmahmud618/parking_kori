import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:parking_kori/view/image_file.dart';
import 'package:parking_kori/view/pages/add_vehicle.dart';
import 'package:parking_kori/view/pages/park_out_page.dart';
import 'package:parking_kori/view/widgets/action_button.dart';
import 'package:parking_kori/view/widgets/appbar.dart';
import 'package:parking_kori/view/widgets/parking_info_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
   int currentCarNumber = 0;
   int carCapacity = 0;
   int currentMotorCycleNumber = 0;
   int MotorCycleCapacity = 0;
   int currentCycleNumber = 0;
   int cycleCapacity = 0;
   int currentCNGNumber = 0;
   int cngCapacity = 0;
   int currentPickUpNumber = 0;
   int pickUpCapacity = 0;
   int currentTruckNumber = 0;
   int truckCapacity = 0;
   int currentothersNumber = 0;
    int othersCapacity = 0;
   final String authToken = "8|fQgXnTLbUem7bYwc0xV6IsvOYaEkCjZZDxEdBTvW5cbf90d0";

  @override
  void initState() {
    super.initState();
    fetchData();
  }

   Future<void> fetchData() async {
    // Fetch data for car
    await fetchVehicleData('car', '1');

    // Fetch data for bike
    await fetchVehicleData('bike', '2');

    // Fetch data for cycle
    await fetchVehicleData('cycle', '3');

    // Fetch data for CNG
    await fetchVehicleData('CNG', '4');
  }

 Future<void> fetchVehicleData(String vehicleType, String vehicleTypeId) async {
   print("Got vehicle types");
    final response = await http.get(
      Uri.parse('https://parking-kori.rpu.solutions/api/v1/get/vehicle-types'),
      headers: <String, String>{
        'Authorization': 'Bearer $authToken',
      },
    );
   
    print(response.body);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        switch (vehicleType) {
          case 'car':
            currentCarNumber = data['current_number'];
            carCapacity = data['capacity'];
            break;
          case 'bike':
            currentMotorCycleNumber = data['current_number'];
            MotorCycleCapacity = data['capacity'];
            break;
          case 'cycle':
            currentCycleNumber = data['current_number'];
            cycleCapacity = data['capacity'];
            break;
          case 'CNG':
            currentCNGNumber = data['current_number'];
            cngCapacity = data['capacity'];
            break;

            case 'pickup':
            currentCNGNumber = data['current_number'];
            cngCapacity = data['capacity'];
            break;

            case 'others':
            currentCNGNumber = data['current_number'];
            cngCapacity = data['capacity'];
            break;

          default:
            break;
        }
      });
    } else {
      throw Exception('Failed to load data for $vehicleType');
    }
  }

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

  void add_pickup(){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>AddVehicle(vehicleType: "pickup")));
  }

  void add_others(){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>AddVehicle(vehicleType: "others")));
  }

  void go_to_park_out(){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>ParkOut()));
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
                ParkingInfoCard(context, carLogo, "Car", currentCarNumber, carCapacity,add_car ),
                SizedBox(width: 20,),
                ParkingInfoCard(context, bikeLogo, "Bike", currentMotorCycleNumber, MotorCycleCapacity, add_bike),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ParkingInfoCard(context, cycleLogo, "Cycle", currentCycleNumber, cycleCapacity, add_cycle),
                SizedBox(width: 20,),
                ParkingInfoCard(context, cngLogo, "CNG", currentCNGNumber, cngCapacity, add_cng),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ParkingInfoCard(context, pickupLogo, "Pickup", currentPickUpNumber, pickUpCapacity, add_cycle),
                SizedBox(width: 20,),
                ParkingInfoCard(context, othersLogo, "Others", currentothersNumber, othersCapacity, add_cng),
              ],
            ),
            SizedBox(height: 40,),
            ActionButton2(context, "Park Out", go_to_park_out),

          ],
        )
      ),

    ));
  }
}