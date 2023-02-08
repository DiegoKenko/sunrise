import 'package:sunrise/model/model_lover.dart';

class Lobby {
  Lover lover1;
  Lover? lover2;
  String id = '';

  Lobby({
    required this.lover1,
    this.lover2,
  });

  bool isFull() {
    if (lover2 != null) {
      if (lover2!.id.isNotEmpty) {
        return true;
      }
    }
    return false;
  }

  bool haveRoom() {
    if (lover2 != null) {
      if (lover2!.id.isNotEmpty) {
        return false;
      }
    }
    return true;
  }

  void addLover(Lover lover) {
    if (lover1.id != lover.id && lover2 != null) {
      if (lover2!.id.isEmpty) {
        lover2 = lover;
      }
    }
  }

  Lobby.fromJson(Map<String, dynamic> json)
      : lover1 = Lover(id: json['lover1']),
        lover2 = Lover(id: json['lover2']);

  Map<String, dynamic> toJson() => {
        'lover1': lover1.id,
        'lover2': lover2 != null ? lover2?.id : '',
      };
}
