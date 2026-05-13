part of '../main.dart';

class DashboardService {
  DashboardService({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<DashboardStats> getStats({String timeline = 'today'}) async {
    final response = await _apiClient.get(
      ApiConfig.dashboardStats,
      queryParams: {'timeline': timeline},
    );

    if (response is Map<String, dynamic>) {
      final stats = response['stats'];
      if (stats is Map<String, dynamic>) {
        return DashboardStats.fromJson(stats);
      }
    }

    throw Exception('Unable to load dashboard stats.');
  }

  Future<List<TruckEntry>> getRecentEntries({int limit = 5}) async {
    final response = await _apiClient.get(
      ApiConfig.dashboardRecentEntries,
      queryParams: {'limit': limit.toString()},
    );

    if (response is Map<String, dynamic>) {
      final entries = response['entries'];
      if (entries is List) {
        return entries
            .whereType<Map<String, dynamic>>()
            .map(TruckEntry.fromBackendJson)
            .toList();
      }
    }

    throw Exception('Unable to load recent entries.');
  }
}
