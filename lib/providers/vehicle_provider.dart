import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../db/database_helper.dart';
import '../models/vehicle_model.dart';

class VehicleProvider with ChangeNotifier {
  List<Vehicle> _vehicles = [];

  List<Vehicle> get vehicles => _vehicles;

  Future<void> fetchVehicles() async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> maps = await db.query('vehicles');
    _vehicles = List.generate(maps.length, (i) {
      return Vehicle(
        id: maps[i]['id'],
        name: maps[i]['name'],
        model: maps[i]['model'],
        mileage: maps[i]['mileage'],
        licensePlate: maps[i]['licensePlate'],
        scheduledMaintenance: maps[i]['scheduledMaintenance'] ?? 0, // Garantindo que não seja nulo
      );
    });
    notifyListeners();
  }

  Future<void> addVehicle(Vehicle vehicle) async {
    final db = await DatabaseHelper().database;
    if (vehicle.id == null) {
      await db.insert('vehicles', vehicle.toMap());
    } else {
      await db.update('vehicles', vehicle.toMap(), where: 'id = ?', whereArgs: [vehicle.id]);
    }
    fetchVehicles();
  }

  Future<void> deleteVehicle(int id) async {
    final db = await DatabaseHelper().database;
    await db.delete('vehicles', where: 'id = ?', whereArgs: [id]);
    fetchVehicles();
  }
}
