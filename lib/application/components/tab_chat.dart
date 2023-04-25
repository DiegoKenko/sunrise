import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sunrise/constants/constants.dart';
import 'package:sunrise/constants/styles.dart';
import 'package:sunrise/domain/auth/bloc_auth.dart';
import 'package:sunrise/domain/chat/bloc_chat.dart';
import 'package:sunrise/domain/lobby/bloc_lobby.dart';
import 'package:sunrise/services/getIt/get_it_dependencies.dart';
import 'package:sunrise/services/notification/firebase_messaging_service.dart';
import 'package:sunrise/model/model_chat_message.dart';
import 'package:intl/intl.dart';

class TabChat extends StatefulWidget {
  const TabChat({Key? key}) : super(key: key);
  @override
  State<TabChat> createState() => _TabChatState();
}

class _TabChatState extends State<TabChat> {
  final _textChatController = TextEditingController();
  final _listChatController = ScrollController();

  @override
  void initState() {
    _listChatController.addListener(() {
      if (_listChatController.position.pixels ==
          _listChatController.position.minScrollExtent) {
        context.read<ChatBloc>().add(
              ChatEventWatch(
                context.read<LobbyBloc>().state.lobby.id,
                increseLimit: chatMessageLimit,
              ),
            );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final AuthService authService = getIt<AuthService>();
    return BlocBuilder<ChatBloc, ChatState>(
      bloc: context.read<ChatBloc>()
        ..add(
          ChatEventWatch(
            context.read<LobbyBloc>().state.lobby.id,
          ),
        ),
      builder: (context, state) {
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
                            if (authService.lover!.id ==
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
                                  if (_textChatController.text.isNotEmpty) {
                                    final ChatMessage chatMessage = ChatMessage(
                                      _textChatController.text,
                                      authService.lover!.id,
                                      DateTime.now(),
                                    );
                                    context.read<ChatBloc>().add(
                                          ChatEventAdd(
                                            // ignore: require_trailing_commas
                                            chatMessage,
                                            context
                                                .read<LobbyBloc>()
                                                .state
                                                .lobby,
                                          ),
                                        );
                                    context
                                        .read<FirebaseMessagingService>()
                                        .sendMessage(
                                          context
                                              .read<LobbyBloc>()
                                              .state
                                              .lobby
                                              .couple(
                                                authService.lover!.id,
                                              )
                                              .notificationToken,
                                          chatMessage,
                                        );

                                    _textChatController.clear();
                                    _listChatController.jumpTo(
                                      _listChatController
                                          .position.maxScrollExtent,
                                    );
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
  final ChatMessage message;

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
  final ChatMessage message;

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
