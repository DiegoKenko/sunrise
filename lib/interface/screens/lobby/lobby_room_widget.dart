import 'package:flutter/material.dart';
import 'package:sunrise/constants/styles.dart';
import 'package:sunrise/interface/components/animated_page_transition.dart';
import 'package:sunrise/interface/screens/lobby/expandable_logout_leave.dart';
import 'package:sunrise/interface/screens/lobby/lobby_lover_widget.dart';
import 'package:sunrise/interface/screens/relationship/relationship_page_view.dart';
import 'package:sunrise/interface/states/lobby_state.dart';

class LobbyRoomWidget extends StatelessWidget {
  const LobbyRoomWidget({
    super.key,
    required this.controller,
    required this.lobbyState,
  });
  final ValueNotifier<bool> controller;
  final LobbyState lobbyState;

  @override
  Widget build(BuildContext context) {
    bool relationshipVisible = lobbyState is LobbyStateSuccessReady;
    return SizedBox(
      child: Column(
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
                            lobbyState.lobby.simpleId,
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
                    onPressed: () {
                      controller.value = false;
                    },
                    color: Colors.white,
                    icon: const Icon(
                      Icons.search_rounded,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Stack(
            children: [
              Align(
                child: LoversLobbyWidget(),
              ),
              Positioned(
                bottom: 20,
                left: 0,
                child: ExpandableLogoutAndLeave(),
              ),
            ],
          ),
          Visibility(
            visible: relationshipVisible,
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: 150,
                height: 50,
                decoration: kLobbyRightBoxDecoration,
                padding: const EdgeInsets.all(2.0),
                child: TextButton(
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(
                      kPrimaryColor,
                    ),
                    elevation: MaterialStateProperty.all(10),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    animationDuration: const Duration(milliseconds: 500),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      AnimatedPageTransition(
                        page: const RelationshipPageView(),
                      ),
                    );
                  },
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                        size: 25,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
