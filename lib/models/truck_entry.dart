part of '../main.dart';

class TruckEntry {
  static const normalTemperatureMin = 97.0;
  static const normalTemperatureMax = 99.0;
  static const highTemperatureLimit = normalTemperatureMax;

  const TruckEntry({
    required this.driverName,
    required this.driverPhone,
    required this.truckNumber,
    required this.materialType,
    required this.temperature,
    required this.entryDateTime,
    this.id,
    this.driverPhotoPath,
    this.temperatureStatus,
    this.approvalStatus,
  });

  final String? id;
  final String driverName;
  final String driverPhone;
  final String truckNumber;
  final String materialType;
  final double temperature;
  final DateTime entryDateTime;
  final String? driverPhotoPath;
  final String? temperatureStatus;
  final String? approvalStatus;

  factory TruckEntry.fromBackendJson(Map<String, dynamic> json) {
    return TruckEntry(
      id: json['id']?.toString(),
      driverName: json['driver_name']?.toString() ?? '',
      driverPhone: json['driver_phone']?.toString() ?? '',
      truckNumber: json['truck_number']?.toString() ?? '',
      materialType:
          (json['material_name'] ?? json['latest_material_name'])?.toString() ??
          '',
      temperature: _parseDouble(json['temperature_fahrenheit']),
      entryDateTime: _parseBackendDateTime(
        json['entry_timestamp'] ??
            json['latest_entry_timestamp'] ??
            json['created_at'],
      ),
      driverPhotoPath: _emptyToNull(json['driver_photo_preview_url']),
      temperatureStatus: _emptyToNull(json['temperature_status']),
      approvalStatus: _emptyToNull(json['approval_status']),
    );
  }

  bool get isNormal {
    final status = temperatureStatus?.toLowerCase().trim();
    if (status == 'normal') {
      return true;
    }
    if (status == 'abnormal') {
      return false;
    }
    return isTemperatureNormal(temperature);
  }

  static bool isTemperatureNormal(double temperature) {
    return temperature >= normalTemperatureMin &&
        temperature <= normalTemperatureMax;
  }

  String get entryTime => _formatTime(entryDateTime);

  String get dateTimeLabel => _formatDateTime(entryDateTime);

  static double _parseDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  static DateTime _parseBackendDateTime(dynamic value) {
    return DateTime.tryParse(value?.toString() ?? '') ?? DateTime.now();
  }

  static String? _emptyToNull(dynamic value) {
    final text = value?.toString().trim();
    return text == null || text.isEmpty ? null : text;
  }
}
