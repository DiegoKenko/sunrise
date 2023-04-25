import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sunrise/constants/styles.dart';
import 'package:sunrise/datasource/mock_moods.dart';
import 'package:sunrise/domain/auth/bloc_auth.dart';
import 'package:sunrise/domain/lobby/bloc_lobby.dart';
import 'package:sunrise/domain/viewmodel_mood.dart';
import 'package:sunrise/model/model_lover.dart';
import 'package:sunrise/model/model_mood_matching.dart';
import 'package:sunrise/services/getIt/get_it_dependencies.dart';

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
    final AuthService authService = getIt<AuthService>();
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return MoodMatchingSlider(
          edit: authService.lover!.id == widget.lover.id,
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
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60),
                      color: Colors.white.withOpacity(0.1),
                    ),
                    child: Image.asset(
                      viewModelMoodMatching.state.moodMatching.mood1.icon,
                    ),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Icon(
                          Icons.circle,
                          color: sliderGradientColors.first,
                          size: 4,
                        ),
                      ),
                      Expanded(
                        child: Slider(
                          inactiveColor: Colors.transparent,
                          activeColor: Colors.transparent,
                          thumbColor: sliderGradientColors[viewModelMoodMatching
                              .state.moodMatching.matching
                              .toInt()],
                          label: viewModelMoodMatching
                              .state.moodMatching.matching
                              .toString(),
                          value:
                              viewModelMoodMatching.state.moodMatching.matching,
                          min: viewModelMoodMatching.state.moodMatching.min,
                          max: viewModelMoodMatching.state.moodMatching.max,
                          divisions: (viewModelMoodMatching
                                      .state.moodMatching.max -
                                  viewModelMoodMatching.state.moodMatching.min)
                              .toInt(),
                          onChanged: (double value) {
                            if (widget.edit) {
                              viewModelMoodMatching.updateMatching(value);
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: Icon(
                          Icons.circle,
                          color: sliderGradientColors.last,
                          size: 4,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60),
                      color: Colors.white.withOpacity(0.1),
                    ),
                    child: Image.asset(
                      viewModelMoodMatching.state.moodMatching.mood2.icon,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
