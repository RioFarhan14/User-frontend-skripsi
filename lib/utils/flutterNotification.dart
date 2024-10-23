import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_frontend/providers/notifProvider.dart';

class FlutterNotification {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Initialize local notifications and set notification presentation options
  Future<void> init(BuildContext context) async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await subscribeToGeneralTopic();
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null) {
          // Handle notification data and navigate to detail page
          final notificationId = int.parse(response.payload!);
          // Obtain NotificationProvider instance
          final notificationProvider =
              Provider.of<NotificationProvider>(context, listen: false);

          // Initialize data
          notificationProvider.fetchData();

          // Mark the notification as read
          notificationProvider.isRead(notificationId);

          // Navigate to the detail page
          Navigator.pushNamed(
            context,
            '/detailInfo',
            arguments: notificationId,
          ).then((_) {
            print('Navigated to /detailInfo with ID: $notificationId');
          }).catchError((error) {
            print('Navigation error: $error');
          });
        }
      },
    );

    // Set notification presentation options for foreground notifications
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // Get FCM token and handle incoming messages
    final token = await _firebaseMessaging.getToken();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fcm_token', token!);

    // Handle notifications when the app is in the foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showNotification(message);
    });

    // Handle notifications when the app is opened from background or terminated
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Handle notification data and navigate to detail page
      _handleNotificationData(context, message);
    });
  }

  // Show local notification based on the received message
  Future<void> _showNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'your_channel_id',
        'your_channel_name',
        channelDescription: 'your_channel_description',
        importance: Importance.max,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      );
      const NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);

      // Show the notification with specified details
      await _flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        platformChannelSpecifics,
        payload: message.data['notification_id'],
      );
    }
  }

  // Handle notification data and navigate to detail page
  void _handleNotificationData(BuildContext context, RemoteMessage message) {
    final notificationId = int.parse(message.data['notification_id'] ?? '-1');
    print('Notification ID: $notificationId');
    if (notificationId > 0) {
      // Obtain NotificationProvider instance
      final notificationProvider =
          Provider.of<NotificationProvider>(context, listen: false);

      // Initialize data
      notificationProvider.fetchData();

      // Mark the notification as read
      notificationProvider.isRead(notificationId);

      // Navigate to the detail page
      Navigator.pushNamed(
        context,
        '/detailInfo',
        arguments: notificationId,
      ).then((_) {
        print('Navigated to /detailInfo with ID: $notificationId');
      }).catchError((error) {
        print('Navigation error: $error');
      });
    } else {
      print('No valid notification ID found in the message data');
    }
  }

  // Subscribe to 'general' topic
  Future<void> subscribeToGeneralTopic() async {
    await _firebaseMessaging.subscribeToTopic('general');
  }
}
