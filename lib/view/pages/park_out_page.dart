import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:parking_kori/model/booking.dart';
import 'package:parking_kori/view/pages/checkout.dart';
import 'package:parking_kori/view/styles.dart';
import 'package:parking_kori/view/widgets/alert_dialog.dart';
import 'package:parking_kori/view/widgets/back_button.dart';

class ParkOut extends StatefulWidget {
  const ParkOut({super.key});

  @override
  State<ParkOut> createState() => _ParkOutState();
}

class _ParkOutState extends State<ParkOut> {
  bool isQRScanned=false;
  String booking_num="";
  double payment_amount=0;
  Booking? vh;

  void scanQR_and_retrive_data(){
    // Navigator.push(context, MaterialPageRoute(builder: (context)=>ScanQR()));
    setState(() {
      // vh = new vehicle_history("001", "DHAKA-GHA-11-12432", "11:23 am", true, "1:22 pm");
      isQRScanned=true;
      payment_amount=150.00;
    });
  }

  void checkout_and_saveinDB(){
    //TODO Sadia: save in db

    myAlertDialog("Parking Koi", "${vh?.registration_number} successfully checked out.", context, );
    // Navigator.pop(context);
  }
  void go_back(){
    Navigator.pop(context);
  }
  @override
  Widget build(BuildContext context) {
    return
        Scaffold(
          body: Container(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(get_screenWidth(context) * 0.1, get_screenWidth(context) * 0.1, 0, 0),
                  child: BackOption(context, go_back),
                ),
                isQRScanned? Text(""): Expanded(
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
                        booking_num= barcodes.first.rawValue!;
                        //TODO is it actually the registration number? I cannot check
                      });
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>CHeckOutPage(booking_num: booking_num)));
                      if (image != null) {
          
                        // showDialog(
                        //   context: context,
                        //   builder: (context) {
                        //     return AlertDialog(
                        //       title: Text(
                        //         barcodes.first.rawValue ?? "",
                        //       ),
                        //       content: Image.memory(image),
                        //     );
                        //   },
                        // );
                      }
                    },
                  ),
                ),
          
              ],
            ),
          
              ),
        );
  }
}
