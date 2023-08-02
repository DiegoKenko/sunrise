import 'package:flutter/material.dart';
import 'package:sunrise/datasource/lobby/chat/lobby_chat_add_datasource.dart';
import 'package:sunrise/datasource/lobby/chat/lobby_chat_watch_datasource.dart';
import 'package:sunrise/entity/chat_message_entity.dart';
import 'package:sunrise/entity/lobby_entity.dart';
import 'package:sunrise/interface/states/chat_state.dart';

class ChatController extends ValueNotifier<ChatState> {
  LobbyChatWatchDatasource lobbyChatWatchDatasource;
  LobbyChatAddDataSource lobbyChatAddDataSource;
  ChatController(this.lobbyChatAddDataSource, this.lobbyChatWatchDatasource)
      : super(ChatStateInitial());

  sendMessage(LobbyEntity lobby, ChatMessageEntity message) async {
    await lobbyChatAddDataSource(lobby.id, message);
  }

  watch(LobbyEntity lobby, int limit) async {
    lobbyChatWatchDatasource(lobby.id).listen((event) {
      value = ChatStateWatching(event, limit);
    });
  }
}
