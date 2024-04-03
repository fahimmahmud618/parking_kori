import 'package:flutter/material.dart';
import 'package:parking_kori/view/styles.dart';
import 'package:parking_kori/view/widgets/appbar.dart';
import 'package:parking_kori/view/widgets/dashboard_info_card.dart';

class DashBoardPage extends StatefulWidget {
  const DashBoardPage({super.key});

  @override
  State<DashBoardPage> createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  late int park_in_titckets;
  late int park_out_titckets;
  late int total_income;
  late int unpaid_tickets;
  late int earning_tobe_billed;

  @override
  void initState() {
    park_in_titckets=23;
    park_out_titckets=18;
    total_income=2200;
    unpaid_tickets=2;
    earning_tobe_billed=400;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppBarWidget(context, "Dashboard"),
          Container(
            padding: EdgeInsets.all( get_screenWidth(context) * 0.1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DashboardInfoCard(context, "Parked In tickets", park_in_titckets.toString()),
                DashboardInfoCard(context, "Parked Out tickets", park_out_titckets.toString()),
                DashboardInfoCard(context, "Total Income", total_income.toString()),
                DashboardInfoCard(context, "Unpaid Titckets", unpaid_tickets.toString()),
                DashboardInfoCard(context, "Earning to be Billed", earning_tobe_billed.toString()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
