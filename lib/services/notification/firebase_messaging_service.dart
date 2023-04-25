import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:sunrise/datasource/data_provider_lover.dart';
import 'package:sunrise/services/notification/notification_service.dart';
import 'package:sunrise/model/model_chat_message.dart';
import 'package:sunrise/model/model_chat_notification.dart';
import 'package:sunrise/model/model_lover.dart';
import 'package:http/http.dart' as http;

class FirebaseMessagingService {
  final NotificationService _notificationService;
  String? token;

  FirebaseMessagingService(this._notificationService);

  Future<void> initialize() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      badge: true,
      sound: true,
      alert: true,
    );
    getDeviceFirebaseToken();
    _onMessage();
    _onMessageOpenedApp();
  }

  getDeviceFirebaseToken() async {
    token = await FirebaseMessaging.instance.getToken();
    debugPrint('=======================================');
    debugPrint('TOKEN: $token');
    debugPrint('=======================================');
  }

  _onMessage() {
    FirebaseMessaging.onMessage.listen((message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        _notificationService.showLocalNotification(
          ChatNotification(
            id: android.hashCode,
            title: notification.title!,
            body: notification.body!,
            payload: message.data['route'] ?? '',
          ),
        );
      }
    });
  }

  _onMessageOpenedApp() {
    FirebaseMessaging.onMessageOpenedApp.listen(_goToPageAfterMessage);
  }

  _goToPageAfterMessage(message) {
    final String route = message.data['route'] ?? '';
    if (route.isNotEmpty) {}
  }

  updateLoverWithToken(Lover lover) async {
    if (token == null) {
      return;
    }
    lover.token = token!;
    await DataProviderLover().update(lover);
  }

  Future<void> sendMessage(String token, ChatMessage chatMessage) async {
    try {
      var x = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAToog9sI:APA91bFEH9AYqRGClyyAjVb-1jUA9yIzGfF47SkYdRooq3i2oAvon8r33EXkr9OMGsnwpo9NgGgwLkiInjj7OAorKvLINf0XljZaJPiZk-6ClisUCrHkKnwUMeDoHCgGWjYsTfGq-mTq',
        },
        body: jsonEncode({
          'to': token,
          'data': {
            'message': chatMessage.message,
          },
          'notification': {
            'title': chatMessage.sentBy,
            'body': chatMessage.message,
          },
          'content_available': true
        }),
      );

      if (kDebugMode) {
        print('done');
        print(x.toString());
      }
    } catch (e) {
      if (kDebugMode) {
        print('error push notification');
      }
    }
  }
}
