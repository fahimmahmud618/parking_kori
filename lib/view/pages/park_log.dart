import 'package:flutter/material.dart';
import 'package:parking_kori/model/booking.dart';
import 'package:parking_kori/view/styles.dart';
import 'package:parking_kori/view/widgets/appbar.dart';
import 'package:parking_kori/view/widgets/page_title.dart';
import 'package:parking_kori/view/widgets/park_log_history_card.dart';

class ParkLog extends StatefulWidget {
  const ParkLog({super.key});

  @override
  State<ParkLog> createState() => _ParkLogState();
}

class _ParkLogState extends State<ParkLog> {
  late List<Booking> bookings;

  @override
  void initState() {
    bookings = [
      new Booking("1", "Car", "1134", "11:34 am", "2:04 pm", false),
      new Booking("2", "Car", "1034", "10:34 am", "2:04 pm", true),
      new Booking("3", "Bike", "2314", "11:22 am", "2:04 pm", true),
      new Booking("4", "Cycle", "7434", "9:14 am", "2:04 pm", false),
      new Booking("5", "CNG", "5023", "10:30 am", "2:04 pm", true),
      new Booking("5", "Car", "3221", "8:30 am", "2:04 pm", false),
    ];
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                AppBarWidget(context),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: get_screenWidth(context)*0.1),
                  child: Column(
                    children: [
                      PageTitle(context," Park Log"),
                      Column(
                        children: bookings.map((e) => ParkLogHistoryCard(context, e)).toList(),
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),
      )
    );
  }
}
