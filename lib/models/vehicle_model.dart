class Vehicle {
  int? id;
  String name;
  String model;
  int mileage;
  String licensePlate;
  int scheduledMaintenance; // Campo de Revisão Programada

  Vehicle({
    this.id,
    required this.name,
    required this.model,
    required this.mileage,
    required this.licensePlate,
    required this.scheduledMaintenance,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'model': model,
      'mileage': mileage,
      'licensePlate': licensePlate,
      'scheduledMaintenance': scheduledMaintenance,
    };
  }
}
