import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sunrise/constants/constants.dart';
import 'package:sunrise/entity/chat_message_entity.dart';
import 'package:sunrise/services/getIt/get_it_dependencies.dart';

class LobbyChatWatchDatasource {
  Stream<List<ChatMessageEntity>> call(
    String lobbyId, {
    int limit = chatMessageLimit,
  }) async* {
    if (limit <= 0) {
      limit = chatMessageLimit;
    }
    Stream<QuerySnapshot<Map<String, dynamic>>> stream =
        getIt<FirebaseFirestore>()
            .collection('lobby')
            .doc(lobbyId)
            .collection('chat')
            .orderBy('dateTime', descending: false)
            .limitToLast(limit)
            .snapshots();

    stream.toString();

    yield* stream.map<List<ChatMessageEntity>>((event) {
      List<ChatMessageEntity> messages = [];
      for (var element in event.docs) {
        messages.add(ChatMessageEntity.fromJson(element.data()));
      }
      return messages;
    });
  }
}
