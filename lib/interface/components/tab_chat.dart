import 'package:flutter/material.dart';
import 'package:sunrise/constants/styles.dart';
import 'package:sunrise/interface/controllers/auth/auth_controller.dart';
import 'package:sunrise/interface/controllers/chat/chat_controller.dart';
import 'package:sunrise/interface/states/chat_state.dart';
import 'package:sunrise/services/getIt/get_it_dependencies.dart';
import 'package:sunrise/entity/chat_message_entity.dart';
import 'package:intl/intl.dart';

class TabChat extends StatefulWidget {
  const TabChat({Key? key}) : super(key: key);
  @override
  State<TabChat> createState() => _TabChatState();
}

class _TabChatState extends State<TabChat> {
  final _textChatController = TextEditingController();
  final _listChatController = ScrollController();
  late ChatController chatController;

  @override
  void initState() {
    _listChatController.addListener(() {
      if (_listChatController.position.pixels ==
          _listChatController.position.minScrollExtent) {}
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final AuthController authService = getIt<AuthController>();
    return ValueListenableBuilder(
      valueListenable: chatController,
      builder: (context, state, _) {
        return Container(
          decoration: kBackgroundDecorationDark,
          child: state is ChatStateWatching
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          controller: _listChatController,
                          shrinkWrap: true,
                          itemCount: state.messages.length,
                          itemBuilder: (context, index) {
                            if (authService.lover.id ==
                                state.messages[index].sentBy) {
                              return ChatBaloonRight(
                                message: state.messages[index],
                              );
                            } else {
                              return ChatBaloonLeft(
                                message: state.messages[index],
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
                                  if (_textChatController.text.isNotEmpty) {}
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
                )
              : Center(
                  child: Text(
                    'não tem nada aqui',
                    style: kTextChatMessageStyle.copyWith(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
        );
      },
    );
  }
}

class ChatBaloonLeft extends StatelessWidget {
  const ChatBaloonLeft({Key? key, required this.message}) : super(key: key);
  final ChatMessageEntity message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 10,
        right: MediaQuery.of(context).size.width * 0.5,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: k2LevelColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  DateFormat('dd/MM HH:mm').format(message.dateTime),
                  style: kDateTimeChatTextStyle,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  message.message,
                  style: kTextChatMessageStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChatBaloonRight extends StatelessWidget {
  const ChatBaloonRight({Key? key, required this.message}) : super(key: key);
  final ChatMessageEntity message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.5,
          right: 10,
        ),
        child: Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: kPrimaryColor.withOpacity(0.8),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Text(
                  DateFormat('dd/MM HH:mm').format(message.dateTime),
                  style: kDateTimeChatTextStyle,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  message.message,
                  style: kTextChatMessageStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
