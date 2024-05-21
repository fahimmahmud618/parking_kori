import 'dart:convert';
import 'dart:io';

import 'package:cache_manager/core/read_cache_service.dart';
import 'package:flutter/material.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:parking_kori/view/pages/main_page.dart';
import 'package:parking_kori/view/styles.dart';

class BluetoothPageInvoice extends StatefulWidget {
  final String? registration_num;
  final String? entry_time;
  final String? exit_time;
  final String? ticket_num;
  final String? payment_amount;
  final String? location;
  final String? address;
  final String? vehicleType;
  final String? vehicleRegNumber;
  final String? duration;

  const BluetoothPageInvoice({
    Key? key,
    required this.registration_num,
    required this.entry_time,
    required this.exit_time,
    required this.ticket_num,
    required this.payment_amount,
    required this.location,
    required this.address,
    required this.vehicleType,
    required this.vehicleRegNumber,
    required this.duration,
  }) : super(key: key);

  @override
  _BluetoothPageState createState() => _BluetoothPageState();
}

class _BluetoothPageState extends State<BluetoothPageInvoice> {
  BlueThermalPrinter printer = BlueThermalPrinter.instance;
  List<BluetoothDevice> devicesList = [];
  BluetoothDevice? selectedDevice;
  String? registration_num;
  String? entry_time;
  String? exit_time;
  String? ticket_num;
  String? payment_amount;
  String? location;
  String? address;
  String? vehicleType;
  String? vehicleRegNumber;
  String? duration;

  @override
  void initState() {
    super.initState();
    initPrinter();
    registration_num = widget.registration_num;
    entry_time = widget.entry_time;
    exit_time = widget.exit_time;
    ticket_num = widget.ticket_num;
    payment_amount = widget.payment_amount;
    location = widget.location;
    address = widget.address;
    vehicleType = widget.vehicleType;
    vehicleRegNumber = widget.vehicleRegNumber;
    duration = widget.duration;
  }

  void initPrinter() async {
    bool isConnected = await printer.isConnected ?? false;
    if (!isConnected) {
      await getDevices();
    }
  }

  Future<void> getDevices() async {
    try {
      List<BluetoothDevice> devices = await printer.getBondedDevices();
      setState(() {
        devicesList = devices;
      });
    } catch (e) {
      print("Error getting devices: $e");
    }
  }

  void connectToDevice(BluetoothDevice device) async {
    try {
      bool? connected = await printer.connect(device);
      if (connected == true) {
        setState(() {
          selectedDevice = device;
        });
        print('Connected to ${device.name}');
      } else {
        print('Failed to connect to ${device.name}');
      }
    } on PlatformException catch (e) {
      if (e.code == 'connect_error' && e.message == 'already connected') {
        setState(() {
          selectedDevice = device;
        });
        print('Already connected to ${device.name}');
        
      } else {
        print('Failed to connect to ${device.name}: $e');
      }
    }
  }

  Future<void> printInvoice() async {
    if (selectedDevice != null) {
      printer.printNewLine();
      printer.printCustom("PARKING Exit Receipt", 1, 1);
      printer.printCustom("Entry: $entry_time", 1, 1);
      printer.printCustom("Exit: $exit_time", 1, 1);
      printer.printCustom("$vehicleType: $vehicleRegNumber", 1, 1);
      printer.printCustom("Parking Bill: $payment_amount", 1, 2);
      printer.printCustom("Ticket No: $registration_num", 1, 1);
      printer.printCustom("Duration: $duration", 1, 1);
      printer.printCustom("Developed by ParkingKori.com", 1, 1);
      printer.printNewLine();
      printer.paperCut();
    } else {
      print('No device connected');
    }
  }

  Widget actionButton(BuildContext context, String text, VoidCallback action, double size) {
    return Container(
      width: get_screenWidth(context) * size,
      constraints: BoxConstraints(minWidth: get_screenWidth(context) * 0.3),
      margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: myred,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: TextButton(
        onPressed: action,
        child: Text(
          text,
          style: boldTextStyle(context, myWhite),
        ),
      ),
    );
  }

  void confirmationDialog(String title, String description, BuildContext context, VoidCallback onConfirm) {
    // Create button
    Widget yesButton = TextButton(
      child: Text(
        "Yes",
        style: normalTextStyle(context, myWhite),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MainPage()),
        ); // Close the dialog
        onConfirm(); // Call the printInvoice function
        Fluttertoast.showToast(
          msg: "Checkout Successful!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Color.fromRGBO(65, 176, 110, 1),
          textColor: Colors.white,
          fontSize: 16.0,
        );
      },
    );

    Widget noButton = TextButton(
      child: Text(
        "No",
        style: normalTextStyle(context, myWhite),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MainPage()),
        ); // Close the dialog
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: myred,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Text(title, style: nameTitleStyle(context, myWhite)),
          ),
        ],
      ),
      content: Text(description, style: normalTextStyle(context, myWhite)),
      actions: [
        yesButton,
        noButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth Printer'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(); // Go back to the previous screen
          },
        ),
      ),
      body: Column(
        children: [
          actionButton(
            context,
            'Scan for Devices',
            getDevices,
            0.8,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: devicesList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(devicesList[index].name ?? ''),
                  subtitle: Text(devicesList[index].address ?? ''),
                  onTap: () => connectToDevice(devicesList[index]),
                );
              },
            ),
          ),
          if (selectedDevice != null)
            actionButton(
              context,
              'Print',
              () => confirmationDialog(
                'Print Confirmation',
                'Do you want to print?',
                context,
                printInvoice,
              ),
              0.8,
            ),
        ],
      ),
    );
  }
}
