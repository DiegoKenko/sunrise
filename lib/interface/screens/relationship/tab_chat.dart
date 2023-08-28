import 'package:flutter/material.dart';
import 'package:sunrise/constants/styles.dart';
import 'package:sunrise/interface/controllers/auth/auth_controller.dart';
import 'package:sunrise/interface/controllers/chat/chat_controller.dart';
import 'package:sunrise/interface/controllers/lobby/lobby_controller.dart';
import 'package:sunrise/interface/screens/relationship/chat_baloon.dart';
import 'package:sunrise/services/getIt/get_it_dependencies.dart';
import 'package:sunrise/entity/chat_message_entity.dart';

class TabChat extends StatefulWidget {
  const TabChat({Key? key}) : super(key: key);
  @override
  State<TabChat> createState() => _TabChatState();
}

class _TabChatState extends State<TabChat> {
  final _textChatController = TextEditingController();
  final _listChatController = ScrollController();
  final ChatController chatController = getIt<ChatController>();
  final AuthController authService = getIt<AuthController>();
  final LobbyController lobbyController = getIt<LobbyController>();
  int limit = 20;

  @override
  void initState() {
    chatController.watch(lobbyController.value.lobby, limit);
    super.initState();
  }

  void _animateToBottom() {
    _listChatController.animateTo(
      _listChatController.position.minScrollExtent,
      duration: const Duration(seconds: 2),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: chatController,
      builder: (context, state, _) {
        return Container(
          decoration: kBackgroundDecorationDark,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    controller: _listChatController,
                    shrinkWrap: true,
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      int reversedIndex = state.messages.length - index - 1;
                      if (authService.lover.id ==
                          state.messages[reversedIndex].sentById) {
                        return ChatBaloon(
                          position: EnumPosition.right,
                          message: state.messages[reversedIndex],
                        );
                      } else {
                        return ChatBaloon(
                          position: EnumPosition.left,
                          message: state.messages[reversedIndex],
                        );
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: SizedBox(
                    height: 50,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              enabledBorder: kOutlineInputBorder,
                              focusedBorder: kOutlineInputBorder,
                              label: const Text(
                                '',
                                style: kTextFormFieldLobbyLabelStyle,
                              ),
                            ),
                            style: kTextFormFieldChatStyle,
                            controller: _textChatController,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            if (_textChatController.text.isNotEmpty) {
                              chatController.sendMessage(
                                lobbyController.value.lobby,
                                ChatMessageEntity(
                                  _textChatController.text,
                                  authService.lover.id,
                                  authService.lover.name,
                                  DateTime.now(),
                                ),
                              );
                              _textChatController.clear();
                              _animateToBottom();
                            }
                          },
                          icon: const Icon(
                            Icons.send,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
