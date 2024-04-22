import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:parking_kori/view/pages/checkout.dart';
import 'package:parking_kori/view/styles.dart';
import 'package:parking_kori/view/widgets/back_button.dart';
import 'package:barcode_scan2/barcode_scan2.dart';

class ParkOut extends StatefulWidget {
  const ParkOut({Key? key}) : super(key: key);

  @override
  State<ParkOut> createState() => _ParkOutState();
}

class _ParkOutState extends State<ParkOut> {
  bool isQRScanned = false;
  String booking_num = "";

  @override
  void initState() {
    super.initState();
    _scan(); // Start scanning when the widget is initialized
  }

  void goBack() {
    Navigator.pop(context);
  }

  Future<void> _scan() async {
  try {
    final result = await BarcodeScanner.scan(
      options: ScanOptions(
        autoEnableFlash: true, // Enable flashlight automatically
      ),
    );
    setState(() {
      isQRScanned = true;
      booking_num = result.rawContent;
    });
    // Handle further processing or navigation here
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => CheckOutPage(booking_num: booking_num),
      ),
    );
  } catch (e) {
    // Handle any errors here
    print('Error while scanning: $e');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                get_screenWidth(context) * 0.1,
                get_screenWidth(context) * 0.1,
                0,
                0,
              ),
              child: BackOption(context, goBack),
            ),
            SizedBox(
              height: get_screenWidth(context) * 0.05,
            ),
            isQRScanned
                ? Text("")
                : Container(
                    height: 300, // Adjust the height as needed
                    width: 300, // Adjust the width as needed
                    child: MobileScanner(
                      controller: MobileScannerController(
                        detectionSpeed: DetectionSpeed.noDuplicates,
                        returnImage: true,
                      ),
                      onDetect: (capture) {
                        final List<Barcode> barcodes = capture.barcodes;
                        final Uint8List? image = capture.image;
                        for (final barcode in barcodes) {
                          print('Barcode Found! ${barcode.rawValue}');
                        }
                        setState(() {
                          booking_num = barcodes.first.rawValue!;
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CheckOutPage(booking_num: booking_num),
                          ),
                        );
                        if (image != null) {}
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
