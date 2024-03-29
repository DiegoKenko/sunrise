import 'package:flutter/material.dart';
import 'package:sunrise/constants/styles.dart';
import 'package:sunrise/entity/lover_entity.dart';
import 'package:sunrise/entity/mood_matching_entity.dart';
import 'package:sunrise/entity/viewmodel_mood.dart';
import 'package:sunrise/interface/controllers/lobby/lobby_controller.dart';
import 'package:sunrise/services/getIt/get_it_dependencies.dart';

class MoodMatchingSlider extends StatefulWidget {
  const MoodMatchingSlider({
    Key? key,
    required this.lover,
    required this.moodMatch,
    required this.edit,
  }) : super(key: key);
  final LoverEntity lover;
  final MoodMatchingEntity moodMatch;
  final bool edit;

  @override
  State<MoodMatchingSlider> createState() => _MoodMatchingSliderState();
}

class _MoodMatchingSliderState extends State<MoodMatchingSlider> {
  final LobbyController lobbyController = getIt<LobbyController>();
  final TextEditingController commentController = TextEditingController();
  final ValueNotifier<bool> edditingNotifier = ValueNotifier<bool>(false);
  final FocusNode edditingFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ViewModelMood viewModelMoodMatching = ViewModelMood(
      state: MoodState(
        lover: widget.lover,
        moodMatching: widget.moodMatch,
      ),
      lobbyID: lobbyController.value.lobby.id,
    );
    commentController.text = viewModelMoodMatching.state.moodMatching.comment;

    return StreamBuilder(
      stream: viewModelMoodMatching.listenMood(),
      builder: (context, AsyncSnapshot<MoodMatchingEntity> snap) {
        if (!snap.hasData) {
          viewModelMoodMatching.state.moodMatching = MoodMatchingEntity(
            mood1: widget.moodMatch.mood1,
            mood2: widget.moodMatch.mood2,
            matching: 5,
            pack: widget.moodMatch.pack,
          );
        } else {
          viewModelMoodMatching.state.moodMatching = snap.data!;
          commentController.text =
              viewModelMoodMatching.state.moodMatching.comment;
        }
        double leftOpacity =
            viewModelMoodMatching.state.moodMatching.matching.toInt() >=
                    viewModelMoodMatching.state.moodMatching.max / 2
                ? 1
                : 0.1;
        double rightOpacity =
            viewModelMoodMatching.state.moodMatching.matching.toInt() <=
                    viewModelMoodMatching.state.moodMatching.max / 2
                ? 1
                : 0.1;
        Color thumbColor = sliderGradientColors[
            viewModelMoodMatching.state.moodMatching.matching.toInt()];
        Color slideLeftColor = sliderGradientColors[
                viewModelMoodMatching.state.moodMatching.matching.toInt()]
            .withOpacity(leftOpacity);
        Color slideRightColor = sliderGradientColors[
                viewModelMoodMatching.state.moodMatching.matching.toInt()]
            .withOpacity(rightOpacity);
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 15),
          height: 160,
          decoration: BoxDecoration(
            color: viewModelMoodMatching.state.moodMatching.favorite
                ? Colors.amber.withOpacity(0.05)
                : Colors.grey.withOpacity(0.1),
            border: Border.symmetric(
              horizontal: BorderSide(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
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
                          border: Border.all(
                            color: sliderGradientColors.first.withOpacity(0.5),
                          ),
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
                              inactiveColor: slideLeftColor,
                              activeColor: slideRightColor,
                              thumbColor: thumbColor,
                              label: viewModelMoodMatching
                                  .state.moodMatching.matching
                                  .toString(),
                              value: viewModelMoodMatching
                                  .state.moodMatching.matching,
                              min: viewModelMoodMatching.state.moodMatching.min,
                              max: viewModelMoodMatching.state.moodMatching.max,
                              divisions: (viewModelMoodMatching
                                          .state.moodMatching.max -
                                      viewModelMoodMatching
                                          .state.moodMatching.min)
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
                          border: Border.all(
                            color: sliderGradientColors.last.withOpacity(0.5),
                          ),
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
              /*     Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    color: viewModelMoodMatching.state.moodMatching.favorite
                        ? Colors.amber.withOpacity(0.4)
                        : Colors.grey.withOpacity(0.1),
                    height: 1,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (widget.edit) {
                        viewModelMoodMatching.updateFavorite(
                          !viewModelMoodMatching.state.moodMatching.favorite,
                        );
                      }
                    },
                    child: Icon(
                      Icons.star,
                      color: viewModelMoodMatching.state.moodMatching.favorite
                          ? Colors.amber
                          : Colors.grey,
                      size: 20,
                    ),
                  ),
                ],
              ), */
              ValueListenableBuilder(
                valueListenable: edditingNotifier,
                builder: (context, value, _) {
                  return AnimatedContainer(
                    transform: Matrix4.translationValues(
                      viewModelMoodMatching
                                  .state.moodMatching.comment.isNotEmpty ||
                              value
                          ? 30
                          : MediaQuery.of(context).size.width / 2,
                      0,
                      0,
                    ),
                    duration: const Duration(milliseconds: 300),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (widget.edit) {
                              edditingNotifier.value = !value;
                            }
                          },
                          child: Icon(
                            Icons.message,
                            color: viewModelMoodMatching
                                    .state.moodMatching.favorite
                                ? Colors.amber
                                : Colors.grey,
                            size: 20,
                          ),
                        ),
                        viewModelMoodMatching
                                    .state.moodMatching.comment.isNotEmpty ||
                                value
                            ? Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 10,
                                    right: 50,
                                  ),
                                  child: TextFormField(
                                    focusNode: edditingFocusNode,
                                    onTapOutside: (event) {
                                      if (widget.edit) {
                                        edditingFocusNode.unfocus();
                                        viewModelMoodMatching.updateComment(
                                          commentController.text,
                                        );
                                      }
                                    },
                                    onFieldSubmitted: (text) {
                                      if (widget.edit) {
                                        edditingFocusNode.unfocus();
                                        viewModelMoodMatching
                                            .updateComment(text);
                                      }
                                    },
                                    controller: commentController,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
