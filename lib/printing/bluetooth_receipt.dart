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
import 'package:permission_handler/permission_handler.dart';

class BluetoothPageReceipt extends StatefulWidget {
  final String? bookingNumber;
  const BluetoothPageReceipt({Key? key, required this.bookingNumber}) : super(key: key);
  @override
  _BluetoothPageState createState() => _BluetoothPageState();
}

class _BluetoothPageState extends State<BluetoothPageReceipt> {
  BlueThermalPrinter printer = BlueThermalPrinter.instance;
  List<BluetoothDevice> devicesList = [];
  BluetoothDevice? selectedDevice;
  String? bookingNumber;

  @override
  void initState() {
    super.initState();
    initPrinter();
    bookingNumber = widget.bookingNumber;
    checkBluetoothOnInit();
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
  // await bluetoothOnCheck();
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

  Future<void> printReceipt() async {
    // await bluetoothOnCheck();
    if (bookingNumber == null) {
      print('Booking number is null');
      return;
    }

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

          printer.printNewLine();
          printer.printCustom(" $address", 1, 1);
          printer.printCustom("PARKING Entry Receipt", 1, 1);
          printer.printCustom("$vehicleType: $vehicleRegNumber", 1, 1);
          printer.printCustom("Entry: $parkInTime", 1, 1);
          printer.printCustom("Ticket No: $num", 1, 1);
          printer.printQRcode(num, 150, 150, 1);
          printer.printCustom("Developed by ParkingKori.com", 1, 1);
          printer.printNewLine();
          printer.paperCut();
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

  Future<bool> isDeviceBluetoothEnabled() async {
  var status = await Permission.bluetooth.status;
  return status == PermissionStatus.granted;
}
 void checkBluetoothOnInit() async {
    bool isBluetoothEnabled = await isDeviceBluetoothEnabled();
    if (!isBluetoothEnabled) {
      showBluetoothToast();
    }
  }
 void showBluetoothToast() {
  
    Fluttertoast.showToast(
      msg: "Please enable Bluetooth!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      backgroundColor: myred,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
  Widget actionButton(
      BuildContext context, String text, VoidCallback action, double size) {
        // bluetoothOnCheck();
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

  void confirmationDialog(String title, String description,
      BuildContext context, VoidCallback onConfirm) {
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
        );// Close the dialog
        onConfirm(); // Call the printReceipt function
          Fluttertoast.showToast(
          msg: "Vehicle Add Successful!",
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
                printReceipt, // No arguments are passed here
              ),
              0.8,
            ),
        ],
      ),
    );
  }
}
