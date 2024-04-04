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
  String registration_num = '';
  String entry_time = '';
  String exit_time = '';
  String ticket_num = '';
  String payment_amount = '';

  void load_data(String bookingNum) async {
    print("kireeeee----------------------------------------");
    try {
      String url = 'https://parking-kori.rpu.solutions/api/v1/park-out';
      String token = await ReadCache.getString(key: "token");
      print(bookingNum);

      Map<String, dynamic> requestData = {
        "booking_number": bookingNum,
      };

      // print(jsonEncode(requestData));

      http.Response response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(requestData),
      );
      if (response.statusCode == 200) {
        print("200 paisee....................................................");
        Map<String, dynamic> responseData = jsonDecode(response.body);
        setState(() {
          registration_num = responseData['data']['booking_number'];
          entry_time = responseData['data']['park_in_time'];
          exit_time = responseData['data']['park_out_time'];
          ticket_num = responseData['data']['invoice_number'];
          payment_amount = responseData['data']['sub_total'].toString();
          print(registration_num + entry_time + exit_time + payment_amount);
        });
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
          child: Column(
            children: [
              AppBarWidget(context, "Checkout"),
              Container(
                padding: EdgeInsets.all(get_screenWidth(context)*0.05),
                child: Expanded(
                  child: Center(
                    child: Column(
                      children: [
                        DashboardInfoCard(
                            context, "Booking Number", registration_num),
                        DashboardInfoCard(context, "Invoice Number", ticket_num),
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
