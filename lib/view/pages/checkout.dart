import 'package:flutter/material.dart';
import 'package:parking_kori/view/pages/home_page.dart';
import 'package:parking_kori/view/pages/main_page.dart';
import 'package:parking_kori/view/styles.dart';
import 'package:parking_kori/view/widgets/action_button.dart';
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
  late String exit_time;
  late String ticket_num;
  late double payment_amount;

  void load_data(String bookingNum){
    
    DateTime currentTime = DateTime.now();

    registration_num="2212";
    entry_time="11:43 am";
    exit_time= formatDate(currentTime);
    ticket_num="112-112-223-333";
    payment_amount=150;
  }

  String formatDate(DateTime dateTime) {
    // Format the time as "hh:mm a" (12-hour format with AM/PM)
    String formattedTime = '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')} ${dateTime.hour < 12 ? 'am' : 'pm'}';

    // Adjust hours for 12-hour format
    if (dateTime.hour == 0) {
      formattedTime = '12:$formattedTime';
    } else if (dateTime.hour > 12) {
      formattedTime = '${dateTime.hour - 12}:$formattedTime';
    }

    return formattedTime;
  }

  void checkout(){
    //TODO save in db
    Navigator.push(context, MaterialPageRoute(builder: (context)=>MainPage()));
  }

  @override
  void initState() {
    load_data(widget.booking_num);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: Container(
        padding: EdgeInsets.all( get_screenWidth(context) * 0.1),
        child: Column(
          children: [
            AppBarWidget(context, "Checkout"),
            Expanded(
              child: Center(
                child: Column(
                  children: [
                    DashboardInfoCard(context, "Registration Num", registration_num),
                    DashboardInfoCard(context, "Ticket Num", ticket_num),
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
    ));
  }
}
