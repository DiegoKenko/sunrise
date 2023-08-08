import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sunrise/entity/mood_matching_entity.dart';
import 'package:sunrise/services/getIt/get_it_dependencies.dart';

class LobbyMoodMatchingListenDatasource {
  Stream<MoodMatchingEntity> call({
    required String lobbyId,
    required String moodId,
    required String loverId,
  }) {
    return getIt<FirebaseFirestore>()
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
