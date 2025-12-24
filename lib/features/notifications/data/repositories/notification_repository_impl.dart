import 'package:notification_portal/core/network/app_client.dart';

import '../models/notification_model.dart';

class NotificationRepository {
  final ApiClient apiClient;
  NotificationRepository(this.apiClient);

  Future<List<NotificationModel>> fetchHistory(String userId) async {
    try {
      final response = await apiClient.dio.get('/notifications/history/$userId');
      return (response.data as List)
          .map((json) => NotificationModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to load notifications from M2 Backend: $e');
    }
  }

  Future<void> sendNotification({
  required String userId,
  required String title,
  required String message,
}) async {
  try {
    await apiClient.dio.post('/notifications/send', data: {
      'user_id': userId,
      'title': title,
      'message': message,
      'payload': {'source': 'flutter_app'}
    });
  } catch (e) {
    throw Exception('Failed to send notification: $e');
  }
}
}