import 'package:parking_kori/model/booking.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';
import 'dart:io';
import 'package:cache_manager/core/read_cache_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';




//add vehicle
//report summary
//device info
//get vehicle numbers
//park in data
//park out data
//profile

class DatabaseHelper {
  static const int _version = 1;
  static const String _dbName = 'parking_kori.db';
  static const String booking_table_name = 'Booking';
  List<Booking> BookingList = [];
  String? baseUrl = dotenv.env['BASE_URL'];

  static Future<Database> _getDB() async {
    return openDatabase(
      join(await getDatabasesPath(), _dbName),
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE Booking(booking_id TEXT PRIMARY KEY, vehicle_type TEXT, registration_number TEXT, in_time TEXT NOT NULL, out_time TEXT NOT NULL, isPresent TEXT NOT NULL)',
        );
      },
      version: _version,
    );
  }

  static Future<int> addVehicle(Booking booking) async {
    print("add local vehicle");
    final db = await _getDB();
    return await db.insert(booking_table_name, booking.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> parkOut(Booking car) async {
    final db = await _getDB();
    return await db.delete(
      booking_table_name,
      where: 'booking_id= ?',
      whereArgs: [car.booking_id],
    );
  }

  static Future<List<Booking>?> getAllCars() async {
    final db = await _getDB();

    final List<Map<String, dynamic>> maps = await db.query(booking_table_name);

    if (maps.isEmpty) {
      return null;
    }

    return List.generate(maps.length, (index) => Booking.fromJson(maps[index]));
  }

  Future<void> loadParkLogDataFromRemoteDB() async {
    String token = await ReadCache.getString(key: "token");

    // HttpClient with badCertificateCallback to bypass SSL certificate verification
    final client = HttpClient();
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;

    final requestParkin = await client.getUrl(
      Uri.parse('$baseUrl/get-booking?status=pending'),
    );
    requestParkin.headers.add('Authorization', 'Bearer $token');
    final responseParkin = await requestParkin.close();
    if (responseParkin.statusCode == 200) {
      await handleResponse(responseParkin, true);
      for (var booking in BookingList) {
        await addVehicle(booking);
      }
    } else {
      throw Exception('Failed to load data present park log');
    }

    final requestParkOut = await client.getUrl(
      Uri.parse('$baseUrl/get-booking?status=park-out'),
    );
    requestParkOut.headers.add('Authorization', 'Bearer $token');
    final responseParkOut = await requestParkOut.close();
    if (responseParkOut.statusCode == 200) {
      await handleResponse(responseParkOut, true);
      for (var booking in BookingList) {
        await addVehicle(booking);
      }
    } else {
      throw Exception('Failed to load data park-out park log');
    }
  }

  Future<void> handleResponse(
      HttpClientResponse response, bool isPresent) async {
    final responseBody = await utf8.decoder.bind(response).join();
    final responseData = json.decode(responseBody);
    final bookingsData = responseData['booking'];
    for (var bookingData in bookingsData) {
      String vehicleType = bookingData['vehicle_type_id'].toString();
      String bookingNumber = bookingData['booking_number'];
      String registrationNumber = bookingData['vehicle_reg_number'];
      String inTime = bookingData['park_in_time'];
      String outTime = isPresent ? "" : bookingData['park_out_time'];

      BookingList.add(
        Booking(
          booking_id: bookingNumber,
          vehicle_type: vehicleType,
          registration_number: registrationNumber,
          in_time: inTime,
          out_time: outTime,
          isPresent: isPresent,
        ),
      );
    }
  }
}
