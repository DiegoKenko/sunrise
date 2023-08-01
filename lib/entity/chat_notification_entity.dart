import 'package:firebase_messaging/firebase_messaging.dart';

class ChatNotificationEntity {
  final int id;
  final String title;
  final String body;
  final String? payload;
  final RemoteMessage? remoteMessage;

  ChatNotificationEntity({
    required this.id,
    required this.title,
    required this.body,
    this.payload,
    this.remoteMessage,
  });
}
