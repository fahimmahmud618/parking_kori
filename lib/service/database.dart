import 'package:parking_kori/model/booking.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const int _version = 1;
  static const String _dbName = 'cars.db';

  static Future<Database> _getDB() async {
    return openDatabase(
      join(await getDatabasesPath(), _dbName),
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE Car(booking_id TEXT PRIMARY KEY, vehicle_type TEXT, registration_number TEXT, in_time TEXT NOT NULL, out_time TEXT NOT NULL, isPresent TEXT NOT NULL)',
        );
      },
      version: _version,
    );
  }

  static Future<int> addCar(Booking car) async {
    print("add local vehicle");
    final db = await _getDB();
    return await db.insert("Car", car.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> deleteCar(Booking car) async {
    final db = await _getDB();
    return await db.delete("Car",
        where: 'booking_id= ?',
        whereArgs: [car.booking_id],
    );
  }

  static Future<List<Booking>?> getAllCars() async {
    final db = await _getDB();

    final List<Map<String, dynamic>> maps = await db.query("Car");

    if(maps.isEmpty){
      return null;
    }

    return List.generate(maps.length, (index) => Booking.fromJson(maps[index]));
  }

}
