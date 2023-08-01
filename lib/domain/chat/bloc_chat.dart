import 'package:flutter/material.dart';
import 'package:sunrise/datasource/data_provider_chat.dart';
import 'package:sunrise/model/model_chat_message.dart';
import 'package:sunrise/model/model_lobby.dart';

abstract class ChatEvent {}

class ChatEventAdd extends ChatEvent {
  final ChatMessage message;
  final LobbyEntity lobby;
  ChatEventAdd(this.message, this.lobby);
}

class ChatEventWatch extends ChatEvent {
  final String lobbyId;
  final int increseLimit;
  ChatEventWatch(this.lobbyId, {this.increseLimit = 0});
}

abstract class ChatState {
  List<ChatMessage> messages = [];
  int limit;
  ChatState(this.messages, {this.limit = 0});
}

class ChatStateInitial extends ChatState {
  ChatStateInitial() : super([]);
}

class ChatStateWatching extends ChatState {
  ChatStateWatching(List<ChatMessage> messages, int limit)
      : super(messages, limit: limit);
}

class ChatController extends ValueNotifier<ChatState> {
  ChatController(super.value);

  onChatEventAdd(LobbyEntity lobby, ChatMessage message) async {
    await DataProviderChat().add(lobby.id, message);
  }

  onChatEventWatch() async {}
}
