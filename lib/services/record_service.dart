part of '../main.dart';

class RecordService {
  RecordService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<List<TruckEntry>> getRecords({
    String timeline = 'today',
    String search = '',
    int limit = 50,
    int offset = 0,
  }) async {
    final response = await _apiClient.get(
      ApiConfig.records,
      queryParams: {
        'timeline': timeline,
        'search': search,
        'limit': limit.toString(),
        'offset': offset.toString(),
      },
    );

    if (response is Map<String, dynamic>) {
      final records = response['records'];
      if (records is List) {
        return records
            .whereType<Map<String, dynamic>>()
            .map(TruckEntry.fromBackendJson)
            .toList();
      }
    }

    throw Exception('Unable to load records.');
  }

  Future<TruckEntry> getRecordById(String id) async {
    final response = await _apiClient.get('${ApiConfig.records}/$id');

    if (response is Map<String, dynamic>) {
      final record = response['record'];
      if (record is Map<String, dynamic>) {
        return TruckEntry.fromBackendJson(record);
      }
    }

    throw Exception('Unable to load record details.');
  }

  Future<List<DriverRecordSummary>> getRecordsByDriver({
    String timeline = 'today',
    String search = '',
    int limit = 50,
    int offset = 0,
  }) async {
    final response = await _apiClient.get(
      ApiConfig.recordsByDriver,
      queryParams: {
        'timeline': timeline,
        'search': search,
        'limit': limit.toString(),
        'offset': offset.toString(),
      },
    );

    if (response is Map<String, dynamic>) {
      final drivers = response['drivers'];
      if (drivers is List) {
        return drivers
            .whereType<Map<String, dynamic>>()
            .map(DriverRecordSummary.fromBackendJson)
            .toList();
      }
    }

    throw Exception('Unable to load driver summaries.');
  }

  Future<DriverRecordsResult> getDriverRecords({
    required String phone,
    String timeline = 'all',
  }) async {
    final response = await _apiClient.get(
      '${ApiConfig.records}/driver/$phone',
      queryParams: {'timeline': timeline},
    );

    if (response is Map<String, dynamic>) {
      return DriverRecordsResult.fromJson(response);
    }

    throw Exception('Unable to load driver records.');
  }
}
