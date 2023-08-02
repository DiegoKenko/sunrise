import 'package:flutter/material.dart';
import 'package:sunrise/interface/controllers/lobby/lobby_controller.dart';
import 'package:sunrise/interface/controllers/widgets/avatar_change_controller.dart';
import 'package:sunrise/interface/screens/lobby/avatar_widget.dart';
import 'package:sunrise/services/getIt/get_it_dependencies.dart';

class LoversLobbyAtual extends StatefulWidget {
  const LoversLobbyAtual({
    super.key,
  });

  @override
  State<LoversLobbyAtual> createState() => _LoversLobbyAtualState();
}

class _LoversLobbyAtualState extends State<LoversLobbyAtual> {
  final AvatarChangeController _avatarChangeController =
      AvatarChangeController();
  final LobbyController lobbyController = getIt<LobbyController>();

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
                    lover: state.lobby.lovers[0],
                    edit: true,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  AvatarWidget(lover: state.lobby.lovers[1])
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
