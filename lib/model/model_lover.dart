class Lover {
  String name;
  String id = '';
  int age;
  String lobbyId = '';
  Lover({
    this.name = '',
    this.age = 0,
    this.id = '',
  });

  Lover.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        age = json['age'],
        lobbyId = json['lobbyId'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'age': age,
        'lobbyId': lobbyId,
      };
}
