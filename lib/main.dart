import 'dart:io';

import 'package:flutter/material.dart';
import 'package:parking_kori/printing/bluetooth.dart';
import 'package:parking_kori/view/pages/flash_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:parking_kori/view/styles.dart';
import 'package:parking_kori/view/pages/checkout.dart';

void main() async {
  await dotenv.load(fileName: "lib/.env");
  HttpOverrides.global = MyHttpOverrides();
  runApp(MaterialApp(
    theme: ThemeData(
      primaryColor: myred, 
    ),
    debugShowCheckedModeBanner: false,
    home: FlashPage(),
  ));
}
