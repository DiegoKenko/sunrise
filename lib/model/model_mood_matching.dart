import 'package:sunrise/model/model_mood.dart';

class MoodMatching {
  Mood mood1;
  Mood mood2;
  String get matchId => mood1.name.toLowerCase() + mood2.name.toLowerCase();
  int matching; // minimun of 1 to maximun of 10

  MoodMatching({
    required this.mood1,
    required this.mood2,
    this.matching = 5,
  });

  Map<String, dynamic> toJson() {
    return {
      'mood1': mood1.name,
      'mood2': mood2.name,
      'matching': matching,
    };
  }

  MoodMatching.fromJson(Map<String, dynamic> json)
      : mood1 = Mood(name: json['mood1']),
        mood2 = Mood(name: json['mood2']),
        matching = json['matching'];

  set setMatching(int match) {
    matching = match;
  }
}
