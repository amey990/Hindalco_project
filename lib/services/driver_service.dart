import '../models/driver.dart';
import 'api_client.dart';
import 'api_config.dart';

class DriverService {
  DriverService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<DriverSearchResult> searchDriverByPhone(String phone) async {
    final response = await _apiClient.get(
      ApiConfig.driversSearch,
      queryParams: {'phone': phone},
    );

    if (response is Map<String, dynamic>) {
      final driverJson = response['driver'];
      return DriverSearchResult(
        found: response['found'] == true,
        message: response['message']?.toString() ?? '',
        driver:
            driverJson is Map<String, dynamic>
                ? Driver.fromJson(driverJson)
                : null,
      );
    }

    throw Exception('Unable to search driver.');
  }

  Future<Driver> saveDriver({
    required String phone,
    required String name,
    String? latestPhotoKey,
  }) async {
    final response = await _apiClient.post(
      ApiConfig.drivers,
      body: {
        'phone': phone,
        'name': name,
        if (latestPhotoKey != null) 'latest_photo_key': latestPhotoKey,
      },
    );

    if (response is Map<String, dynamic>) {
      final driverJson = response['driver'];
      if (driverJson is Map<String, dynamic>) {
        return Driver.fromJson(driverJson);
      }
    }

    throw Exception('Unable to save driver.');
  }
}
