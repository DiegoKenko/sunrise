import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sunrise/data/mock_moods.dart';
import 'package:sunrise/domain/bloc_auth.dart';
import 'package:sunrise/domain/bloc_lobby.dart';
import 'package:sunrise/domain/viewmodel_mood.dart';
import 'package:sunrise/model/model_lover.dart';
import 'package:sunrise/model/model_mood_matching.dart';

class TabMood extends StatefulWidget {
  const TabMood({
    Key? key,
    required this.lover,
  }) : super(key: key);
  final Lover lover;
  @override
  State<TabMood> createState() => _TabMoodState();
}

class _TabMoodState extends State<TabMood> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.all(20),
      itemBuilder: (context, index) {
        return MoodMatchingSlider(
          edit: context.watch<AuthBloc>().state.lover.id == widget.lover.id,
          lover: widget.lover,
          moodMatch: mockMoodMatching[index],
        );
      },
      itemCount: mockMoodMatching.length,
    );
  }
}

class MoodMatchingSlider extends StatefulWidget {
  const MoodMatchingSlider({
    Key? key,
    required this.lover,
    required this.moodMatch,
    required this.edit,
  }) : super(key: key);
  final Lover lover;
  final MoodMatching moodMatch;
  final bool edit;

  @override
  State<MoodMatchingSlider> createState() => _MoodMatchingSliderState();
}

class _MoodMatchingSliderState extends State<MoodMatchingSlider> {
  @override
  Widget build(BuildContext context) {
    ViewModelMood viewModelMoodMatching = ViewModelMood(
      state: MoodState(
        lover: widget.lover,
        moodMatching: widget.moodMatch,
      ),
      lobbyID: context.read<LobbyBloc>().state.lobby.id,
    );
    return StreamBuilder(
      stream: viewModelMoodMatching.listenMood(),
      builder: (context, AsyncSnapshot<MoodMatching> snap) {
        if (!snap.hasData) {
          viewModelMoodMatching.state.moodMatching = MoodMatching(
            mood1: widget.moodMatch.mood1,
            mood2: widget.moodMatch.mood2,
            matching: 5,
            pack: widget.moodMatch.pack,
          );
        } else {
          viewModelMoodMatching.state.moodMatching = snap.data!;
        }
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Image.asset(
                  viewModelMoodMatching.state.moodMatching.mood1.icon,
                  scale: viewModelMoodMatching.state.moodMatching.mood1scale,
                ),
              ),
              Expanded(
                flex: 6,
                child: Slider(
                  activeColor: Color.fromRGBO(
                    245,
                    20 +
                        8 *
                            viewModelMoodMatching.state.moodMatching.matching
                                .toInt(),
                    10 +
                        10 *
                            viewModelMoodMatching.state.moodMatching.matching
                                .toInt(),
                    1,
                  ),
                  inactiveColor: Color.fromRGBO(
                    20,
                    150 -
                        5 *
                            viewModelMoodMatching.state.moodMatching.matching
                                .toInt(),
                    65 -
                        6 *
                            viewModelMoodMatching.state.moodMatching.matching
                                .toInt(),
                    0.5,
                  ),
                  label: viewModelMoodMatching.state.moodMatching.matching
                      .toString(),
                  value: viewModelMoodMatching.state.moodMatching.matching,
                  min: viewModelMoodMatching.state.moodMatching.min,
                  max: viewModelMoodMatching.state.moodMatching.max,
                  divisions: (viewModelMoodMatching.state.moodMatching.max -
                          viewModelMoodMatching.state.moodMatching.min)
                      .toInt(),
                  onChanged: (double value) {
                    if (widget.edit) {
                      viewModelMoodMatching.updateMatching(value);
                    }
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: Image.asset(
                  viewModelMoodMatching.state.moodMatching.mood2.icon,
                  scale: viewModelMoodMatching.state.moodMatching.mood2scale,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
