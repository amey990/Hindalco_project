import '../models/app_notification.dart';
import 'api_client.dart';
import 'api_config.dart';

class NotificationService {
  NotificationService({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<List<AppNotification>> getNotifications() async {
    final response = await _apiClient.get(ApiConfig.notifications);

    if (response is Map<String, dynamic>) {
      final notifications = response['notifications'];
      if (notifications is List) {
        return notifications
            .whereType<Map<String, dynamic>>()
            .map(AppNotification.fromJson)
            .toList();
      }
    }

    throw Exception('Unable to load notifications.');
  }

  Future<void> markAllRead() async {
    await _apiClient.put(ApiConfig.notificationsReadAll);
  }
}
