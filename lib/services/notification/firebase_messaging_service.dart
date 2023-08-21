import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:sunrise/services/getIt/get_it_dependencies.dart';
import 'package:sunrise/services/notification/local_notification_service.dart';
import 'package:sunrise/entity/chat_message_entity.dart';
import 'package:sunrise/entity/chat_notification_entity.dart';
import 'package:http/http.dart' as http;
import 'package:sunrise/usecase/lover/lover_update_usecase.dart';

class FirebaseMessagingService {
  final LoverUpdateUsecase loverUpdateUsecase = LoverUpdateUsecase();
  final LocalNotificationService _notificationService;
  String? token;

  FirebaseMessagingService(this._notificationService);

  Future<void> initialize() async {
    await getIt<FirebaseMessaging>()
        .setForegroundNotificationPresentationOptions(
      badge: true,
      sound: true,
      alert: true,
    );
    token = await getDeviceFirebaseToken();
    _onMessage();
    _onMessageOpenedApp();
  }

  Future<String?> getDeviceFirebaseToken() async {
    return await getIt<FirebaseMessaging>().getToken();
  }

  _onMessage() {
    FirebaseMessaging.onMessage.listen((message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        _notificationService.showLocalNotification(
          ChatNotificationEntity(
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

  Future<void> sendMessage(String token, ChatMessageEntity chatMessage) async {
    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'key=AAAAToog9sI:APA91bFEH9AYqRGClyyAjVb-1jUA9yIzGfF47SkYdRooq3i2oAvon8r33EXkr9OMGsnwpo9NgGgwLkiInjj7OAorKvLINf0XljZaJPiZk-6ClisUCrHkKnwUMeDoHCgGWjYsTfGq-mTq',
      },
      body: jsonEncode({
        'to': chatMessage.sentById,
        'data': {
          'message': chatMessage.message,
        },
        'notification': {
          'title': chatMessage.sentByName,
          'body': chatMessage.message,
        },
        'content_available': true
      }),
    );
  }
}
