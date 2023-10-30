import 'package:sunrise/constants/enum/enum_mood_matching_pack.dart';
import 'package:sunrise/entity/mood_entity.dart';

class MoodMatchingEntity {
  MoodEntity mood1;
  MoodEntity mood2;
  double matching; // minimun of 1 to maximun of 10
  bool favorite;

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

  MoodMatchingEntity({
    required this.mood1,
    required this.mood2,
    this.matching = 5,
    this.favorite = false,
    required this.pack,
  });

  Map<String, dynamic> toJson() {
    return {
      'mood1': mood1.name,
      'mood1Icon': mood1.iconName,
      'mood2': mood2.name,
      'mood2Icon': mood2.iconName,
      'matching': matching,
      'favorite': favorite,
    };
  }

  MoodMatchingEntity.fromJson(Map<String, dynamic> json)
      : mood1 = MoodEntity(
          name: json['mood1'],
          iconName: json['mood1Icon'],
        ),
        mood2 = MoodEntity(
          name: json['mood2'],
          iconName: json['mood2Icon'],
        ),
        pack = MoodMatchingPack.defaultPack,
        matching = json['matching'],
        favorite = json['favorite'] ?? false;

  @override
  String toString() {
    return 'MoodMatchingEntity{mood1: $mood1, mood2: $mood2, matching: $matching}';
  }

  set setMatching(double match) {
    matching = match;
  }
}
