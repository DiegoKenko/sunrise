import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

///https://firebase.flutter.dev/docs/messaging/usage
class NotificationService {
  FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> requestPermissions() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  Future<String?> getToken() async {
    String? token = await _messaging.getToken();
    return token;
  }

  Future<void> checkPermissions() async {
    NotificationSettings settings = await _messaging.getNotificationSettings();
  }

  /// The API endpoint here accepts a raw FCM payload for demonstration purposes.
  String constructFCMPayload(String? token) {
    return jsonEncode({
      'token': token,
      'data': {
        'via': 'FlutterFire Cloud Messaging!!!',
      },
      'notification': {
        'title': 'Hello FlutterFire!',
        'body': 'This notification  was created via FCM!',
      },
    });
  }

  Future<void> sendPushMessage(String token) async {
    try {
      await http.post(
        Uri.parse('https://api.rnfirebase.io/messaging/send'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: constructFCMPayload(token),
      );
      print('FCM request for device sent!');
    } catch (e) {
      print(e);
    }
  }
}
