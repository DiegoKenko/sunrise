import 'package:sunrise/data/data_provider_mood_matching.dart';
import 'package:sunrise/model/model_lover.dart';
import 'package:sunrise/model/model_mood_matching.dart';

class MoodState {
  MoodMatching moodMatching;
  Lover lover;

  MoodState({
    required this.lover,
    required this.moodMatching,
  });
}

class ViewModelMood {
  MoodState state;
  ViewModelMood(this.state);

  Stream<MoodMatching> listenMood() {
    return DataProviderMoodMatching().listenMood(
      lobbyId: state.lover.lobbyId,
      moodId: state.moodMatching.matchId,
      loverId: state.lover.id,
    );
  }

  void updateMatching(double match) {
    MoodMatching moodMatching = state.moodMatching;
    if (match < 1) {
      moodMatching.matching = 1;
    } else if (match > 10) {
      moodMatching.matching = 10;
    } else {
      moodMatching.matching = match;
    }

    DataProviderMoodMatching().update(
      moodMatching: moodMatching,
      lobbyId: state.lover.lobbyId,
      loverId: state.lover.id,
    );
  }
}
