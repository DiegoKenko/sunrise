import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sunrise/data/data_provider_chat.dart';
import 'package:sunrise/data/data_provider_lover.dart';
import 'package:sunrise/model/model_chat_message.dart';
import 'package:sunrise/model/model_lobby.dart';
import 'package:sunrise/model/model_lover.dart';

abstract class ChatEvent {}

class ChatEventAdd extends ChatEvent {
  final ChatMessage message;
  final Lobby lobby;
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

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatStateInitial()) {
    on<ChatEventAdd>((event, emit) async {
      await DataProviderChat().add(event.lobby.id, event.message);
    });

    on<ChatEventWatch>((event, emit) async {
      await emit.forEach(
        DataProviderChat()
            .watch(event.lobbyId, limit: state.limit + event.increseLimit),
        onData: (data) {
          return ChatStateWatching(
            data.docs.map((e) => ChatMessage.fromJson(e.data())).toList(),
            state.limit + event.increseLimit,
          );
        },
      );
    });
  }
}
