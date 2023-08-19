import 'package:firebase_auth/firebase_auth.dart';

class LoverEntity {
  String name = '';
  String id = '';
  String lobbyId = '';
  String email = '';
  String photoURL = '';
  String notificationToken = '';
  int suns = 0;

  int get sunsCount => suns;
  set sunsCount(int suns) => this.suns = suns;

  LoverEntity({
    this.name = '',
    this.id = '',
    this.email = '',
    this.photoURL = '',
  });

  LoverEntity.fromUser(User user) {
    name = user.displayName ?? '';
    id = user.uid;
    email = user.email ?? '';
    photoURL = user.photoURL ?? '';
  }

  LoverEntity.empty({
    this.name = '',
    this.id = '',
    this.email = '',
    this.photoURL = '',
  });

  LoverEntity.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        email = json['email'],
        photoURL = json['photoURL'],
        lobbyId = json['lobbyId'],
        notificationToken = json['notificationToken'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'photoURL': photoURL,
        'lobbyId': lobbyId,
        'notificationToken': notificationToken,
      };

  set token(String? token) {
    notificationToken = token ?? '';
  }

  get isValid => name.isNotEmpty && id.isNotEmpty;

  void removeLobby() {
    lobbyId = '';
  }

  void addLobby(String lobbyId) {
    this.lobbyId = lobbyId;
  }
}
