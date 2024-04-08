import 'package:flutter/material.dart';
import 'package:parking_kori/view/pages/flash_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async{
  await dotenv.load(fileName: ".env");
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: FlashPage(),
  ));
}


