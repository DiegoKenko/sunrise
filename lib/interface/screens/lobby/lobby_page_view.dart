import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:sunrise/interface/controllers/auth/auth_controller.dart';
import 'package:sunrise/interface/controllers/lobby/lobby_controller.dart';
import 'package:sunrise/interface/screens/lobby/lobby_join_widget.dart';
import 'package:sunrise/interface/screens/lobby/lobby_room_widget.dart';
import 'package:sunrise/constants/styles.dart';

import 'package:sunrise/services/getIt/get_it_dependencies.dart';

class LobbyPageView extends StatefulWidget {
  const LobbyPageView({Key? key}) : super(key: key);
  @override
  State<LobbyPageView> createState() => _ScreenLobbyState();
}

class _ScreenLobbyState extends State<LobbyPageView>
    with TickerProviderStateMixin {
  final _currentRoomExpandableController =
      ExpandableController(initialExpanded: true);
  final _searchRoomExpandableController =
      ExpandableController(initialExpanded: false);
  final LobbyController lobbyController = getIt<LobbyController>();
  final AuthController authController = getIt<AuthController>();
  final isCurrentLobbyActiveController = ValueNotifier<bool>(true);

  @override
  void initState() {
    lobbyController.lobbyInitAndWatch(authController.lover);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Container(
          decoration: kBackgroundDecorationDark,
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: SafeArea(
            child: ValueListenableBuilder(
              valueListenable: lobbyController,
              builder: (context, lobbyState, _) {
                return ValueListenableBuilder(
                  valueListenable: isCurrentLobbyActiveController,
                  builder: (context, isCurrentLobbyActive, _) {
                    _currentRoomExpandableController.expanded =
                        isCurrentLobbyActive;
                    _searchRoomExpandableController.expanded =
                        !_currentRoomExpandableController.expanded;

                    return Column(
                      children: [
                        Expandable(
                          controller: _currentRoomExpandableController,
                          expanded: LobbyRoomWidget(
                            lobbyState: lobbyState,
                            controller: isCurrentLobbyActiveController,
                          ),
                          collapsed: Container(
                            color: Colors.transparent,
                          ),
                        ),
                        Expandable(
                          controller: _searchRoomExpandableController,
                          expanded: LobbyJoinWidget(
                              controller: isCurrentLobbyActiveController,),
                          collapsed: Container(
                            color: Colors.transparent,
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
