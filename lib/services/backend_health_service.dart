import 'api_client.dart';
import 'api_config.dart';

class BackendHealthService {
  BackendHealthService({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<dynamic> checkHealth() {
    return _apiClient.get(ApiConfig.health);
  }

  Future<dynamic> checkMaterials() {
    return _apiClient.get(ApiConfig.materials);
  }
}
