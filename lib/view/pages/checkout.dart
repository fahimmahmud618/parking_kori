import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:parking_kori/sunmi.dart';
import 'package:parking_kori/view/pages/main_page.dart';
import 'package:parking_kori/view/styles.dart';
import 'package:parking_kori/view/widgets/action_button.dart';
import 'package:parking_kori/view/widgets/appbar.dart';
import 'package:parking_kori/view/widgets/dashboard_info_card.dart';
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
  String location = '';
  String address = '';

  Future<void> load_data(String bookingNum) async {
    try {
      String url = 'https://parking-kori.rpu.solutions/api/v1/park-out';
      String token = await ReadCache.getString(key: "token");

      // Override the validateCertificate method to bypass SSL certificate validation
      HttpOverrides.global = MyHttpOverrides();

      Map<String, dynamic> requestData = {
        "booking_number": bookingNum,
      };

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
        setState(() {
          registration_num = responseData['data']['booking_number'];
          entry_time = responseData['data']['park_in_time'];
          exit_time = responseData['data']['park_out_time'];
          ticket_num = responseData['data']['invoice_number'];
          payment_amount = responseData['data']['sub_total'].toString();
        });
      } else {
        print('Failed to CHECKOUT. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending CHECKOUT request: $e');
    }
  }

  Future<void> load_invoice_data(String bookingNum) async {
    try {
      String url =
          'https://parking-kori.rpu.solutions/api/v1/get-booking?booking_number=$bookingNum';
      String token = await ReadCache.getString(key: "token");

      HttpOverrides.global = MyHttpOverrides();

      http.Response response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        setState(() {
          location = responseData['booking'][0]['location']['title'];
          address = responseData['booking'][0]['location']['address'];
          print("----------------------------Location: " + location);
        });
      } else {
        print(
            'Failed to FETCH INVOICE DATA. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending FETCH INVOICE DATA request: $e');
    }
  }

  void checkout() {
    Sunmi printer = Sunmi();
    printer.printInvoice(registration_num, entry_time, exit_time, ticket_num,
        payment_amount, location, address);
    print(registration_num);
    print("-----------------------");
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainPage()),
    );
  }

  @override
  void initState() {
    load_data(widget.booking_num);
    load_invoice_data(widget.booking_num);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Column(
            children: [
              AppBarWidget(context, "Checkout"),
              Container(
                padding: EdgeInsets.all(get_screenWidth(context) * 0.05),
                child: Expanded(
                  child: Center(
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom HttpOverrides class to bypass SSL certificate validation
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
