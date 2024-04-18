import 'package:flutter/material.dart';
import 'package:parking_kori/view/pages/flash_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:parking_kori/view/styles.dart';

void main() async {
  await dotenv.load(fileName: "lib/.env");
  
  runApp( MaterialApp(
    theme: ThemeData(
      primaryColor: myred, // Change the primary color to red
      // You can also customize other theme properties here
    ),
    debugShowCheckedModeBanner: false,

    home: FlashPage(),
  ));
}
