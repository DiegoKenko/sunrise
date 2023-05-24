import 'package:sunrise/constants/enum/enum_mood_matching_pack.dart';
import 'package:sunrise/model/model_mood.dart';

class MoodMatching {
  Mood mood1;
  Mood mood2;
  double matching; // minimun of 1 to maximun of 10
  String get matchId => mood1.name.toLowerCase() + mood2.name.toLowerCase();

  double get max => 10;
  double get min => 1;
  bool get isLessThanHalf => matching < 5.5;
  MoodMatchingPack pack;
  bool packAllowed(MoodMatchingPack userPack) {
    if (userPack == pack || userPack == MoodMatchingPack.goldPack) {
      return true;
    }
    if ((userPack == MoodMatchingPack.silverPack ||
            userPack == MoodMatchingPack.defaultPack) &&
        pack == MoodMatchingPack.goldPack) {
      return false;
    }
    if (userPack == MoodMatchingPack.silverPack &&
        pack == MoodMatchingPack.defaultPack) {
      return true;
    }
    return false;
  }

  MoodMatching({
    required this.mood1,
    required this.mood2,
    this.matching = 5,
    required this.pack,
  });

  Map<String, dynamic> toJson() {
    return {
      'mood1': mood1.name,
      'mood1Icon': mood1.iconName,
      'mood2': mood2.name,
      'mood2Icon': mood2.iconName,
      'matching': matching,
    };
  }

  MoodMatching.fromJson(Map<String, dynamic> json)
      : mood1 = Mood(
          name: json['mood1'],
          iconName: json['mood1Icon'],
        ),
        mood2 = Mood(
          name: json['mood2'],
          iconName: json['mood2Icon'],
        ),
        pack = MoodMatchingPack.defaultPack,
        matching = json['matching'];

  @override
  String toString() {
    return 'MoodMatching{mood1: $mood1, mood2: $mood2, matching: $matching}';
  }

  set setMatching(double match) {
    matching = match;
  }
}
