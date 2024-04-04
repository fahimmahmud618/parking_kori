import 'dart:convert';

import 'package:cache_manager/core/read_cache_service.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:parking_kori/view/pages/add_vehicle.dart';
import 'package:sunmi_printer_plus/column_maker.dart';
import 'package:sunmi_printer_plus/enums.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
import 'package:sunmi_printer_plus/sunmi_style.dart';

class Sunmi {
  // initialize sunmi printer
  Future<void> initialize() async {
    await SunmiPrinter.bindingPrinter();
    await SunmiPrinter.initPrinter();
    await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
  }

  // print image
  Future<void> printLogoImage() async {
    await SunmiPrinter.lineWrap(1); // creates one line space
    Uint8List byte = await _getImageFromAsset('asset/image/pklogo.png');
    await SunmiPrinter.printImage(byte);
    await SunmiPrinter.lineWrap(1); // creates one line space
  }

  Future<Uint8List> readFileBytes(String path) async {
    ByteData fileData = await rootBundle.load(path);
    Uint8List fileUnit8List = fileData.buffer
        .asUint8List(fileData.offsetInBytes, fileData.lengthInBytes);
    return fileUnit8List;
  }

  Future<Uint8List> _getImageFromAsset(String iconPath) async {
    return await readFileBytes(iconPath);
  }

  Future<void> printText(String text) async {
    await SunmiPrinter.lineWrap(1); // creates one line space
    await SunmiPrinter.printText(text,
        style: SunmiStyle(
          fontSize: SunmiFontSize.MD,
          bold: true,
          align: SunmiPrintAlign.CENTER,
        ));
    await SunmiPrinter.lineWrap(1); // creates one line space
  }

 
  Future<void> printQRCode(String text) async {
    // set alignment center
    await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
    // await SunmiPrinter.lineWrap(1); // creates one line space
    await SunmiPrinter.printQRCode(text);
    // await SunmiPrinter.lineWrap(4); // creates one line space
  }

  // print row and 2 columns
  Future<void> printRowAndColumns(
      {String? column1 = "column 1",
      String? column2 = "column 2",
      String? column3 = "column 3"}) async {

    // set alignment center
    await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);

    // prints a row with 3 columns
    // total width of columns should be 30
    await SunmiPrinter.printRow(cols: [
      ColumnMaker(
        text: "$column1",
        width: 10,
        align: SunmiPrintAlign.LEFT,
      ),
      ColumnMaker(
        text: "$column2",
        width: 10,
        align: SunmiPrintAlign.CENTER,
      ),
      ColumnMaker(
        text: "$column3",
        width: 10,
        align: SunmiPrintAlign.RIGHT,
      ),
    ]);
    await SunmiPrinter.lineWrap(1); // creates one line space
  }

  /* its important to close the connection with the printer once you are done */
  Future<void> closePrinter() async {
    await SunmiPrinter.unbindingPrinter();
  }

  // print one structure
  Future<void> printReceipt(String bookingNumber) async {
    String authToken = await ReadCache.getString(key: "token");

    // Make an HTTP GET request to the backend API endpoint
    final response = await http.get(
      Uri.parse(
          'https://parking-kori.rpu.solutions/api/v1/get-booking?booking_number=$bookingNumber'),
      headers: <String, String>{
        'Authorization': 'Bearer $authToken',
      },
    );

    if (response.statusCode == 200) {
      // Parse the JSON response
      final Map<String, dynamic> data = json.decode(response.body);
      final bookingDetails = data['booking'][0];

      // Extract the required information
      String vehicleRegNumber = bookingDetails['vehicle_reg_number'];
      String parkInTime = bookingDetails['park_in_time'];
      String address = bookingDetails['location']['address'];

      // Initialize and print receipt
      await initialize();
      await printLogoImage();
      await printText("PARKING - Entry Receipt");
      await printText("Vehicle Registration Number: $vehicleRegNumber");
      await printText("Park In Time: $parkInTime");
      await printText("Address: $address");
      await printQRCode(bookingNumber);
      await printText("Developed by: Parking Kori");
      await closePrinter();
    } else {
      throw Exception('Failed to load booking details');
    }
  }
}
