import 'dart:convert';
import 'dart:io';
import 'package:cache_manager/core/read_cache_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sunmi_printer_plus/enums.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
import 'package:sunmi_printer_plus/sunmi_style.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Sunmi {
  // String? baseUrl = dotenv.env['BASE_URL'];
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
    Uint8List fileUnit8List = fileData.buffer
        .asUint8List(fileData.offsetInBytes, fileData.lengthInBytes);
    return fileUnit8List;
  }

  Future<Uint8List> _getImageFromAsset(String iconPath) async {
    return await readFileBytes(iconPath);
  }

  Future<void> printText(String text, {SunmiStyle? style}) async {
    await SunmiPrinter.printText(text,
        style: style ??
            SunmiStyle(
              fontSize: SunmiFontSize.MD,
              bold: false,
              align: SunmiPrintAlign.CENTER,
            ));
  }

  Future<void> printHeadline(String text) async {
    await SunmiPrinter.printText(text,
        style: SunmiStyle(
          fontSize: SunmiFontSize.LG,
          bold: true,
          align: SunmiPrintAlign.CENTER,
        ));
  }

  Future<void> printQRCode(String text) async {
    await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
    await SunmiPrinter.lineWrap(1);
    await SunmiPrinter.printQRCode(text);
  }

  Future<void> printReceipt(String bookingNumber) async {
    try {
      String authToken = await ReadCache.getString(key: "token");
      String? baseUrl = dotenv.env['BASE_URL'];

      final client = HttpClient();
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) =>
              true; // Bypass SSL certificate verification
      final request = await client.getUrl(
        Uri.parse('$baseUrl/get-booking?booking_number=$bookingNumber'),
      );
      request.headers.add('Authorization', 'Bearer $authToken');
      final response = await request.close();

      if (response.statusCode == 200) {
        print('Booking details fetched successfully');
        final String responseBody =
            await response.transform(utf8.decoder).join();
        final Map<String, dynamic> data = json.decode(responseBody);

        if (data.containsKey('booking')) {
          final Map<String, dynamic> bookingDetails = data['booking']['data'][0];

          // Extract booking details
          String vehicleRegNumber = bookingDetails['vehicle_reg_number'] ?? '';
          String parkInTime = bookingDetails['park_in_time'] ?? '';
          String address = bookingDetails['location']['title'] ?? '';
          String num = bookingDetails['booking_number'] ?? '';
          String vehicleType = bookingDetails['vehicle_type']['title'] ?? '';

          // Print the extracted booking details for debugging
          print('Vehicle Reg Number: $vehicleRegNumber');
          print('Park In Time: $parkInTime');
          print('Address: $address');
          print('Booking Number: $num');
          print('Vehicle Type: $vehicleType');

          // Proceed with printing
          await initialize();
          await printHeadline(" $address");
          await printText("PARKING Entry Receipt");
          await printText("$vehicleType: $vehicleRegNumber");
          await printText("Entry: $parkInTime");
          await printText("Ticket No: $num");
          await printQRCode(num);
          // Print additional information
          await printText("Developed by ParkingKori.com",
              style: SunmiStyle(
                fontSize: SunmiFontSize.MD,
                bold: true,
                align: SunmiPrintAlign.CENTER,
              ));
          await printText("   ");
          await printText("   ");
          await printText("   ");
          await closePrinter();
        } else {
          throw Exception('Invalid or empty booking data');
        }
      } else {
        throw Exception(
            'Failed to fetch booking details. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching booking details: $e');
    }
  }

  Future<void> printInvoice(
      String registration_num,
      String entry_time,
      String exit_time,
      String ticket_num,
      String payment_amount,
      String location,
      String address,
      String vehicleType,
      String vehicleRegNumber,
      String duration) async {
    await initialize();
    await printHeadline(location);
    await printText("PARKING Exit Receipt");
    await printText("Entry: $entry_time");
    await printText("Exit: $exit_time");
    await printText("$vehicleType: $vehicleRegNumber");
    await printHeadline("Parking Bill: $payment_amount");
    await printText("Ticket No: $registration_num");
     await printText("Duration: $duration");

    await printText("Developed by ParkingKori.com",
        style: SunmiStyle(
          fontSize: SunmiFontSize.MD,
          bold: true,
          align: SunmiPrintAlign.CENTER,
        ));
    // await printText("   ");
    await printText("   ");
    await printText("   ");
    await printText("   ");

    await closePrinter();
  }

  String formatDateTime(DateTime dateTime) {
    DateTime time = DateTime.now();
    String formattedDate = '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    String hour = (time.hour > 12)
        ? (time.hour - 12).toString()
        : time.hour.toString();
    String minute = time.minute.toString().padLeft(2, '0');
    String amPm = (time.hour >= 12) ? 'PM' : 'AM';
    String formattedTime = '$hour:$minute $amPm';
    return '$formattedDate $formattedTime';
  }

  Future<void> print_summary(
      String total_park_in,
      String total_park_out,
      String total_income,
      DataTable dataTable,
      DateTime dateTime,
      String address) async {
    // Your existing printing logic here
    await initialize();
    await printHeadline("$address");
    await printText(formatDateTime(dateTime));
    await printText("Total Park In: $total_park_in");
    await printText("Total Park Out: $total_park_out");
    
    await printText("Agent Name & Income");

    // Printing DataTable as a table
    List<List<String>> tableData = [];

// Extracting cell data and formatting as table rows
    for (var row in dataTable.rows) {
      List<String> rowData = [];
      for (var cell in row.cells) {
        // Extracting cell data and formatting
        String cellText =
            (cell.child as Text).data ?? ''; // Extract text from Text widget
        // Limit cell text to 10 characters and truncate with '...'
        cellText =
            cellText.length > 10 ? cellText.substring(0, 7) + '...' : cellText;
        rowData.add(cellText.padRight(
            10)); // Pad right with spaces to ensure a fixed length of 10 characters
      }
      tableData.add(rowData);
    }

// Printing table
    for (var rowData in tableData) {
      String rowString = rowData.join(' | '); // Join cells with ' | ' separator
      await printText(rowString);
    }

    // await printText(''); // Empty line after table

    await printText("Total Income: $total_income");
    await printText("Developed by ParkingKori.com",
        style: SunmiStyle(
          fontSize: SunmiFontSize.MD,
          bold: true,
          align: SunmiPrintAlign.CENTER,
        ));
    await printText("   ");
    await printText("   ");
    await printText("   ");

    await closePrinter(); // Empty string to create a new line
  }

  Future<void> closePrinter() async {
    await SunmiPrinter.unbindingPrinter();
  }
}
