import 'package:sunrise/datasource/data_provider_mood_matching.dart';
import 'package:sunrise/entity/lover_entity.dart';
import 'package:sunrise/entity/mood_matching_entity.dart';

class MoodState {
  MoodMatchingEntity moodMatching;
  LoverEntity lover;

  MoodState({
    required this.lover,
    required this.moodMatching,
  });
}

class ViewModelMood {
  final MoodState state;
  final String lobbyID;
  ViewModelMood({required this.state, required this.lobbyID});

  Stream<MoodMatchingEntity> listenMood() {
    return DataProviderMoodMatching().listenMood(
      lobbyId: lobbyID,
      moodId: state.moodMatching.matchId,
      loverId: state.lover.id,
    );
  }

  void updateMatching(double match) {
    MoodMatchingEntity moodMatching = state.moodMatching;
    if (match < 1) {
      moodMatching.matching = 1;
    } else if (match > 10) {
      moodMatching.matching = 10;
    } else {
      moodMatching.matching = match;
    }

    DataProviderMoodMatching().update(
      moodMatching: moodMatching,
      lobbyId: lobbyID,
      loverId: state.lover.id,
    );
  }
}
