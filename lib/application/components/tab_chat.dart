import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sunrise/application/constants.dart';
import 'package:sunrise/application/styles.dart';
import 'package:sunrise/domain/auth/bloc_auth.dart';
import 'package:sunrise/domain/chat/bloc_chat.dart';
import 'package:sunrise/domain/bloc_lobby.dart';
import 'package:sunrise/domain/notification/firebase_messaging_service.dart';
import 'package:sunrise/model/model_chat_message.dart';

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
                            if (context.read<AuthBloc>().state.lover.id ==
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
                                      context.read<AuthBloc>().state.lover.id,
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
                                                context
                                                    .read<AuthBloc>()
                                                    .state
                                                    .lover
                                                    .id,
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
                    'No messages yet',
                    style: kTextChatMessageStyle.copyWith(
                      fontSize: 20,
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
          child: Text(
            message.message,
            style: kTextChatMessageStyle,
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
          child: Text(
            message.message,
            style: kTextChatMessageStyle,
          ),
        ),
      ),
    );
  }
}
