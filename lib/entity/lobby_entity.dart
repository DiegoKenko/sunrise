import 'package:sunrise/entity/lover_entity.dart';

class LobbyEntity {
  List<LoverEntity> lovers = [];
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
      lovers.add(LoverEntity());
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

  bool isLoverInLobby(LoverEntity lover) {
    if (lovers.isNotEmpty) {
      for (LoverEntity l in lovers) {
        if (l.id == lover.id) {
          return true;
        }
      }
    }
    return false;
  }

  void addLover(LoverEntity lover) {
    for (var i = 0; i < lovers.length; i++) {
      if (lovers[i].id.isEmpty) {
        lovers[i] = lover;
        return;
      }
    }
  }

  void removeLover(LoverEntity lover) {
    for (var i = 0; i < lovers.length; i++) {
      if (lovers[i].id == lover.id) {
        lovers[i] = LoverEntity();
        return;
      }
    }
  }

  LoverEntity couple(String myId) {
    if (lovers.length == 2) {
      if (lovers[0].id.isNotEmpty && lovers[1].id.isNotEmpty) {
        if (lovers[0].id == myId) {
          return lovers[1];
        } else {
          return lovers[0];
        }
      }
    }
    return LoverEntity();
  }

  LoverEntity mySelf(String myId) {
    return lovers.firstWhere(
      (element) => element.id == myId,
      orElse: LoverEntity.empty,
    );
  }

  LobbyEntity.fromJson(Map<String, dynamic> json)
      : lovers = [
          LoverEntity(
            id: json['lover1'] ?? '',
            name: json['lover1name'] ?? '',
            email: json['lover1email'] ?? '',
          ),
          LoverEntity(
            id: json['lover2'] ?? '',
            name: json['lover2name'] ?? '',
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
