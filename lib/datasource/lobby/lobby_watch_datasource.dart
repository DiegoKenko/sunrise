import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sunrise/datasource/data_provider_lover.dart';
import 'package:sunrise/entity/lobby_entity.dart';
import 'package:sunrise/services/getIt/get_it_dependencies.dart';

class LobbyWatchDatasource {
  Stream<LobbyEntity> call(LobbyEntity lobby) async* {
    Stream<LobbyEntity> lobbyStream = const Stream.empty();
    Stream<DocumentSnapshot<Map<String, dynamic>>> stream =
        getIt<FirebaseFirestore>()
            .collection('lobby')
            .doc(lobby.id)
            .snapshots();
    stream.listen((event) async {
      if (event.exists) {
        lobby = LobbyEntity.fromJson(event.data()!);
        lobby.id = event.id;
        lobby.lovers[0] = await DataProviderLover().get(lobby.lovers[0].id);
        lobby.lovers[1] = await DataProviderLover().get(lobby.lovers[1].id);
        lobbyStream = const Stream.empty();
      }
    });
    yield* lobbyStream;
  }
}
