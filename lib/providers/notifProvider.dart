import 'package:flutter/material.dart';
import 'package:user_frontend/services/notification-service.dart';

class NotificationProvider with ChangeNotifier {
  final NotifService _notifService = NotifService();

  List<Map<String, dynamic>> notifications = [];
  List<Map<String, dynamic>> notificationReads = [];
  List<Map<String, dynamic>> notificationCategories = [];

  void fetchData() async {
    try {
      final data = await _notifService.get();
      final newNotifications = data['notifications'] ?? [];

      if (newNotifications.isNotEmpty) {
        print('Showing notification');
      }

      notifications = newNotifications;
      notificationReads = data['notificationReads'] ?? [];
      notificationCategories = data['notificationCategories'] ?? [];
      notifyListeners();

      // Optional: Implement manual refresh mechanism
      // You can add a button or gesture to trigger data refresh manually
    } catch (e) {
      print('Error fetching notifications: $e');
    }
  }

  void isRead(int notificationId) async {
    try {
      final result = await _notifService.isRead(notificationId);
      if (result.isNotEmpty) {
        fetchData();
      }
    } catch (e) {
      print('Error submit isRead: $e');
    }
  }
}
