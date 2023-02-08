import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sunrise/model/model_lobby.dart';
import 'package:sunrise/model/model_mood_matching.dart';

class DataProviderMoodMatching {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> update(MoodMatching moodMatching, Lobby lobby) async {
    await _firestore
        .collection('lobby')
        .doc(lobby.id)
        .collection('moodMatching')
        .doc(moodMatching.matchId)
        .set(moodMatching.toJson());
  }

  Stream<MoodMatching> listenMood(
    Lobby lobby,
    String moodId,
  ) {
    Future<DocumentSnapshot<Map<String, dynamic>>> doc = _firestore
        .collection('lobby')
        .doc(lobby.id)
        .collection('moodMatching')
        .doc(moodId)
        .get();
    return doc.asStream().map((event) {
      return MoodMatching.fromJson(event.data()!);
    });
  }

  Future<MoodMatching> get(String matchId, Lobby lobby) async {
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await _firestore
        .collection('lobby')
        .doc(lobby.id)
        .collection('moodMatching')
        .doc(matchId)
        .get();

    return MoodMatching.fromJson(documentSnapshot.data()!);
  }
}
