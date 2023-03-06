import 'package:firebase_auth/firebase_auth.dart';

class Lover {
  String name = '';
  String id = '';
  String lobbyId = '';
  String email = '';
  String photoURL = '';
  String notificationToken = '';

  Lover({
    this.name = '',
    this.id = '',
    this.email = '',
    this.photoURL = '',
  });

  Lover.fromUser(User user) {
    name = user.displayName ?? '';
    id = user.uid;
    email = user.email ?? '';
    photoURL = user.photoURL ?? '';
  }

  Lover.empty({
    this.name = '',
    this.id = '',
    this.email = '',
    this.photoURL = '',
  });

  Lover.fromJson(Map<String, dynamic> json)
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

  set token(String token) {
    notificationToken = token;
  }
}
