class Service {
  int? id;
  int vehicleId;
  String type;
  String? date;
  int? mileage;
  String? vehicleName;
  String? vehicleLicensePlate;

  Service({
    this.id,
    required this.vehicleId,
    required this.type,
    this.date,
    this.mileage,
    this.vehicleName,
    this.vehicleLicensePlate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'vehicleId': vehicleId,
      'type': type,
      'date': date,
      'mileage': mileage,
    };
  }
}
