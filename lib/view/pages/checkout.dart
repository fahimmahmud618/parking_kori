// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:parking_kori/sunmi.dart';
import 'package:parking_kori/view/pages/main_page.dart';
import 'package:parking_kori/view/styles.dart';
import 'package:parking_kori/view/widgets/action_button.dart';
import 'package:parking_kori/view/widgets/appbar.dart';
import 'package:parking_kori/view/widgets/dashboard_info_card.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cache_manager/core/read_cache_service.dart';

class CheckOutPage extends StatefulWidget {
  const CheckOutPage({Key? key, required this.booking_num}) : super(key: key);
  final String booking_num;

  @override
  State<CheckOutPage> createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  String registration_num = '';
  String entry_time = '';
  String exit_time = '';
  String ticket_num = '';
  String payment_amount = '';
  String vehicle_reg_number = '';
  String vehicle_type = '';
  String location = '';
  String address = '';
  String? baseUrl = dotenv.env['BASE_URL'];
  // String token = await ReadCache.getString(key: "token");
  //   print("Booking num in checkout page: " + bookingNum);

  Future<void> load_data(String bookingNum) async {
    // String url = '$baseUrl/park-out';
    print("Loading data for booking number: $bookingNum");
    String token = await ReadCache.getString(key: "token");

    try {
      http.Response response = await http.get(
        Uri.parse('$baseUrl/checkout/summary?booking_number=$bookingNum'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);

        setState(() {
          registration_num = responseData['data']['booking_number'] ?? '';
          vehicle_reg_number = responseData['data']['booking']['vehicle_reg_number'] ?? '';
          vehicle_type = responseData['data']['vehicle_type'] ?? '';
          entry_time = responseData['data']['park_in_time'] ?? '';
          exit_time = responseData['data']['park_out_time'] ?? '';
          ticket_num = responseData['data']['invoice_number'] ?? '';
          payment_amount = responseData['data']['sub_total'].toString();
        });
        

        // Fetch additional data after successful checkout
        await fetchInvoiceData(bookingNum, token);
      } else {
        print(
            'Failed to FETCH CHECKOUT DETAILS. Status code: ${response.statusCode}');
        // If there's an error, show the error dialog
        showErrorDialog("ERROR",
            "Failed to FETCH CHECKOUT DETAILS. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print('Error sending FETCH CHECKOUT DETAILS request: $e');
      // If there's an error, show the error dialog
      showErrorDialog(
          "ERROR", "Error sending FETCH CHECKOUT DETAILS request: $e");
    }
  }

  Future<void> fetchInvoiceData(String bookingNum, String token) async {
    String url = '$baseUrl/checkout/summary?booking_number=$bookingNum';

    try {
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);

        // Check if the response contains the necessary data
        if (responseData.containsKey('data') &&
            responseData['data'] is Map<String, dynamic>) {
          Map<String, dynamic> data = responseData['data'];

          setState(() {
            if (data['booking'] != null) {
              var bookingData = data['booking'];
              if (bookingData['location'] != null) {
                var locationData = bookingData['location'];
                location = locationData['title'] ?? '';
                address = locationData['address'] ?? '';
              }
            } else {
              // Handle case where booking data is null
              print('Booking data is null.');
              showErrorDialog("ERROR", "Booking data is null.");
            }
          });
        } else {
          print('Invalid response format: missing or invalid data');
          showErrorDialog("ERROR", "Invalid response format.");
        }
      } else {
        print(
            'Failed to FETCH INVOICE DATA. Status code: ${response.statusCode}');
        showErrorDialog("ERROR",
            "Failed to FETCH INVOICE DATA. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print('Error sending FETCH INVOICE DATA request: $e');
      showErrorDialog("ERROR", "Error sending FETCH INVOICE DATA request: $e");
    }
  }

  void checkout() async {
    // String token = await ReadCache.getString(key: "token");

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: myred,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Text("Confirm Checkout",
                    style: nameTitleStyle(context, myWhite)),
              ),
            ],
          ),
          content: Text("Are you sure you want to checkout?",
              style: normalTextStyle(context, myWhite)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                performCheckout(); // Proceed with checkout
              },
              child: Text("Yes", style: normalTextStyle(context, myWhite)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text("No", style: normalTextStyle(context, myWhite)),
            ),
          ],
        );
      },
    );
  }

  void performCheckout() async {
  String url = '$baseUrl/park-out';
  String token = await ReadCache.getString(key: "token");

  try {
    http.Response response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({"booking_number": widget.booking_num}),
    );

    if (response.statusCode == 200) {
      // Handle success
      print('Checkout successful');
      // Optionally, navigate to a success page or do other actions
      Sunmi printer = Sunmi();
      printer.printInvoice(
        registration_num,
        entry_time,
        exit_time,
        ticket_num,
        payment_amount,
        location,
        address,
        vehicle_reg_number,
        vehicle_type
      );

      // Show toast message
      Fluttertoast.showToast(
        msg: "Thank you for checking out!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        backgroundColor: Color.fromRGBO(65, 176, 110,1),
        textColor: Colors.white,
        fontSize: 16.0,
      );

      // Redirect to MainPage after showing toast
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainPage()),
      );
    } else {
      print(
          'Failed to perform checkout. Status code: ${response.statusCode}');
      // Handle error
    }
  } catch (e) {
    print('Error performing checkout: $e');
    // Handle error
  }
}

  @override
void initState() {
  super.initState();
  print("Booking number: ${widget.booking_num}");
  load_data(widget.booking_num);
}


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            AppBarWidget(context, "Checkout"),
            Container(
              padding: EdgeInsets.all(get_screenWidth(context) * 0.05),
              child: Column(
                children: [
                  DashboardInfoCard(
                      context, "Booking Number", registration_num),
                  DashboardInfoCard(
                      context, "Invoice Number", ticket_num),
                  DashboardInfoCard(context, "Arrived At", entry_time),
                  DashboardInfoCard(context, "Exit At", exit_time),
                  DashboardInfoCard(
                      context, "Payable Amount", payment_amount),
                  ActionButton(context, "Checkout", checkout),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  showErrorDialog(String title, String description) {
    // Create button
    Widget okButton = TextButton(
      child: Text(
        "OK",
        style: normalTextStyle(context, myWhite),
      ),
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainPage()),
        );
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: myred,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nameplate(context),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Text(title, style: nameTitleStyle(context, myWhite)),
          ),
        ],
      ),
      content: Text(
        description,
        style: normalTextStyle(context, myWhite),
      ),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}


class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
