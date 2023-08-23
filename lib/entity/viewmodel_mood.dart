import 'package:sunrise/datasource/lobby/moodMatching/lobby_mood_matching_listen.dart';
import 'package:sunrise/datasource/lobby/moodMatching/lobby_mood_matching_update.dart';
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
  final LobbyMoodMatchingListenDatasource lobbyMoodMatchingListen =
      LobbyMoodMatchingListenDatasource();
  final LobbyMoodMatchingDatasource lobbyMoodMatchingDatasource =
      LobbyMoodMatchingDatasource();
  Stream<MoodMatchingEntity> listenMood() {
    return lobbyMoodMatchingListen(
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

    lobbyMoodMatchingDatasource(
      moodMatching: moodMatching,
      lobbyId: lobbyID,
      loverId: state.lover.id,
    );
  }

  void updateFavorite(bool favorite) {
    MoodMatchingEntity moodMatching = state.moodMatching;
    moodMatching.favorite = favorite;

    lobbyMoodMatchingDatasource(
      moodMatching: moodMatching,
      lobbyId: lobbyID,
      loverId: state.lover.id,
    );
  }
}
