import 'package:flutter/material.dart';
import 'package:sunrise/interface/controllers/auth/auth_controller.dart';
import 'package:sunrise/interface/controllers/lobby/lobby_controller.dart';
import 'package:sunrise/interface/controllers/widgets/avatar_change_controller.dart';
import 'package:sunrise/interface/screens/lobby/avatar_widget.dart';
import 'package:sunrise/services/getIt/get_it_dependencies.dart';

class LoversLobbyWidget extends StatefulWidget {
  const LoversLobbyWidget({
    super.key,
  });

  @override
  State<LoversLobbyWidget> createState() => _LoversLobbyAtualState();
}

class _LoversLobbyAtualState extends State<LoversLobbyWidget> {
  final AvatarChangeController _avatarChangeController =
      AvatarChangeController();
  final LobbyController lobbyController = getIt<LobbyController>();
  final AuthController authController = getIt<AuthController>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadAssets(),
      builder: (context, snap) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ValueListenableBuilder(
            valueListenable: lobbyController,
            builder: (context, state, _) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  AvatarWidget(
                    lover: authController.lover,
                    edit: true,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  AvatarWidget(
                    lover: state.lobby.couple(
                      authController.lover.id,
                    ),
                  )
                ],
              );
            },
          ),
        );
      },
    );
  }

  _loadAssets() {
    for (var element in _avatarChangeController.avatarsAvailable) {
      precacheImage(AssetImage(element), context);
    }
  }
}
