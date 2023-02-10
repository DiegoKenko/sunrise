class Lover {
  String name;
  String id = '';
  String lobbyId = '';
  String email = '';

  Lover({
    this.name = '',
    this.id = '',
  });

  Lover.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        email = json['email'],
        lobbyId = json['lobbyId'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'lobbyId': lobbyId,
      };
}
