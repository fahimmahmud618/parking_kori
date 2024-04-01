import 'package:flutter/material.dart';
import 'package:parking_kori/view/image_file.dart';
import 'package:parking_kori/view/styles.dart';
import 'package:parking_kori/view/widgets/action_button.dart';
import 'package:parking_kori/view/widgets/back_button.dart';
import 'package:parking_kori/view/widgets/input_with_icon_image.dart';
import 'package:parking_kori/view/widgets/page_title.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class AddVehicle extends StatefulWidget {
  final String vehicleType; // Define a variable to hold the vehicle type

  const AddVehicle({Key? key, required this.vehicleType}) : super(key: key);

  @override
  State<AddVehicle> createState() => _AddVehicleState();
}

class _AddVehicleState extends State<AddVehicle> {
  bool isQRGenerated = false;
  TextEditingController registrationnumber = new TextEditingController();

  void generate_qr_and_print(){
    setState(() {
      isQRGenerated=true;
    });
  }

  void go_back(){
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(get_screenWidth(context) * 0.1, get_screenWidth(context) * 0.1, 0, 0),
            child: BackOption(context, go_back),
          ),
          Expanded(
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: get_screenWidth(context) * 0.1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PageTitle(context, "Add Vehicle"),
                    InputWIthIconImage(context, userLogo, registrationnumber, "Registration Number", "Write the registration number of vehicle", false),
                    ActionButton(context, "Generate QR and PrintOut", generate_qr_and_print),
                    isQRGenerated ? Container(
                      height: 80,
                      width: 80,
                      child: PrettyQr(
                        data: registrationnumber.text,
                        size: 200,
                        roundEdges: true,
                        elementColor: Colors.black,
                        typeNumber: 3,
                      ),
                    ) : Container(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
