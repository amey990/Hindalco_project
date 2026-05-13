part of '../main.dart';

class EntryService {
  EntryService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<GateEntrySubmitResult> createEntry({
    required String driverPhone,
    required String driverName,
    required String truckNumber,
    required String materialName,
    required double temperatureFahrenheit,
    String? driverPhotoKey,
  }) async {
    final response = await _apiClient.post(
      ApiConfig.entries,
      body: {
        'driver_phone': driverPhone,
        'driver_name': driverName,
        'truck_number': truckNumber,
        'material_name': materialName,
        'temperature_fahrenheit': temperatureFahrenheit,
        if (driverPhotoKey != null && driverPhotoKey.isNotEmpty)
          'driver_photo_key': driverPhotoKey,
      },
    );

    if (response is Map<String, dynamic>) {
      return GateEntrySubmitResult.fromJson(response);
    }

    throw Exception('Unable to submit gate entry.');
  }
}
