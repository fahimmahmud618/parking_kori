// ignore_for_file: non_constant_identifier_names, unused_local_variable

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:parking_kori/view/pages/main_page.dart';
import 'package:parking_kori/view/styles.dart';
import 'package:parking_kori/view/widgets/action_button.dart';
import 'package:parking_kori/view/widgets/appbar.dart';
import 'package:parking_kori/view/widgets/dashboard_info_card.dart';
import 'package:cache_manager/core/read_cache_service.dart';

class CheckOutPage extends StatefulWidget {
  const CheckOutPage({super.key, required this.booking_num});
  final String booking_num;

  @override
  State<CheckOutPage> createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  late String registration_num;
  late String entry_time;
  late String exit_time;
  late String ticket_num;
  late double payment_amount;

  void load_data(String bookingNum) async {
    try {
      String url = 'https://parking-kori.rpu.solutions/api/v1/park-out';
      String token = await ReadCache.getString(key: "token");

      Map<String, dynamic> requestData = {
        "booking_num": bookingNum,
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
        String registration_num = responseData['data']['booking_number'];
        String entry_time = responseData['data']['park_in_time'];
        String exit_time = responseData['data']['park_out_time'];
        String ticket_num = responseData['data']['invoice_number'];
        String payment_amount = responseData['data']['sub_total'];
      } else {
        // Request failed
        print('Failed to CHECKOUT. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Exception occurred
      print('Error sending CHECKOUT request: $e');
    }
  }

  void checkout() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MainPage()));
  }

  @override
  void initState() {
    load_data(widget.booking_num);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        padding: EdgeInsets.all(get_screenWidth(context) * 0.1),
        child: Column(
          children: [
            AppBarWidget(context, "Checkout"),
            Expanded(
              child: Center(
                child: Column(
                  children: [
                    DashboardInfoCard(context, "Booking Number", registration_num),
                    DashboardInfoCard(context, "Invoice Number", ticket_num),
                    DashboardInfoCard(context, "Arrived At", entry_time),
                    DashboardInfoCard(context, "Exit At", exit_time),
                    DashboardInfoCard(context, "Payable Amount", payment_amount.toString()),
                    ActionButton(context, "Checkout", checkout),
                  ],
                ),
              ),
            ),
        ],
    ),
      ),
    ),);
  }
}
