import '../models/managed_user.dart';
import 'api_client.dart';
import 'api_config.dart';

class AdminUserService {
  AdminUserService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;
  String? lastMessage;

  Future<List<ManagedUser>> getUsers({String role = 'all'}) async {
    final response = await _apiClient.get(
      ApiConfig.adminUsers,
      queryParams: {'role': role},
    );
    if (response is Map<String, dynamic>) {
      final users = response['users'];
      if (users is List) {
        return users
            .whereType<Map<String, dynamic>>()
            .map(ManagedUser.fromJson)
            .toList();
      }
    }
    return const [];
  }

  Future<ManagedUser> disableUser(String id) {
    return _runUserAction('${ApiConfig.adminUsers}/${Uri.encodeComponent(id)}/disable');
  }

  Future<ManagedUser> enableUser(String id) {
    return _runUserAction('${ApiConfig.adminUsers}/${Uri.encodeComponent(id)}/enable');
  }

  Future<ManagedUser> deleteUser(String id) {
    return _runUserAction(
      '${ApiConfig.adminUsers}/${Uri.encodeComponent(id)}',
      isDelete: true,
    );
  }

  Future<ManagedUser> _runUserAction(
    String endpoint, {
    bool isDelete = false,
  }) async {
    final response =
        isDelete ? await _apiClient.delete(endpoint) : await _apiClient.put(endpoint);
    if (response is Map<String, dynamic>) {
      lastMessage = response['message']?.toString();
      final user = response['user'];
      if (user is Map<String, dynamic>) {
        return ManagedUser.fromJson(user);
      }
    }
    throw Exception('Unable to update user.');
  }
}
