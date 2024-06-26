// ignore_for_file: non_constant_identifier_names, prefer_const_constructors

import 'dart:io';
import 'package:cache_manager/core/read_cache_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:parking_kori/view/image_file.dart';
import 'package:parking_kori/view/pages/add_vehicle.dart';
import 'package:parking_kori/view/pages/checkout.dart';
import 'package:parking_kori/view/pages/park_out_page.dart';
import 'package:parking_kori/view/styles.dart';
import 'package:parking_kori/view/widgets/action_button.dart';
import 'package:parking_kori/view/widgets/alert_dialog.dart';
import 'package:parking_kori/view/widgets/appbar.dart';
import 'package:parking_kori/view/widgets/input_with_icon_image.dart';
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
  String? baseUrl = dotenv.env['BASE_URL'];
  TextEditingController registration_number = new TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    await fetchVehicleData('car');
    await fetchVehicleData('motor-cycle');
    await fetchVehicleData('cng');
    await fetchVehicleData('cycle');
    await fetchVehicleData('pickup');
    await fetchVehicleData('others');
  }

  Future<void> fetchVehicleData(String vehicleType) async {
    try {
      final authToken = await ReadCache.getString(key: "token");
      final baseUrl = dotenv.env['BASE_URL'];

      final client = HttpClient();
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;

      final request = await client.getUrl(
        Uri.parse('$baseUrl/get/vehicle-types'),
      );
      request.headers.set('Authorization', 'Bearer $authToken');

      final response = await request.close();

      if (response.statusCode == 200) {
        final responseBody = await response.transform(utf8.decoder).join();
        final List<dynamic> data = json.decode(responseBody);

        // Iterate over each element in the data list
        for (final vehicleData in data) {
          final vehicleTypeSlug = vehicleData['vehicle_type']['slug'];
          if (vehicleTypeSlug == vehicleType) {
            vehicle_loader(vehicleType, vehicleData);
            break;
          }
        }
      } else {
        throw Exception('Failed to load data for $vehicleType');
      }

      client.close();
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  void vehicle_loader(String vehicleType, vehicleData) {
    return setState(() {
      switch (vehicleType) {
        case 'car':
          currentCarNumber = vehicleData['remaining_capacity'];
          carCapacity = vehicleData['capacity']['capacity'];
          currentCarNumber = carCapacity - currentCarNumber;
          break;
        case 'motor-cycle':
          currentMotorCycleNumber = vehicleData['remaining_capacity'];
          MotorCycleCapacity = vehicleData['capacity']['capacity'];
          currentMotorCycleNumber =
              MotorCycleCapacity - currentMotorCycleNumber;
          break;
        case 'cycle':
          currentCycleNumber = vehicleData['remaining_capacity'];
          cycleCapacity = vehicleData['capacity']['capacity'];
          currentCycleNumber = cycleCapacity - currentCycleNumber;
          break;
        case 'cng':
          currentCNGNumber = vehicleData['remaining_capacity'];
          cngCapacity = vehicleData['capacity']['capacity'];
          currentCNGNumber = cngCapacity - currentCNGNumber;
          break;
        case 'pickup':
          currentPickUpNumber = vehicleData['remaining_capacity'];
          pickUpCapacity = vehicleData['capacity']['capacity'];
          currentPickUpNumber = pickUpCapacity - currentPickUpNumber;
          break;
        case 'others':
          currentothersNumber = vehicleData['remaining_capacity'];
          othersCapacity = vehicleData['capacity']['capacity'];
          currentothersNumber = othersCapacity - currentothersNumber;
          break;
        default:
          break;
      }
    });
  }

  void add_car() {
    if (carCapacity > 0) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AddVehicle(
                    vehicleType: "1",
                  )));
    } else {
      showCapacityAlert("Car");
    }
  }

  void add_bike() {
    if (MotorCycleCapacity > 0) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AddVehicle(
                    vehicleType: "2",
                  )));
    } else {
      showCapacityAlert("Motor Cycle");
    }
  }

  void add_cycle() {
    if (cycleCapacity > 0) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AddVehicle(
                    vehicleType: "3",
                  )));
    } else {
      showCapacityAlert("Cycle");
    }
  }

  void add_pickup() {
    if (pickUpCapacity > 0) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AddVehicle(
                    vehicleType: "4",
                  )));
    } else {
      showCapacityAlert("Pickup/Truck");
    }
  }

  void add_others() {
    if (othersCapacity > 0) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AddVehicle(
                    vehicleType: "5",
                  )));
    } else {
      showCapacityAlert("others");
    }
  }

  void add_cng() {
    if (cngCapacity > 0) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AddVehicle(
                    vehicleType: "6",
                  )));
    } else {
      showCapacityAlert("CNG");
    }
  }

  void showCapacityAlert(String title) {
    myAlertDialog(
        "$title Capacity is 0", "Sorry, you can't add any vehicle.", context);
  }

  void go_to_park_out() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ParkOut()));
  }

  void do_park_out_with_regNUmber() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                CheckOutPage(booking_num: registration_number.text)));
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
                height: get_screenWidth(context) * 0.05,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ParkingInfoCard(context, carLogo, "Car", currentCarNumber,
                      carCapacity, add_car),
                  ParkingInfoCard(context, bikeLogo, "Bike",
                      currentMotorCycleNumber, MotorCycleCapacity, add_bike),
                  ParkingInfoCard(context, cycleLogo, "Cycle",
                      currentCycleNumber, cycleCapacity, add_cycle),
                ],
              ),
              SizedBox(
                height: get_screenWidth(context) * 0.03,
              ),
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
                height: get_screenWidth(context) * 0.005,
              ),

              SizedBox(
                height: get_screenWidth(context) * 0.005,
              ),
              ActionButton2(context, "Park Out With QR Scan", go_to_park_out),
              SizedBox(
                height: get_screenWidth(context) * 0.005,
              ),
              Text(" | "),
              Text(
                "OR",
                style: nameTitleStyle(context, myBlack),
              ),
              Text(" | "),
              SizedBox(
                height: get_screenWidth(context) * 0.005,
              ),
              
              Text(
                "Park out with Registration Number",
                style: boldTextStyle(context, myBlack),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: get_screenWidth(context) * 0.05),
                child: Container(
                  margin: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    border: Border.all(
                      color: myBlack.withOpacity(0.2),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      regnum(context, registration_number),
                      InkWell(
                        onTap: do_park_out_with_regNUmber,
                        child: Icon(
                          Icons.arrow_circle_right_sharp,
                          color: myred,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
