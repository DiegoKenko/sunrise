import 'package:flutter/material.dart';
import 'package:sunrise/datasource/data_provider_chat.dart';
import 'package:sunrise/entity/chat_message_entity.dart';
import 'package:sunrise/entity/lobby_entity.dart';

abstract class ChatEvent {}

class ChatEventAdd extends ChatEvent {
  final ChatMessageEntity message;
  final LobbyEntity lobby;
  ChatEventAdd(this.message, this.lobby);
}

class ChatEventWatch extends ChatEvent {
  final String lobbyId;
  final int increseLimit;
  ChatEventWatch(this.lobbyId, {this.increseLimit = 0});
}

abstract class ChatState {
  List<ChatMessageEntity> messages = [];
  int limit;
  ChatState(this.messages, {this.limit = 0});
}

class ChatStateInitial extends ChatState {
  ChatStateInitial() : super([]);
}

class ChatStateWatching extends ChatState {
  ChatStateWatching(List<ChatMessageEntity> messages, int limit)
      : super(messages, limit: limit);
}

class ChatController extends ValueNotifier<ChatState> {
  ChatController(super.value);

  onChatEventAdd(LobbyEntity lobby, ChatMessageEntity message) async {
    await DataProviderChat().add(lobby.id, message);
  }

  onChatEventWatch() async {}
}
