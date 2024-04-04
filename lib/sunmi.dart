import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cache_manager/core/read_cache_service.dart';
import 'package:flutter/services.dart';
import 'package:sunmi_printer_plus/enums.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
import 'package:sunmi_printer_plus/sunmi_style.dart';

class Sunmi {
  Future<void> initialize() async {
    await SunmiPrinter.bindingPrinter();
    await SunmiPrinter.initPrinter();
    await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
  }

  Future<void> printLogoImage() async {
    await SunmiPrinter.lineWrap(1);
    Uint8List byte = await _getImageFromAsset('asset/image/pklogo.png');
    await SunmiPrinter.printImage(byte);
    await SunmiPrinter.lineWrap(1);
  }

  Future<Uint8List> readFileBytes(String path) async {
    ByteData fileData = await rootBundle.load(path);
    Uint8List fileUnit8List = fileData.buffer.asUint8List(fileData.offsetInBytes, fileData.lengthInBytes);
    return fileUnit8List;
  }

  Future<Uint8List> _getImageFromAsset(String iconPath) async {
    return await readFileBytes(iconPath);
  }

  Future<void> printText(String text) async {
    await SunmiPrinter.lineWrap(1);
    await SunmiPrinter.printText(text, style: SunmiStyle(
      fontSize: SunmiFontSize.MD,
      bold: true,
      align: SunmiPrintAlign.CENTER,
    ));
    // await SunmiPrinter.lineWrap(1);
  }
  Future<void> printHeadline(String text) async {
    await SunmiPrinter.lineWrap(1);
    await SunmiPrinter.printText(text, style: SunmiStyle(
      fontSize: SunmiFontSize.LG,
      bold: true,
      align: SunmiPrintAlign.CENTER,
    ));
    // await SunmiPrinter.lineWrap(1);
  }

  Future<void> printQRCode(String text) async {
    await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
    print(text);
    print("------------------");
    await SunmiPrinter.lineWrap(1);
    await SunmiPrinter.printQRCode(text);
  }

  Future<void> printReceipt(String bookingNumber) async {
    String authToken = await ReadCache.getString(key: "token");
    print("Printing function called");

    try {
      // Make an HTTP GET request to the backend API endpoint
      final client = HttpClient();
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true; // Bypass SSL certificate verification
      final request = await client.getUrl(
        Uri.parse('https://parking-kori.rpu.solutions/api/v1/get-booking?booking_number=$bookingNumber'),
      );
      request.headers.add('Authorization', 'Bearer $authToken');
      final response = await request.close();
      
      print(response.statusCode);
      print("WHY ERROR");
      
      if (response.statusCode == 200) {
        final String responseBody = await response.transform(utf8.decoder).join();
        final Map<String, dynamic> data = json.decode(responseBody);
        final bookingDetails = data['booking'][0];
        print('Booking details: $bookingDetails');

        if (bookingDetails != null) {
          String vehicleRegNumber = bookingDetails['vehicle_reg_number'] ?? '';
          String parkInTime = bookingDetails['park_in_time'] ?? '';
          String address = bookingDetails['location']['address'] ?? '';
          String num = bookingDetails['booking_number'] ?? '';
          String vehicleType = bookingDetails['vehicle_type']['title'] ?? ''; 

          await initialize();
          // await printLogoImage();
          await printHeadline(" $address");
          await printHeadline("PARKING Entry Receipt");
          await printText("{$vehicleType}: $vehicleRegNumber");
          await printText("Entry: $parkInTime");
          await printText("Ticket No: $num");
          await printQRCode(num);
          await printText("Developed by ParkingKori");
          await printText("");
          await closePrinter();
        } else {
          throw Exception('Booking details not found');
        }
      } else {
        throw Exception('Failed to load booking details');
      }
    } catch (e) {
      print('Error fetching booking details: $e');
    }
  }

  Future<void> closePrinter() async {
    await SunmiPrinter.unbindingPrinter();
  }
}
