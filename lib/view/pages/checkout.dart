import 'package:flutter/material.dart';
import 'package:parking_kori/view/widgets/appbar.dart';
import 'package:parking_kori/view/widgets/dashboard_info_card.dart';

class CHeckOutPage extends StatefulWidget {
  const CHeckOutPage({super.key, required this.booking_num});
  final String booking_num;

  @override
  State<CHeckOutPage> createState() => _CHeckOutPageState();
}

class _CHeckOutPageState extends State<CHeckOutPage> {
  late String registration_num;
  late String entry_time;
  late String ticket_num;

  void get_data(String bookingNum){
    registration_num="2212";
    entry_time="11:43 am";
    ticket_num="112-112-223-333";

  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: Container(
        child: Column(
          children: [
            AppBarWidget(context, "Checkout"),
            Expanded(
              child: Center(
                child: Column(
                  children: [
                    DashboardInfoCard(context, "Registration Num", registration_num),
                    DashboardInfoCard(context, "Arrived At", entry_time),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
