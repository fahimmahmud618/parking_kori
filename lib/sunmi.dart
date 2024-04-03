import 'package:flutter/services.dart';
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
    Uint8List byte = await _getImageFromAsset('assets/flutter_black_white.png');
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

  // print text as qrcode
  Future<void> printQRCode(String text) async {
    // set alignment center
    await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
    await SunmiPrinter.lineWrap(1); // creates one line space
    await SunmiPrinter.printQRCode(text);
    // await SunmiPrinter.lineWrap(4); // creates one line space
  }

  // print row and 2 columns
  Future<void> printRowAndColumns(
      {String? column1 = "column 1",
      String? column2 = "column 2",
      String? column3 = "column 3"}) async {
    await SunmiPrinter.lineWrap(1); // creates one line space

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
  Future<void> printReceipt(String booking_num) async {
    await initialize();
    // await printLogoImage();
    await printText("PARKING - Entry Receipt");
    await printText("Vehicle: Toyota Corolla - 255310");
    await printRowAndColumns(
        column1: "Entry", column2: "Time", column3: "10.30 AM");
    await printText("Ticket number - 1234");
    // AddVehicle addVehicle = AddVehicle(vehicleType: 'Bike',);
    await printQRCode(booking_num);
    //await SunmiPrinter.cut();
    await printText("Developed by: Parking Kori");
    await closePrinter();
  }
}
