import '../models/app_user.dart';
import 'api_client.dart';
import 'api_config.dart';

class UserService {
  UserService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<AppUser> getCurrentUser() async {
    final response = await _apiClient.get(ApiConfig.authMe);

    if (response is Map<String, dynamic>) {
      final user = response['user'];
      if (user is Map<String, dynamic>) {
        return AppUser.fromJson(user);
      }
    }

    throw Exception('Unable to load user profile.');
  }
}
