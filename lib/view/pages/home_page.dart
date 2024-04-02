import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:parking_kori/view/image_file.dart';
import 'package:parking_kori/view/widgets/action_button.dart';
import 'package:parking_kori/view/widgets/appbar.dart';
import 'package:parking_kori/view/widgets/parking_info_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> vehicleTypes = [];

  @override
  void initState() {
    super.initState();
    fetchVehicleTypes();
  }

  Future<void> fetchVehicleTypes() async {
    final response = await http.get(
      Uri.parse('https://parking-kori.rpu.solutions/api/v1/get/vehicle-types?vehicle_type=3'),
      headers: <String, String>{
        'Authorization': 'Bearer 1|I96d9BXq3vZUP8ZKtV81aZnxFoEzVs08HFIm0gx1939fb826',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        vehicleTypes = json.decode(response.body)['data'] ?? [];
      });
    } else {
      // Handle error
      print('Failed to load vehicle types');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              AppBarWidget(context, "Home"),
              for (var vehicleType in vehicleTypes)
                ParkingInfoCard(
                  context,
                  carLogo, // Change logo based on vehicle type
                  vehicleType['name'] ?? '',
                  vehicleType['rate'] ?? 0,
                  vehicleType['available_slots'] ?? 0,
                  () {}, // Add vehicle function
                ),
              SizedBox(height: 40),
              ActionButton(context, "Park Out", () {}),
            ],
          ),
        ),
      ),
    );
  }
}
