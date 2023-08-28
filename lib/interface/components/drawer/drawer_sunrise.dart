import 'package:flutter/material.dart';
import 'package:sunrise/constants/icons.dart';
import 'package:sunrise/entity/chat_message_entity.dart';
import 'package:sunrise/interface/components/animated_page_transition.dart';
import 'package:sunrise/interface/components/drawer/payment_bottom_sheet.dart';
import 'package:sunrise/interface/controllers/auth/auth_controller.dart';
import 'package:sunrise/interface/controllers/lobby/lobby_controller.dart';
import 'package:sunrise/interface/controllers/notification/notification_controller.dart';
import 'package:sunrise/interface/states/auth_state.dart';
import 'package:sunrise/interface/screens/login/login_page_view.dart';
import 'package:sunrise/entity/lover_entity.dart';
import 'package:sunrise/services/getIt/get_it_dependencies.dart';
import 'package:sunrise/services/notification/firebase_messaging_service.dart';

class SunriseDrawer extends StatefulWidget {
  const SunriseDrawer({
    super.key,
  });

  @override
  State<SunriseDrawer> createState() => _SunriseDrawerState();
}

class _SunriseDrawerState extends State<SunriseDrawer> {
  final AuthController authService = getIt<AuthController>();
  final NotificationController _favoriteNotificationNotifier =
      getIt<NotificationController>();
  final FirebaseMessagingService _firebaseMessagingService =
      getIt<FirebaseMessagingService>();
  final LobbyController lobbyController = getIt<LobbyController>();

  @override
  Widget build(BuildContext context) {
    LoverEntity lover = LoverEntity.empty();

    return ValueListenableBuilder(
      valueListenable: authService,
      builder: (context, state, _) {
        if (state is AuthAuthenticatedState) {
          lover = state.lover;
        }

        return Drawer(
          width: MediaQuery.of(context).size.width * 0.8,
          backgroundColor: Colors.black.withOpacity(0.7),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ListTile(
                tileColor: Colors.black,
                leading: Image.asset(
                  lover.photoURL,
                  width: 50,
                  height: 50,
                ),
                title: Text(
                  lover.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                subtitle: Text(
                  lover.email,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
              Container(
                height: 1,
                color: Colors.white,
              ),
              ListTile(
                title: Row(
                  children: [
                    sunIcon,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        '${lover.suns} ',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                trailing: FilledButton(
                  onPressed: () {
                    Navigator.pop(context);
                    showBottomSheet(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.4,
                      ),
                      context: context,
                      builder: (
                        context,
                      ) {
                        return PaymentBottomSheet();
                      },
                    );
                  },
                  child: const Text('Adicionar'),
                ),
              ),
              Expanded(child: Container()),
              ValueListenableBuilder(
                valueListenable: _favoriteNotificationNotifier,
                builder: (context, state, value) {
                  return ListTile(
                    title: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        state
                            ? 'Notificação enviada'
                            : 'Enviar notificação com novos humores',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        if (!state) {
                          _firebaseMessagingService.sendMessage(
                            lobbyController.value.lobby
                                .couple(authService.lover.id)
                                .notificationToken,
                            ChatMessageEntity(
                              'Atualizou o humor!!',
                              authService.lover.id,
                              authService.lover.name,
                              DateTime.now(),
                            ),
                          );
                          _favoriteNotificationNotifier.value = true;
                        }
                      },
                      icon: Icon(
                        state ? Icons.done_all : Icons.send,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              Container(
                height: 1,
                color: Colors.white,
              ),
              ListTile(
                tileColor: Colors.black,
                title: const Text(
                  'Sair',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                onTap: () {
                  authService.logout();
                  Navigator.pushReplacement(
                    context,
                    AnimatedPageTransition(
                      page: const LoginPageView(),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
