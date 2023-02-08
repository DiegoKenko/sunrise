import 'package:bloc/bloc.dart';
import 'package:sunrise/data/data_provider_mood_matching.dart';
import 'package:sunrise/model/model_lobby.dart';
import 'package:sunrise/model/model_mood_matching.dart';

class MoodState {
  MoodMatching moodMatching;
  Lobby lobby;

  MoodState({
    required this.moodMatching,
    required this.lobby,
  });
}

class CubitMyMood extends Cubit<MoodState> {
  CubitMyMood({
    required MoodMatching matching,
    required Lobby lobby,
  }) : super(
          MoodState(
            moodMatching: matching,
            lobby: lobby,
          ),
        );

  void updateMatching(int match) {
    if (match < 1) {
      match = 1;
    } else if (match > 10) {
      match = 10;
    }

    emit(
      MoodState(
        moodMatching: MoodMatching(
          mood1: state.moodMatching.mood1,
          mood2: state.moodMatching.mood2,
          matching: match,
        ),
        lobby: state.lobby,
      ),
    );

    DataProviderMoodMatching().update(
      state.moodMatching,
      state.lobby,
    );
  }
}

class CubitCoupleMood extends Cubit<MoodState> {
  CubitCoupleMood({
    required MoodMatching matching,
    required Lobby lobby,
  }) : super(
          MoodState(
            moodMatching: matching,
            lobby: lobby,
          ),
        );

  
}

