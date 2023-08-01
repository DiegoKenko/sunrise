import 'package:get_it/get_it.dart';
import 'package:sunrise/domain/auth/auth_notifier.dart';
import 'package:sunrise/domain/lobby/lobby_controller.dart';
import 'package:sunrise/domain/lobby/lobby_state.dart';
import 'package:sunrise/services/notification/firebase_messaging_service.dart';
import 'package:sunrise/services/notification/notification_service.dart';

final getIt = GetIt.instance;

void setup() {
  getIt.registerLazySingleton<NotificationService>(() => NotificationService());
  getIt.registerLazySingleton<FirebaseMessagingService>(
    () => FirebaseMessagingService(getIt.get<NotificationService>()),
  );
  getIt.registerLazySingleton<AuthService>(() => AuthService());
  getIt.registerLazySingleton<LobbyController>(
      () => LobbyController(LobbyStateInitial()));
}
