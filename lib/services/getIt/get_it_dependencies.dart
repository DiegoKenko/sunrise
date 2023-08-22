import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_it/get_it.dart';
import 'package:sunrise/datasource/lobby/chat/lobby_chat_add_datasource.dart';
import 'package:sunrise/datasource/lobby/chat/lobby_chat_watch_datasource.dart';
import 'package:sunrise/interface/controllers/auth/auth_controller.dart';
import 'package:sunrise/interface/controllers/auth/firebase_auth_controller.dart';
import 'package:sunrise/interface/controllers/chat/chat_controller.dart';
import 'package:sunrise/interface/controllers/lobby/lobby_controller.dart';

import 'package:sunrise/services/notification/firebase_messaging_service.dart';
import 'package:sunrise/services/notification/local_notification_service.dart';

final getIt = GetIt.instance;

void setup() {
  getIt.registerLazySingleton<LocalNotificationService>(
    () => LocalNotificationService(),
  );
  getIt.registerLazySingleton<FirebaseMessaging>(
    () => FirebaseMessaging.instance,
  );
  getIt.registerLazySingleton<FirebaseMessagingService>(
    () => FirebaseMessagingService(getIt.get<LocalNotificationService>()),
  );
  getIt.registerLazySingleton<FirebaseAuthController>(
    () => FirebaseAuthController(),
  );
  getIt.registerLazySingleton<AuthController>(() => AuthController());
  getIt.registerLazySingleton<LobbyController>(
    () => LobbyController(),
  );
  getIt.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );

  getIt.registerLazySingleton<ChatController>(
    () => ChatController(
      getIt<LobbyChatAddDataSource>(),
      getIt<LobbyChatWatchDatasource>(),
    ),
  );
  getIt.registerLazySingleton<LobbyChatAddDataSource>(
    () => LobbyChatAddDataSource(),
  );
  getIt.registerLazySingleton<LobbyChatWatchDatasource>(
    () => LobbyChatWatchDatasource(),
  );
}
