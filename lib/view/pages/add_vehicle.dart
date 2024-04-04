// ignore_for_file: non_constant_identifier_names, use_super_parameters

import 'package:cache_manager/core/read_cache_service.dart';
import 'package:flutter/material.dart';
import 'package:parking_kori/sunmi.dart';
import 'package:parking_kori/view/image_file.dart';
import 'package:parking_kori/view/styles.dart';
import 'package:parking_kori/view/widgets/action_button.dart';
import 'package:parking_kori/view/widgets/back_button.dart';
import 'package:parking_kori/view/widgets/input_with_icon_image.dart';
import 'package:parking_kori/view/widgets/page_title.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AddVehicle extends StatefulWidget {
  final String vehicleType;

  const AddVehicle({Key? key, required this.vehicleType}) : super(key: key);

  @override
  State<AddVehicle> createState() => _AddVehicleState();
}

class _AddVehicleState extends State<AddVehicle> {
  bool isQRGenerated = false;
  String booking_num = "";
  String token = '';
  int id = 0;
  int locationId = 0;
  // String vehicleType
  TextEditingController registrationnumber = new TextEditingController();

  void generate_qr_and_print(String r) {
    send_registration_number_and_get_booking_number(r);
    setState(() {
      isQRGenerated = true;
    });
    Sunmi printer = Sunmi();
    printer.printReceipt(booking_num);
  }

  void go_back() {
    Navigator.pop(context);
  }

  void send_registration_number_and_get_booking_number(String r) async {
    try {
      String url = 'https://parking-kori.rpu.solutions/api/v1/new-booking';
      String registrationNumber = r;
      token = await ReadCache.getString(key: "token");
      id = await ReadCache.getInt(key: "id");
      locationId = await ReadCache.getInt(key: "locationId");

      print(widget.vehicleType);

      // Request body data
      Map<String, dynamic> requestData = {
        "vehicle_type": widget.vehicleType,
        "car_reg": registrationNumber,
        "agent_id": id.toString(),
        "location": locationId.toString()
      };

      // Send POST request to backend with the bearer token in headers
      http.Response response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        String bookingNumber = responseData['booking']['booking_number'];
        print("Booking ID: $bookingNumber");

        setState(() {
          booking_num = bookingNumber;
        });
      } else {
        // Request failed
        print(
            'Failed to send registration number. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Exception occurred
      print('Error sending registration number: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        // Wrap with SingleChildScrollView
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(get_screenWidth(context) * 0.1,
                  get_screenWidth(context) * 0.1, 0, 0),
              child: BackOption(context, go_back),
            ),
            SizedBox(
              height: get_screenWidth(context)*0.05,
            ),
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: get_screenWidth(context) * 0.1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PageTitle(context, "Add Vehicle"),
                    InputWIthIconImage(
                        context,
                        editLogo,
                        registrationnumber,
                        "Registration Number",
                        "Write the registration number of vehicle",
                        false),
                    ActionButton(context, "Generate QR and PrintOut",
                        () => generate_qr_and_print(registrationnumber.text)),
                    isQRGenerated
                        ? Container(
                            height: 80,
                            width: 80,
                            child: PrettyQr(
                              data: booking_num,
                              size: 200,
                              roundEdges: true,
                              elementColor: Colors.black,
                              typeNumber: 3,
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
