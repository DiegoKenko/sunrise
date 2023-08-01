import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sunrise/constants/constants.dart';
import 'package:sunrise/services/getIt/get_it_dependencies.dart';

class LobbyChatWatchDatasource {
  Stream<QuerySnapshot<Map<String, dynamic>>> call(
    String lobbyId, {
    int limit = chatMessageLimit,
  }) {
    if (limit <= 0) {
      limit = chatMessageLimit;
    }
    return getIt<FirebaseFirestore>()
        .collection('lobby')
        .doc(lobbyId)
        .collection('chat')
        .orderBy('dateTime', descending: false)
        .limitToLast(limit)
        .snapshots();
  }
}
