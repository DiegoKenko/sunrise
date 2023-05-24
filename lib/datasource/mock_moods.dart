import 'package:sunrise/constants/enum/enum_mood_matching_pack.dart';
import 'package:sunrise/model/model_mood.dart';
import 'package:sunrise/model/model_mood_matching.dart';

List<MoodMatching> mockMoodMatching = [
  MoodMatching(
    mood1: Mood(
      name: 'Sad',
      iconName: 'sad.png',
    ),
    mood2: Mood(
      name: 'Happy',
      iconName: 'happy.png',
    ),
    matching: 5,
    pack: MoodMatchingPack.defaultPack,
  ),
  MoodMatching(
    mood1: Mood(
      name: 'heartbrake',
      iconName: 'heartbrake.png',
    ),
    mood2: Mood(
      name: 'love',
      iconName: 'love.png',
    ),
    matching: 5,
    pack: MoodMatchingPack.defaultPack,
  ),
  MoodMatching(
    mood1: Mood(
      name: 'calm',
      iconName: 'calm.png',
    ),
    mood2: Mood(
      name: 'rage',
      iconName: 'rage.png',
    ),
    matching: 5,
    pack: MoodMatchingPack.defaultPack,
  ),
  MoodMatching(
    mood1: Mood(
      name: 'loud',
      iconName: 'loud.png',
    ),
    mood2: Mood(
      name: 'mute',
      iconName: 'mute.png',
    ),
    matching: 5,
    pack: MoodMatchingPack.defaultPack,
  ),
  /* MoodMatching(
    mood1: Mood(
      name: 'laughing',
      iconName: 'laughing.png',
    ),
    mood2: Mood(
      name: 'sad',
      iconName: 'sad.png',
    ),
    matching: 5,
  ), */
  MoodMatching(
    mood1: Mood(
      name: 'Ahn',
      iconName: 'ahn.png',
    ),
    mood2: Mood(
      name: 'Eye side',
      iconName: 'eyesside.png',
    ),
    matching: 5,
    pack: MoodMatchingPack.defaultPack,
  ),
  MoodMatching(
    mood1: Mood(
      name: 'lovely',
      iconName: 'lovely.png',
    ),
    mood2: Mood(
      name: 'sad',
      iconName: 'sad.png',
    ),
    matching: 5,
    pack: MoodMatchingPack.defaultPack,
  ),
  MoodMatching(
    mood1: Mood(
      name: 'excited',
      iconName: 'excited.png',
    ),
    mood2: Mood(
      name: 'snooze',
      iconName: 'snooze.png',
    ),
    matching: 5,
    pack: MoodMatchingPack.defaultPack,
  ),
  MoodMatching(
    mood1: Mood(
      name: 'BadLuck',
      iconName: 'badluck.png',
    ),
    mood2: Mood(
      name: 'lucky',
      iconName: 'lucky.png',
    ),
    matching: 5,
    pack: MoodMatchingPack.silverPack,
  ),
  MoodMatching(
    mood1: Mood(
      name: 'beer',
      iconName: 'beer.png',
    ),
    mood2: Mood(
      name: 'wine',
      iconName: 'wine.png',
    ),
    matching: 5,
    pack: MoodMatchingPack.silverPack,
  ),
  MoodMatching(
    mood1: Mood(
      name: 'bikini',
      iconName: 'bikini.png',
    ),
    mood2: Mood(
      name: 'dress',
      iconName: 'dress.png',
    ),
    matching: 5,
    pack: MoodMatchingPack.silverPack,
  ),
  MoodMatching(
    mood1: Mood(
      name: 'cheers',
      iconName: 'cheers.png',
    ),
    mood2: Mood(
      name: 'pray',
      iconName: 'pray.png',
    ),
    matching: 5,
    pack: MoodMatchingPack.silverPack,
  ),
  MoodMatching(
    mood1: Mood(
      name: 'confused',
      iconName: 'confused.png',
    ),
    mood2: Mood(
      name: 'think',
      iconName: 'think.png',
    ),
    matching: 5,
    pack: MoodMatchingPack.silverPack,
  ),
  MoodMatching(
    mood1: Mood(
      name: 'house',
      iconName: 'house.png',
    ),
    mood2: Mood(
      name: 'travel',
      iconName: 'travel.png',
    ),
    matching: 5,
    pack: MoodMatchingPack.silverPack,
  ),
  MoodMatching(
    mood1: Mood(
      name: 'drooling',
      iconName: 'drooling.png',
    ),
    mood2: Mood(
      name: 'nause',
      iconName: 'nause.png',
    ),
    matching: 5,
    pack: MoodMatchingPack.silverPack,
  ),
  MoodMatching(
    mood1: Mood(
      name: 'expressionless',
      iconName: 'expressionless.png',
    ),
    mood2: Mood(
      name: 'smirk',
      iconName: 'smirk.png',
    ),
    matching: 5,
    pack: MoodMatchingPack.silverPack,
  ),
  MoodMatching(
    mood1: Mood(
      name: 'fit',
      iconName: 'fit.png',
    ),
    mood2: Mood(
      name: 'hamburger',
      iconName: 'hamburger.png',
    ),
    matching: 5,
    pack: MoodMatchingPack.silverPack,
  ),
  MoodMatching(
    mood1: Mood(
      name: 'lazy',
      iconName: 'lazy.png',
    ),
    mood2: Mood(
      name: 'partyface',
      iconName: 'partyface.png',
    ),
    matching: 5,
    pack: MoodMatchingPack.silverPack,
  ),
  MoodMatching(
    mood1: Mood(
      name: 'chick',
      iconName: 'chick.png',
    ),
    mood2: Mood(
      name: 'frog',
      iconName: 'frog.png',
    ),
    matching: 5,
    pack: MoodMatchingPack.goldPack,
  ),
  MoodMatching(
    mood1: Mood(
      name: 'cold',
      iconName: 'cold.png',
    ),
    mood2: Mood(
      name: 'fire',
      iconName: 'fire.png',
    ),
    matching: 5,
    pack: MoodMatchingPack.goldPack,
  ),
  MoodMatching(
    mood1: Mood(
      name: 'coldface',
      iconName: 'coldface.png',
    ),
    mood2: Mood(
      name: 'hotface',
      iconName: 'hotface.png',
    ),
    matching: 5,
    pack: MoodMatchingPack.goldPack,
  ),

  /* MoodMatching(
    mood1: Mood(
      name: 'crazy',
      iconName: 'crazy.png',
    ),
    mood2: Mood(
      name: 'worried',
      iconName: 'worried.png',
    ),
    matching: 5,
  ), */
  MoodMatching(
    mood1: Mood(
      name: 'dirty',
      iconName: 'dirty.png',
    ),
    mood2: Mood(
      name: 'shower',
      iconName: 'shower.png',
    ),
    matching: 5,
    pack: MoodMatchingPack.goldPack,
  ),
  MoodMatching(
    mood1: Mood(
      name: 'handshake',
      iconName: 'handshake.png',
    ),
    mood2: Mood(
      name: 'middlefinger',
      iconName: 'middlefinger.png',
    ),
    matching: 5,
    pack: MoodMatchingPack.goldPack,
  ),
  /* MoodMatching(
    mood1: Mood(
      name: 'house',
      iconName: 'house.png',
    ),
    mood2: Mood(
      name: 'party',
      iconName: 'party.png',
    ),
    matching: 5,
  ), */

  /*  MoodMatching(
    mood1: Mood(
      name: 'nophone',
      iconName: 'nophone.png',
    ),
    mood2: Mood(
      name: 'allowphone',
      iconName: 'phone.png',
    ),
    matching: 5,
  ), */
  MoodMatching(
    mood1: Mood(
      name: 'poor',
      iconName: 'poor.png',
    ),
    mood2: Mood(
      name: 'rich',
      iconName: 'rich.png',
    ),
    matching: 5,
    pack: MoodMatchingPack.goldPack,
  ),
];
