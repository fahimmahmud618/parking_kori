// ignore_for_file: non_constant_identifier_names, prefer_const_constructors

import 'dart:io';
import 'package:cache_manager/core/read_cache_service.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:parking_kori/view/image_file.dart';
import 'package:parking_kori/view/pages/add_vehicle.dart';
import 'package:parking_kori/view/pages/park_out_page.dart';
import 'package:parking_kori/view/styles.dart';
import 'package:parking_kori/view/widgets/action_button.dart';
import 'package:parking_kori/view/widgets/appbar.dart';
import 'package:parking_kori/view/widgets/parking_info_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

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
  String authToken = "";

  @override
  void initState() {
    super.initState();
    print("TESTING");
    fetchData();
  }

  Future<void> fetchData() async {
    await fetchVehicleData('Car', '1');
    await fetchVehicleData('Motor Cycle', '2');
    await fetchVehicleData('CNG', '3');
    await fetchVehicleData('Cycle', '4');
    await fetchVehicleData('Pickup', '5');
    await fetchVehicleData('Others', '6');
  }

  Future<void> fetchVehicleData(String vehicleType, String vehicleTypeId) async {
    try {
      authToken = await ReadCache.getString(key: "token");

      final client = HttpClient();

      // Set the badCertificateCallback to ignore SSL certificate validation errors
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;

      final request = await client.getUrl(
        Uri.parse('https://parking-kori.rpu.solutions/api/v1/get/vehicle-types'),
      );
      request.headers.set('Authorization', 'Bearer $authToken');

      final response = await request.close();
      
      // Read and decode the response
      final responseBody = await response.transform(utf8.decoder).join();
      // final List<dynamic> data = json.decode(responseBody);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(responseBody);
        final vehicleData = data.firstWhere(
          (element) => element['vehicle_type']['slug'] == vehicleType,
          orElse: () => null,
        );
        if (vehicleData != null) {
          setState(() {
            switch (vehicleType) {
              case 'Car':
                currentCarNumber = vehicleData['remaining_capacity'];
                carCapacity = vehicleData['capacity']['capacity'];
                currentCarNumber = carCapacity - currentCarNumber;
                break;
              case 'Motor Cycle':
                currentMotorCycleNumber = vehicleData['remaining_capacity'];
                MotorCycleCapacity = vehicleData['capacity']['capacity'];
                currentMotorCycleNumber = MotorCycleCapacity - currentMotorCycleNumber;
                break;
              case 'Cycle':
                currentCycleNumber = vehicleData['remaining_capacity'];
                cycleCapacity = vehicleData['capacity']['capacity'];
                currentCycleNumber = cycleCapacity - currentCycleNumber;
                break;
              case 'CNG':
                currentCNGNumber = vehicleData['remaining_capacity'];
                cngCapacity = vehicleData['capacity']['capacity'];
                currentCNGNumber = cngCapacity - currentCNGNumber;
                break;
              case 'Pickup':
                currentPickUpNumber = vehicleData['remaining_capacity'];
                pickUpCapacity = vehicleData['capacity']['capacity'];
                currentPickUpNumber = pickUpCapacity - currentPickUpNumber;
                break;
              case 'Others':
                currentothersNumber = vehicleData['remaining_capacity'];
                othersCapacity = vehicleData['capacity']['capacity'];
                currentothersNumber = othersCapacity - currentothersNumber;
                break;
              default:
                break;
            }
          });
        }
      } else {
        throw Exception('Failed to load data for $vehicleType');
      }

      // Close the client after the request
      client.close();
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  void add_car() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddVehicle(vehicleType: "1")));
  }

  void add_bike() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddVehicle(vehicleType: "2")));
  }

 void add_cng() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddVehicle(vehicleType: "3")));
  }
  void add_cycle() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddVehicle(vehicleType: "4")));
  }


  void add_pickup() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddVehicle(vehicleType: "5")));
  }

  void add_others() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddVehicle(vehicleType: "6")));
  }

  void go_to_park_out() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ParkOut()));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              AppBarWidget(context, "Parking"),
              SizedBox(
                height: get_screenWidth(context)*0.05,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ParkingInfoCard(context, carLogo, "Car", currentCarNumber,
                      carCapacity, add_car),
                  ParkingInfoCard(context, bikeLogo, "Bike",
                      currentMotorCycleNumber, MotorCycleCapacity, add_bike),
                  ParkingInfoCard(context, cycleLogo, "Cycle", currentCycleNumber,
                      cycleCapacity, add_cycle),
                ],
              ),
              SizedBox(height: get_screenWidth(context)*0.03,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  ParkingInfoCard(context, cngLogo, "CNG", currentCNGNumber,
                      cngCapacity, add_cng),
                  ParkingInfoCard(context, pickupLogo, "Pickup",
                      currentPickUpNumber, pickUpCapacity, add_pickup),
                  ParkingInfoCard(context, othersLogo, "Others",
                      currentothersNumber, othersCapacity, add_others),
                ],

              ),

              SizedBox(
                height: get_screenWidth(context)*0.05,
              ),
              ActionButton2(context, "Park Out", go_to_park_out),
            ],
          ),
        ),
      ),
    );
  }
}
