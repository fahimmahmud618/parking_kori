import 'package:parking_kori/model/booking.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';
import 'dart:io';
import 'package:cache_manager/core/read_cache_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DatabaseHelper {
  static const int _version = 1;
  static const String _dbName = 'parking_kori.db';
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

  static Future<int> addVehicle(Booking car) async {
    print("add local vehicle");
    final db = await _getDB();
    return await db.insert("Booking", car.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> parkOut(Booking car) async {
    final db = await _getDB();
    return await db.delete(
      "Booking",
      where: 'booking_id= ?',
      whereArgs: [car.booking_id],
    );
  }

  static Future<List<Booking>?> getAllCars() async {
    final db = await _getDB();

    final List<Map<String, dynamic>> maps = await db.query("Booking");

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

    try {
      final request = await client.getUrl(
        Uri.parse('$baseUrl/get-booking'),
      );
      request.headers.add('Authorization', 'Bearer $token');
      final response = await request.close();

      if (response.statusCode == 200) {
        final responseBody = await utf8.decoder.bind(response).join();
        final responseData = json.decode(responseBody);

        List<dynamic> bookings = responseData['booking'];

        for (var bookingData in bookings) {
          String status = bookingData['status'];
          bool isPresent = status == 'pending';

          await handleResponse(bookingData, isPresent);
        }
      } else {
        throw Exception('Failed to load data park log');
      }
    } catch (e) {
      print('Error loading data from remote: $e');
      throw Exception('Failed to load data from remote');
    }
  }

  Future<void> handleResponse(
      Map<String, dynamic> bookingData, bool isPresent) async {
    String vehicleType = bookingData['vehicle_type_id'].toString();
    String bookingNumber = bookingData['booking_number'];
    String registrationNumber = bookingData['vehicle_reg_number'];
    String inTime = bookingData['park_in_time'];
    String outTime = isPresent ? "" : bookingData['park_out_time'];

    Booking booking = Booking(
      booking_id: bookingNumber,
      vehicle_type: vehicleType,
      registration_number: registrationNumber,
      in_time: inTime,
      out_time: outTime,
      isPresent: isPresent,
    );

    try {
      await addVehicle(booking);
    } catch (e) {
      print('Error adding booking to local database: $e');
      throw Exception('Failed to add booking to local database');
    }
  }
}
