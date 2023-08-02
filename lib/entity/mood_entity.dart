class MoodEntity {
  String name;
  String iconName;
  final String iconPath = 'assets/moods/';

  get icon => iconPath + iconName;

  MoodEntity({
    required this.name,
    this.iconName = '',
  });
}
