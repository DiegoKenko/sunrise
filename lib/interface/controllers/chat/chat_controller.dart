import 'package:flutter/material.dart';
import 'package:sunrise/datasource/lobby/chat/lobby_chat_add_datasource.dart';
import 'package:sunrise/entity/chat_message_entity.dart';
import 'package:sunrise/entity/lobby_entity.dart';
import 'package:sunrise/interface/states/chat_state.dart';

class ChatController extends ValueNotifier<ChatState> {
  LobbyChatAddDataSource lobbyChatAddDataSource;
  ChatController(this.lobbyChatAddDataSource) : super(ChatStateInitial());

  onChatEventAdd(LobbyEntity lobby, ChatMessageEntity message) async {
    await lobbyChatAddDataSource(lobby.id, message);
  }

  onChatEventWatch() async {}
}
