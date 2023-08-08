import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:result_dart/result_dart.dart';
import 'package:sunrise/entity/chat_message_entity.dart';
import 'package:sunrise/services/getIt/get_it_dependencies.dart';

class LobbyChatAddDataSource {
  Future<Result<bool, Exception>> call(
    String lobbyId,
    ChatMessageEntity message,
  ) async {
    try {
      await getIt<FirebaseFirestore>()
          .collection('lobby')
          .doc(lobbyId)
          .collection('chat')
          .add(message.toJson());
      return const Success(true);
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}
