import 'package:sunrise/entity/chat_message_entity.dart';

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
