import 'package:flutter/material.dart';
import 'package:sunrise/datasource/data_provider_chat.dart';
import 'package:sunrise/entity/chat_message_entity.dart';
import 'package:sunrise/entity/lobby_entity.dart';
import 'package:sunrise/interface/states/chat_state.dart';

class ChatController extends ValueNotifier<ChatState> {
  ChatController(super.value);

  onChatEventAdd(LobbyEntity lobby, ChatMessageEntity message) async {
    await DataProviderChat().add(lobby.id, message);
  }

  onChatEventWatch() async {}
}
