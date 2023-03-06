import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:sunrise/data/data_provider_lover.dart';
import 'package:sunrise/domain/notification_service.dart';
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

  sendMessage(String token) async {
    try {
      var m = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: {
          'contentType': 'application/json',
          'authorization':
              'key=AAAAToog9sI:APA91bFEH9AYqRGClyyAjVb-1jUA9yIzGfF47SkYdRooq3i2oAvon8r33EXkr9OMGsnwpo9NgGgwLkiInjj7OAorKvLINf0XljZaJPiZk-6ClisUCrHkKnwUMeDoHCgGWjYsTfGq-mTq',
        },
        body: jsonEncode({
          'to': token,
          'notification': {
            'title': 'title',
            'body': 'body',
          },
        }),
      );
      if (kDebugMode) {
        print('done');
      }
    } catch (e) {
      if (kDebugMode) {
        print('error push notification');
      }
    }
  }
}
