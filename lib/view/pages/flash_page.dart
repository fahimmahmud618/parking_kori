import 'dart:async';
import 'dart:convert';
import 'package:cache_manager/cache_manager.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:cache_manager/core/write_cache_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:parking_kori/view/image_file.dart';
import 'package:parking_kori/view/pages/login_page.dart';
import 'package:parking_kori/view/pages/main_page.dart';
import 'package:parking_kori/view/styles.dart';
import 'package:http/http.dart' as http;

class FlashPage extends StatefulWidget {
  const FlashPage({super.key});

  @override
  State<FlashPage> createState() => _FlashPageState();
}

class _FlashPageState extends State<FlashPage> {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  AndroidDeviceInfo? androidInfo;
  Future<AndroidDeviceInfo> getInfo() async {
    return await deviceInfo.androidInfo;
  }

  void showAll(AndroidDeviceInfo data) {
    print("Brand: ${data.brand}");
    WriteCache.setString(key: "brand", value: data.brand);
    print("Device: ${data.device}");
    print("Model: ${data.model}");
    print("Manufacturer: ${data.manufacturer}");
    print("Product: ${data.product}");
    print("Version: ${data.version.release.toString()}");
    print("Fingerprint: ${data.fingerprint}");
    print("ID: ${data.id}"); //uniquely identifies a device
    print("Serial Number: ${data.serialNumber}");
  }

  Future<void> sendDeviceInfo(AndroidDeviceInfo androidInfo) async {
    try {
      String? baseUrl = dotenv.env['BASE_URL'];
      String url = '$baseUrl/get-device-data';
      Map<String, dynamic> requestData = {
        'brand': androidInfo.brand,
        'device': androidInfo.device,
        'model': androidInfo.model,
        'manufacturer': androidInfo.manufacturer,
        'product': androidInfo.product,
        'id': androidInfo.id,
        'version': androidInfo.version.release.toString(),
      };

      http.Response response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 200) {
        print('Device info sent successfully');
      } else {
        print(
            'Failed to send device info. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending device data: $e');
    }
  }

  Future initiateChache() async {
    CacheManagerUtils.conditionalCache(
        key: "cache",
        valueType: ValueType.StringValue,
        actionIfNull: () {
          // myAlertDialog("Info", "No data found, please log in", context);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginPage()));
        },
        actionIfNotNull: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MainPage()));
        });
  }

  @override
  void initState() {
    Timer(Duration(seconds: 2), initiateChache);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: FutureBuilder<AndroidDeviceInfo>(
      future: getInfo(),
      builder: (context, snapshot) {
        final data = snapshot.data!;

        showAll(data);
        sendDeviceInfo(data);
        return SafeArea(
            child: Scaffold(
          body: Center(
              child: Image.asset(
            pkLogonamed,
            width: get_screenWidth(context) * 0.45,
          )),
        ));
      },
    )));
  }
}
