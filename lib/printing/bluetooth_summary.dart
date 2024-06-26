import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:parking_kori/view/pages/alert_bluetooth.dart';
import 'package:parking_kori/view/pages/main_page.dart';
import 'package:parking_kori/view/styles.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart' as blue_plus;
import 'package:blue_thermal_printer/blue_thermal_printer.dart' as blue_thermal;


class BluetoothPageSummary extends StatefulWidget {
  final String? total_park_in;
  final String? total_park_out;
  final String? total_income;
  final DataTable dataTable;
  final DateTime? dateTime; 
  final String address;

  const BluetoothPageSummary({
    Key? key,
    required this.total_park_in,
    required this.total_park_out,
    required this.total_income,
    required this.dataTable,
    required this.dateTime,
    required this.address,
  }) : super(key: key);

  @override
  _BluetoothPageState createState() => _BluetoothPageState();
}

class _BluetoothPageState extends State<BluetoothPageSummary> {
  blue_thermal.BlueThermalPrinter printer = blue_thermal.BlueThermalPrinter.instance;
  List<blue_thermal.BluetoothDevice> devicesList = [];
  blue_thermal.BluetoothDevice? selectedDevice;
  String? total_park_in;
  String? total_park_out;
  String? total_income;
  late DataTable dataTable ;
  DateTime? dateTime; 
  String? address;
 
  

  @override
  void initState() {
    super.initState();
    checkBluetoothOnInit();
    initPrinter();
    total_park_in = widget.total_park_in;
    total_park_out = widget.total_park_out;
    total_income = widget.total_income;
    dataTable = widget.dataTable;
    dateTime = widget.dateTime;
    address = widget.address;
  }

  void initPrinter() async {
    bool isConnected = await printer.isConnected ?? false;
    if (!isConnected) {
      await getDevices();
    }
  }

  Future<void> getDevices() async {
    try {
      List<blue_thermal.BluetoothDevice> devices = await printer.getBondedDevices();
      setState(() {
        devicesList = devices;
      });
    } catch (e) {
      print("Error getting devices: $e");
    }
  }

  void connectToDevice(blue_thermal.BluetoothDevice device) async {
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

   Future<bool> isBluetoothEnabled() async {
    var adapterState = await FlutterBluePlus.adapterState.first;
    return adapterState == blue_plus.BluetoothAdapterState.on;
  }

  void checkBluetoothOnInit() async {
    bool isBluetoothOn = await isBluetoothEnabled();
    if (!isBluetoothOn) {
      alertBluetooth("Please enable Bluetooth!", "Bluetooth in your device is turned off", context); 
    }
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

  Future<void> printSummary() async {
    if (selectedDevice != null) {
      printer.printNewLine();
      printer.printCustom("$address",1,1);
      printer.printCustom(formatDateTime(dateTime!),1,1);
      printer.printCustom("Total Park In: $total_park_in", 1, 1);
      printer.printCustom("Total Park Out: $total_park_out", 1, 1);
      printer.printCustom("Agent Name & Income", 1, 1);
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

    for (var rowData in tableData) {
      String rowString = rowData.join(' | '); // Join cells with ' | ' separator
      printer.printCustom(rowString,1,1);
    }

    printer.printCustom("Total Income: $total_income",1,1);
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
                printSummary,
              ),
              0.8,
            ),
        ],
      ),
    );
  }
}
