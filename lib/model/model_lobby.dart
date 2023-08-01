import 'package:sunrise/model/model_lover.dart';

class LobbyEntity {
  List<Lover> lovers = [];
  String id = '';
  String get simpleId {
    if (id.isNotEmpty) {
      var tid = (id.substring(3, 4) +
              id.substring(6, 7) +
              id.substring(9, 10) +
              id.substring(12, 13) +
              id.substring(15, 16))
          .toUpperCase();
      return tid;
    }
    return id;
  }

  int maxLovers = 2;

  LobbyEntity({
    required this.lovers,
  });

  LobbyEntity.empty() {
    for (var i = 0; i < maxLovers; i++) {
      lovers.add(Lover());
    }
  }

  bool isFull() {
    for (var i = 0; i < lovers.length; i++) {
      if (lovers[i].id.isEmpty) {
        return false;
      }
    }
    return true;
  }

  bool isEmpty() {
    for (var i = 0; i < lovers.length; i++) {
      if (lovers[i].id.isNotEmpty) {
        return false;
      }
    }
    return true;
  }

  bool haveRoom() {
    for (var i = 0; i < lovers.length; i++) {
      if (lovers[i].id.isEmpty) {
        return true;
      }
    }
    return false;
  }

  bool isLoverInLobby(Lover lover) {
    if (lovers.isNotEmpty) {
      for (Lover l in lovers) {
        if (l.id == lover.id) {
          return true;
        }
      }
    }
    return false;
  }

  void addLover(Lover lover) {
    for (var i = 0; i < lovers.length; i++) {
      if (lovers[i].id.isEmpty) {
        lovers[i] = lover;
        return;
      }
    }
  }

  void removeLover(Lover lover) {
    for (var i = 0; i < lovers.length; i++) {
      if (lovers[i].id == lover.id) {
        lovers[i] = Lover();
        return;
      }
    }
  }

  Lover couple(String myId) {
    if (lovers.length == 2) {
      if (lovers[0].id.isNotEmpty && lovers[1].id.isNotEmpty) {
        if (lovers[0].id == myId) {
          return lovers[1];
        } else {
          return lovers[0];
        }
      }
    }
    return Lover();
  }

  LobbyEntity.fromJson(Map<String, dynamic> json)
      : lovers = [
          Lover(
            id: json['lover1'] ?? '',
            name: json['lover1name'] ?? '',
            photoURL: json['lover1photoURL'] ?? '',
            email: json['lover1email'] ?? '',
          ),
          Lover(
            id: json['lover2'] ?? '',
            name: json['lover2name'] ?? '',
            photoURL: json['lover2photoURL'] ?? '',
            email: json['lover2email'] ?? '',
          ),
        ];

  Map<String, dynamic> toJson() => {
        for (var i = 0; i < lovers.length; i++) 'lover${i + 1}': lovers[i].id,
        for (var i = 0; i < lovers.length; i++)
          'lover${i + 1}name': lovers[i].name,
        'simpleID': simpleId.toUpperCase(),
        for (var i = 0; i < lovers.length; i++)
          'lover${i + 1}photoURL': lovers[i].photoURL,
        for (var i = 0; i < lovers.length; i++)
          'lover${i + 1}email': lovers[i].email,
      };
}
