import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sunrise/datasource/data_provider_lover.dart';
import 'package:sunrise/entity/lobby_entity.dart';
import 'package:sunrise/services/getIt/get_it_dependencies.dart';

class LobbyWatchDatasource {
  Stream<LobbyEntity> call(LobbyEntity lobby) async* {
    StreamController<LobbyEntity> lobbyStream = StreamController<LobbyEntity>();
    Stream<DocumentSnapshot<Map<String, dynamic>>> stream =
        getIt<FirebaseFirestore>()
            .collection('lobby')
            .doc(lobby.id)
            .snapshots();

    yield* stream.map<LobbyEntity>((event) {
      lobby = LobbyEntity.fromJson(event.data()!);
      lobby.id = event.id;
      lobbyStream.add(lobby);
      return lobby;
    });
  }
}
