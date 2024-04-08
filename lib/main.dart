import 'package:flutter/material.dart';
import 'package:parking_kori/view/pages/flash_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  print('enter main........');
  await dotenv.load(fileName: "lib/.env");
  
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: FlashPage(),
  ));
}
