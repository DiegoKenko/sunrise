import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sunrise/entity/chat_message_entity.dart';
import 'package:sunrise/services/getIt/get_it_dependencies.dart';

class LobbyChatAddDataSource {
  Future<void> call(String lobbyId, ChatMessageEntity message) async {
    var test = await getIt<FirebaseFirestore>()
        .collection('lobby')
        .doc(lobbyId)
        .collection('chat')
        .add(message.toJson());
  }
}
