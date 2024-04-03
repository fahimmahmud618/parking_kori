import 'dart:async';
import 'package:cache_manager/cache_manager.dart';
import 'package:flutter/material.dart';
import 'package:parking_kori/view/image_file.dart';
import 'package:parking_kori/view/pages/login_page.dart';
import 'package:parking_kori/view/pages/main_page.dart';
import 'package:parking_kori/view/styles.dart';
import 'package:parking_kori/view/widgets/alert_dialog.dart';

class FlashPage extends StatefulWidget {
  const FlashPage({super.key});

  @override
  State<FlashPage> createState() => _FlashPageState();
}

class _FlashPageState extends State<FlashPage> {

  Future initiateChache() async{
    CacheManagerUtils.conditionalCache(
        key: "cache",
        valueType: ValueType.StringValue,
        actionIfNull: (){
          myAlertDialog("Info", "No data found, please log in", context);
          Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));
        },
        actionIfNotNull: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>MainPage()));
        }
    );
  }

  @override
  void initState() {
    Timer(Duration(seconds: 2),initiateChache);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: Center(child: Image.asset(pkLogonamed, width: get_screenWidth(context)*0.45,)
      ),
    ));
  }
}