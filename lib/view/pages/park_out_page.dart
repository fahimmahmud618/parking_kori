import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:parking_kori/view/pages/checkout.dart';
import 'package:parking_kori/view/styles.dart';
import 'package:parking_kori/view/widgets/back_button.dart';

class ParkOut extends StatefulWidget {
  const ParkOut({super.key});

  @override
  State<ParkOut> createState() => _ParkOutState();
}

class _ParkOutState extends State<ParkOut> {
  bool isQRScanned = false;
  String booking_num = "";

  void scanQR_and_retrive_data() {
    // Navigator.push(context, MaterialPageRoute(builder: (context)=>ScanQR()));
    setState(() {
      isQRScanned = true;
    });
  }

  void go_back() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(get_screenWidth(context) * 0.1,
                  get_screenWidth(context) * 0.1, 0, 0),
              child: BackOption(context, go_back),
            ),
            isQRScanned
                ? Text("")
                : Expanded(
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
                                    CheckOutPage(booking_num: booking_num)));
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
