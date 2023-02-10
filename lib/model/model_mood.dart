class Mood {
  String name;
  String iconName;
  final String iconPath = 'assets/moods/';

  get icon => iconPath + iconName;

  Mood({
    required this.name,
    this.iconName = '',
  });
}
