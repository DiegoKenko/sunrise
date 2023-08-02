import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sunrise/entity/mood_matching_entity.dart';

class DataProviderMoodMatching {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> update({
    required MoodMatchingEntity moodMatching,
    required String lobbyId,
    required String loverId,
  }) async {
    DocumentSnapshot<Map<String, dynamic>> doc = await _firestore
        .collection('lobby')
        .doc(lobbyId)
        .collection('lovers')
        .doc(loverId)
        .collection('moodMatching')
        .doc(moodMatching.matchId)
        .get();

    if (doc.exists) {
      doc.reference.update(moodMatching.toJson());
    } else {
      doc.reference.set(moodMatching.toJson());
    }
  }

  Stream<MoodMatchingEntity> listenMood({
    required String lobbyId,
    required String moodId,
    required String loverId,
  }) {
    return _firestore
        .collection('lobby')
        .doc(lobbyId)
        .collection('lovers')
        .doc(loverId)
        .collection('moodMatching')
        .doc(moodId)
        .snapshots()
        .map(
          (event) => MoodMatchingEntity.fromJson(event.data()!),
        );
  }
}
