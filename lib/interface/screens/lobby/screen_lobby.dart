import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sunrise/interface/components/animated_page_transition.dart';
import 'package:sunrise/interface/controllers/widgets/avatar_change_controller.dart';
import 'package:sunrise/interface/screens/lobby/avatar_widget.dart';
import 'package:sunrise/interface/screens/lobby/expandable_logout_leave.dart';
import 'package:sunrise/interface/screens/relationship/screen_relationship.dart';
import 'package:sunrise/constants/styles.dart';
import 'package:sunrise/interface/controllers/lobby/lobby_controller.dart';
import 'package:sunrise/interface/states/lobby_state.dart';
import 'package:sunrise/entity/lobby_entity.dart';

import 'package:sunrise/services/getIt/get_it_dependencies.dart';

class ScreenLobby extends StatefulWidget {
  const ScreenLobby({Key? key}) : super(key: key);
  @override
  State<ScreenLobby> createState() => _ScreenLobbyState();
}

class _ScreenLobbyState extends State<ScreenLobby>
    with TickerProviderStateMixin {
  final _salaAtualController = ExpandableController(initialExpanded: true);
  final _novaSalaController = ExpandableController(initialExpanded: false);
  final _lobbyController = TextEditingController();
  final LobbyController lobbyController = getIt<LobbyController>();

  @override
  void initState() {
    _salaAtualController.addListener(() {
      if (_novaSalaController.expanded == _salaAtualController.expanded) {
        _novaSalaController.toggle();
      }
    });
    _novaSalaController.addListener(() {
      if (_novaSalaController.expanded == _salaAtualController.expanded) {
        _salaAtualController.toggle();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: ValueListenableBuilder(
          valueListenable: lobbyController,
          builder: (context, lobbyState, _) {
            LobbyEntity lobby = lobbyState.lobby;
            bool relationShipVisible = lobbyState is LobbyStateSuccessReady;

            return Container(
              decoration: kBackgroundDecorationDark,
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: SafeArea(
                child: Column(
                  children: [
                    Expandable(
                      controller: _salaAtualController,
                      expanded: SizedBox(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Row(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    decoration: kLobbyLeftBoxDecoration,
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 20,
                                        top: 8,
                                        bottom: 8,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'LobbyEntity ID',
                                            style: kTextLobbyStyle.copyWith(
                                              letterSpacing: 1,
                                              fontSize: 12,
                                            ),
                                          ),
                                          Text(
                                            lobby.simpleId,
                                            style: kTextLobbyStyle,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(child: Container()),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Container(
                                    decoration: kLobbyRightBoxDecoration,
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _salaAtualController.toggle();
                                        });
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
                            const LoversLobbyAtual(),
                            Stack(
                              children: [
                                const ExpandableLogoutAndLeave(),
                                Visibility(
                                  visible: relationShipVisible,
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
                                              page: const ScreenRelationship(),
                                            ),
                                          );
                                        },
                                        child: const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                        ),
                      ),
                      collapsed: Container(
                        color: Colors.transparent,
                      ),
                    ),
                    Expandable(
                      controller: _novaSalaController,
                      expanded: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Container(
                              decoration: kLobbyLeftBoxDecoration.copyWith(
                                color: kPrimaryColor,
                              ),
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _novaSalaController.toggle();
                                  });
                                },
                                icon: const Icon(
                                  Icons.chevron_left,
                                  size: 40,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: TextField(
                              onChanged: (value) {
                                _lobbyController.value = TextEditingValue(
                                  text: value.toUpperCase(),
                                  selection: _lobbyController.selection,
                                );
                              },
                              decoration: InputDecoration(
                                enabledBorder: kOutlineInputBorder,
                                focusedBorder: kOutlineInputBorder,
                                label: const Text(
                                  'Código da sala',
                                  style: kTextFormFieldLobbyLabelStyle,
                                ),
                              ),
                              cursorColor: Colors.white,
                              textAlign: TextAlign.center,
                              style: kTextFormFieldLobbyStyle,
                              maxLength: 5,
                              maxLengthEnforcement:
                                  MaxLengthEnforcement.enforced,
                              obscureText: false,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'[a-zA-Z0-9]'),
                                ),
                              ],
                              controller: _lobbyController,
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: FilledButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  Colors.white,
                                ),
                              ),
                              onPressed: () {
                                if (_lobbyController.text.length != 5) {
                                  return;
                                }
                                _novaSalaController.toggle();
                              },
                              child: const Text(
                                'ENTRAR',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      collapsed: Container(
                        color: Colors.transparent,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

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
