import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sunrise/constants/constants.dart';
import 'package:sunrise/model/model_chat_message.dart';

class DataProviderChat {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> add(String lobbyId, ChatMessage message) async {
    await _firestore
        .collection('lobby')
        .doc(lobbyId)
        .collection('chat')
        .add(message.toJson());
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> watch(
    String lobbyId, {
    int limit = chatMessageLimit,
  }) {
    if (limit <= 0) {
      limit = chatMessageLimit;
    }
    return _firestore
        .collection('lobby')
        .doc(lobbyId)
        .collection('chat')
        .orderBy('dateTime', descending: false)
        .limitToLast(limit)
        .snapshots();
  }
}
