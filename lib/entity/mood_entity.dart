class MoodEntity {
  String name;
  String iconName;
  String title;
  final String iconPath = 'assets/moods/';

  get icon => iconPath + iconName;

  MoodEntity({
    required this.name,
    required this.title,
    this.iconName = '',
  });
}
