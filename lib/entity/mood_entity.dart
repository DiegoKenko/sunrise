class MoodEntity {
  String name;
  String iconName;
  //String unicode;
  final String iconPath = 'assets/moods/';

  get icon => iconPath + iconName;

  MoodEntity({
    required this.name,
    // required this.unicode,
    this.iconName = '',
  });
}
