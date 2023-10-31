import 'package:flutter/material.dart';
import 'package:sunrise/datasource/mock_moods.dart';
import 'package:sunrise/interface/controllers/auth/auth_controller.dart';

import 'package:sunrise/entity/lover_entity.dart';
import 'package:sunrise/interface/screens/relationship/tab_mood_matching_slider.dart';
import 'package:sunrise/services/getIt/get_it_dependencies.dart';

class TabMood extends StatefulWidget {
  const TabMood({
    Key? key,
    required this.lover,
  }) : super(key: key);
  final LoverEntity lover;
  @override
  State<TabMood> createState() => _TabMoodState();
}

class _TabMoodState extends State<TabMood> {
  @override
  Widget build(BuildContext context) {
    final AuthController authService = getIt<AuthController>();
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return MoodMatchingSlider(
          edit: authService.lover.id == widget.lover.id,
          lover: widget.lover,
          moodMatch: mockMoodMatching[index],
        );
      },
      itemCount: mockMoodMatching.length,
    );
  }
}
