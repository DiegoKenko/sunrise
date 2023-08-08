import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:result_dart/result_dart.dart';
import 'package:sunrise/entity/mood_matching_entity.dart';
import 'package:sunrise/services/getIt/get_it_dependencies.dart';

class LobbyMoodMatchingDatasource {
  Future<Result<bool, Exception>> call({
    required MoodMatchingEntity moodMatching,
    required String lobbyId,
    required String loverId,
  }) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> doc =
          await getIt<FirebaseFirestore>()
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
      return const Success(true);
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}
