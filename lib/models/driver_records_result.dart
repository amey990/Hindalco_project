part of '../main.dart';

class DriverRecordsResult {
  const DriverRecordsResult({
    required this.driver,
    required this.records,
    required this.total,
  });

  final Driver driver;
  final List<TruckEntry> records;
  final int total;

  factory DriverRecordsResult.fromJson(Map<String, dynamic> json) {
    final driverJson = json['driver'];
    final recordsJson = json['records'];
    final records =
        recordsJson is List
            ? recordsJson
                .whereType<Map<String, dynamic>>()
                .map(TruckEntry.fromBackendJson)
                .toList()
            : <TruckEntry>[];

    return DriverRecordsResult(
      driver:
          driverJson is Map<String, dynamic>
              ? Driver.fromJson({
                'id': driverJson['id'],
                'phone': driverJson['phone'],
                'name': driverJson['name'],
                'latest_photo_url': driverJson['driver_photo_preview_url'],
                'latest_photo_key': driverJson['driver_photo_key'],
                'is_active': true,
              })
              : const Driver(
                id: '',
                phone: '',
                name: '',
                latestPhotoUrl: null,
                latestPhotoKey: null,
                isActive: true,
                createdAt: null,
                updatedAt: null,
              ),
      records: records,
      total: _parseInt(json['total'], fallback: records.length),
    );
  }

  static int _parseInt(dynamic value, {required int fallback}) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }
}
