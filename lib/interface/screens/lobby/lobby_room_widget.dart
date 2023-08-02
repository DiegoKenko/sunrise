import 'package:flutter/material.dart';
import 'package:sunrise/constants/styles.dart';
import 'package:sunrise/interface/components/animated_page_transition.dart';
import 'package:sunrise/interface/controllers/auth/auth_controller.dart';
import 'package:sunrise/interface/controllers/lobby/lobby_controller.dart';
import 'package:sunrise/interface/screens/lobby/expandable_logout_leave.dart';
import 'package:sunrise/interface/screens/lobby/lobby_lover_widget.dart';
import 'package:sunrise/interface/screens/relationship/relationship_page_view.dart';
import 'package:sunrise/interface/states/lobby_state.dart';
import 'package:sunrise/services/getIt/get_it_dependencies.dart';

class LobbyRoomWidget extends StatefulWidget {
  const LobbyRoomWidget({super.key, required this.onPop});
  final Function() onPop;

  @override
  State<LobbyRoomWidget> createState() => _LobbyRoomWidgetState();
}

class _LobbyRoomWidgetState extends State<LobbyRoomWidget> {
  final LobbyController lobbyController = getIt<LobbyController>();

  final AuthController authController = getIt<AuthController>();

  @override
  void initState() {
    lobbyController.init(authController.lover);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ValueListenableBuilder(
        valueListenable: lobbyController,
        builder: (context, state, _) {
          bool relationshipVisible = state is LobbyStateSuccessReady;
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                children: [
                  Material(
                    elevation: 10,
                    shadowColor: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    color: Colors.white,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 20,
                            top: 8,
                            bottom: 8,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'ID da sala',
                                style: kTextLobbyStyle.copyWith(
                                  letterSpacing: 1,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                state.lobby.simpleId,
                                style: kTextLobbyStyle,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(child: Container()),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      decoration: kLobbyRightBoxDecoration,
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: IconButton(
                        onPressed: widget.onPop,
                        color: Colors.white,
                        icon: const Icon(
                          Icons.search_rounded,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const LoversLobbyWidget(),
              Stack(
                children: [
                  const ExpandableLogoutAndLeave(),
                  Visibility(
                    visible: relationshipVisible,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        width: 150,
                        decoration: kLobbyRightBoxDecoration,
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              AnimatedPageTransition(
                                page: const RelationshipPageView(),
                              ),
                            );
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Próximo',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              Icon(
                                Icons.chevron_right,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
