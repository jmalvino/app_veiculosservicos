import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../db/database_helper.dart';
import '../models/service_model.dart';
import '../models/vehicle_model.dart';

class ServiceProvider with ChangeNotifier {
  List<Service> _services = [];

  List<Service> get services => _services;

  Future<void> fetchServices() async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> serviceMaps = await db.query('services');
    final List<Map<String, dynamic>> vehicleMaps = await db.query('vehicles');

    _services = serviceMaps.map((service) {
      final vehicle = vehicleMaps.firstWhere(
            (vehicle) => vehicle['id'] == service['vehicleId'],
        orElse: () => {'name': 'Veículo não encontrado', 'licensePlate': '---'}, // Fallback
      );
      return Service(
        id: service['id'],
        vehicleId: service['vehicleId'],
        type: service['type'],
        date: service['date'],
        mileage: service['mileage'],
        vehicleName: vehicle['name'],
        vehicleLicensePlate: vehicle['licensePlate'],
      );
    }).toList();

    notifyListeners();
  }

  Future<void> addService(Service service) async {
    final db = await DatabaseHelper().database;
    if (service.id == null) {
      await db.insert('services', service.toMap());
    } else {
      await db.update('services', service.toMap(), where: 'id = ?', whereArgs: [service.id]);
    }
    fetchServices();
  }

  Future<void> deleteService(int id) async {
    final db = await DatabaseHelper().database;
    await db.delete('services', where: 'id = ?', whereArgs: [id]);
    fetchServices();
  }
}
