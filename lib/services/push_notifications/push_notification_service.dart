// lib/services/push_notification_service.dart
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<void> init() async {
    // Request permissions (iOS)
    await _fcm.requestPermission();

    // Get the token
    String? token = await _fcm.getToken();

    if (token != null) {
      // Save the token to Parse Installation
      final installation = await ParseInstallation.currentInstallation();
      installation.set('deviceToken', token);
      await installation.save();
    }

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received a message in the foreground!');
      // Handle the message
    });
  }
}
