import 'package:sunrise/model/model_lover.dart';

class Lobby {
  List<Lover> lovers = [];
  String id = '';
  String get simpleId => (id.substring(3) +
          id.substring(6) +
          id.substring(9) +
          id.substring(11) +
          id.substring(13))
      .toUpperCase();
  int maxLovers = 2;

  Lobby({
    required this.lovers,
  });

  Lobby.empty() {
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

  Lobby.fromJson(Map<String, dynamic> json)
      : lovers = [
          Lover(id: json['lover1'] ?? ''),
          Lover(id: json['lover2'] ?? ''),
        ];

  Map<String, dynamic> toJson() => {
        for (var i = 0; i < lovers.length; i++) 'lover${i + 1}': lovers[i].id,
        'simpleID': simpleId.toUpperCase(),
      };
}
