import 'api_client.dart';
import 'api_config.dart';

class ReportService {
  ReportService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<String> downloadRecordsReport({
    required String timeline,
    String search = '',
  }) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return _apiClient.downloadFile(
      ApiConfig.reportsRecords,
      'hindalco-records-report-$timestamp.xlsx',
      queryParams: {'timeline': timeline, 'search': search},
    );
  }

  Future<String> downloadDriverReport({
    required String phone,
    String timeline = 'all',
  }) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return _apiClient.downloadFile(
      '${ApiConfig.reportsDriver}/$phone',
      'hindalco-driver-$phone-$timestamp.xlsx',
      queryParams: {'timeline': timeline},
    );
  }
}
