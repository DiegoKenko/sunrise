import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:sunrise/datasource/lobby/chat/lobby_chat_add_datasource.dart';
import 'package:sunrise/interface/controllers/auth/auth_controller.dart';
import 'package:sunrise/interface/controllers/chat/chat_controller.dart';
import 'package:sunrise/interface/controllers/lobby/lobby_controller.dart';
import 'package:sunrise/interface/states/lobby_state.dart';
import 'package:sunrise/services/notification/firebase_messaging_service.dart';
import 'package:sunrise/services/notification/notification_service.dart';

final getIt = GetIt.instance;

void setup() {
  getIt.registerLazySingleton<NotificationService>(() => NotificationService());
  getIt.registerLazySingleton<FirebaseMessagingService>(
    () => FirebaseMessagingService(getIt.get<NotificationService>()),
  );
  getIt.registerLazySingleton<AuthController>(() => AuthController());
  getIt.registerLazySingleton<LobbyController>(
    () => LobbyController(LobbyStateInitial()),
  );
  getIt.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );

  getIt.registerLazySingleton<ChatController>(
    () => ChatController(getIt<LobbyChatAddDataSource>()),
  );
  getIt.registerLazySingleton<LobbyChatAddDataSource>(
    () => LobbyChatAddDataSource(),
  );
}
